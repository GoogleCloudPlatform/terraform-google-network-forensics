/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


locals {
  mirror_vpc_network_id = distinct([for subnet in var.subnets : subnet.mirror_vpc_network])

  packet_mirroring_mirror_subnet_sources   = var.mirror_vpc_subnets
  packet_mirroring_mirror_tag_sources      = var.mirror_vpc_tags
  packet_mirroring_mirror_instance_sources = var.mirror_vpc_instances

  collector_vpc_name = var.collector_vpc_name
  collector_vpc_subnets = {
    for subnet in var.subnets : "${element(split("/", subnet.mirror_vpc_network), 1)}--${element(split("/", subnet.mirror_vpc_network), 4)}--${subnet.collector_vpc_subnet_region}" => subnet
  }

  collector_vpc_subnets_cidrs = {
    for subnet in var.subnets : "${element(split("/", subnet.mirror_vpc_network), 1)}--${element(split("/", subnet.mirror_vpc_network), 4)}--${subnet.collector_vpc_subnet_region}" => subnet.collector_vpc_subnet_cidr
  }

  subnet_key_count = [
    for key in var.subnets : "${element(split("/", key.mirror_vpc_network), 1)}--${element(split("/", key.mirror_vpc_network), 4)}--${key.collector_vpc_subnet_region}"
  ]

  same_project_mirror_networks = [for network in local.mirror_vpc_network_id : network if element(split("/", network), 1) == var.project_id]
}

# -------------------------------------------------------------- #
# VPC NETWORK
# -------------------------------------------------------------- #

resource "google_compute_network" "main" {
  name                            = local.collector_vpc_name
  project                         = var.project_id
  routing_mode                    = var.vpc_routing_mode
  description                     = var.vpc_description
  auto_create_subnetworks         = var.auto_create_subnetworks
  delete_default_routes_on_create = var.delete_default_internet_gateway_routes
  mtu                             = var.mtu
}


resource "google_compute_subnetwork" "main" {
  for_each                 = local.collector_vpc_subnets
  name                     = format("%s-%s-%02d", local.collector_vpc_name, "subnet", index(var.subnets, each.value) + 1)
  project                  = var.project_id
  ip_cidr_range            = each.value.collector_vpc_subnet_cidr
  region                   = each.value.collector_vpc_subnet_region
  private_ip_google_access = var.private_ip_google_access
  network                  = google_compute_network.main.self_link
  depends_on               = [google_compute_network.main]
}

# -------------------------------------------------------------- #
# FIREWALL-RULES
# -------------------------------------------------------------- #

resource "google_compute_firewall" "allow-health-check" {
  name      = "${local.collector_vpc_name}-rule-allow-health-check"
  project   = var.project_id
  network   = google_compute_network.main.name
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  depends_on    = [google_compute_subnetwork.main]
}

resource "google_compute_firewall" "allow_ingress" {
  name      = "${local.collector_vpc_name}-rule-allow-ingress"
  project   = var.project_id
  network   = google_compute_network.main.name
  direction = "INGRESS"
  allow {
    protocol = "all"
  }
  source_ranges = ["0.0.0.0/0"]
  depends_on    = [google_compute_subnetwork.main]
}

resource "google_compute_firewall" "allow_egress" {
  for_each  = toset(local.same_project_mirror_networks)
  name      = "${element(split("/", each.value), 4)}-rule-allow-egress"
  project   = var.project_id
  network   = element(split("/", each.value), 4)
  direction = "EGRESS"
  allow {
    protocol = "all"
  }
  destination_ranges = [for subnet in var.subnets : subnet.collector_vpc_subnet_cidr if subnet.mirror_vpc_network == each.value]
  depends_on         = [google_compute_subnetwork.main]
}

# -------------------------------------------------------------- #
# VPC-PEERING
# -------------------------------------------------------------- #

resource "google_compute_network_peering" "mirror_vpc_network_peering" {
  for_each             = toset(local.same_project_mirror_networks)
  name                 = format("%s-%s-%02d", "mirror-to-", local.collector_vpc_name, index(local.same_project_mirror_networks, each.key) + 1)
  network              = each.value
  peer_network         = google_compute_network.main.id
  export_custom_routes = var.export_local_custom_routes
  import_custom_routes = var.export_peer_custom_routes
  depends_on           = [google_compute_subnetwork.main, google_compute_firewall.allow_egress]
}

resource "google_compute_network_peering" "collector_vpc_network_peering" {
  for_each             = toset(local.mirror_vpc_network_id)
  name                 = format("%s-%s-%02d", local.collector_vpc_name, "to-mirror", index(local.mirror_vpc_network_id, each.key) + 1)
  network              = google_compute_network.main.id
  peer_network         = each.value
  export_custom_routes = var.export_peer_custom_routes
  import_custom_routes = var.export_local_custom_routes

  depends_on = [google_compute_subnetwork.main, google_compute_firewall.allow_egress, google_compute_network_peering.mirror_vpc_network_peering]
}

# -------------------------------------------------------------- #
# INSTANCE-TEMPLATE
# -------------------------------------------------------------- #

resource "google_compute_instance_template" "main" {
  for_each    = local.collector_vpc_subnets
  name        = format("%s-%02d", local.collector_vpc_name, index(var.subnets, each.value) + 1)
  project     = var.project_id
  description = var.template_description
  metadata_startup_script = templatefile(
    "${path.module}/files/startup_script.sh",
    {
      vpc_id         = each.value.mirror_vpc_network
      PROJECT_ID     = element(split("/", each.value.mirror_vpc_network), 1)
      VPC_NAME       = element(split("/", each.value.mirror_vpc_network), 4)
      IP_CIDRS       = format("0.0.0.0/0\tAll-Traffic\n"),
      COLLECTOR_CIDR = lookup(local.collector_vpc_subnets_cidrs, each.key)
  })

  machine_type   = var.machine_type
  can_ip_forward = false

  disk {
    source_image = var.golden_image
    auto_delete  = true
    boot         = true
  }

  # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform", "logging-write", "monitoring"]
  }

  network_interface {
    network    = google_compute_network.main.self_link
    subnetwork = google_compute_subnetwork.main[each.key].id
  }

  depends_on = [google_compute_subnetwork.main, google_compute_network_peering.collector_vpc_network_peering]
}

# -------------------------------------------------------------- #
# HEALTH-CHECK
# -------------------------------------------------------------- #

resource "google_compute_health_check" "main" {
  name                = "${local.collector_vpc_name}-http-health-check"
  project             = var.project_id
  description         = "Health check via http"
  timeout_sec         = 5
  check_interval_sec  = 10
  healthy_threshold   = 2
  unhealthy_threshold = 3

  http_health_check {
    port = 80
  }
  depends_on = [google_compute_instance_template.main]
}

# -------------------------------------------------------------- #
# MANAGED-INSTANCE-GROUP
# -------------------------------------------------------------- #

resource "google_compute_region_instance_group_manager" "main" {
  for_each           = google_compute_instance_template.main
  name               = format("%s-%02d", local.collector_vpc_name, index(local.subnet_key_count, each.key) + 1)
  region             = format("%s", element(split("--", each.key), 2))
  project            = var.project_id
  base_instance_name = "mig-instance"

  version {
    instance_template = each.value.id
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.main.id
    initial_delay_sec = 90
  }

  depends_on = [google_compute_instance_template.main, google_compute_health_check.main]
}

# -------------------------------------------------------------- #
# AUTO-SCALER
# -------------------------------------------------------------- #

resource "google_compute_region_autoscaler" "main" {
  for_each = google_compute_region_instance_group_manager.main
  name     = format("%s-%02d", local.collector_vpc_name, index(local.subnet_key_count, each.key) + 1)
  project  = var.project_id
  region   = format("%s", element(split("/", each.value.id), 3))
  target   = each.value.id

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 1
    cooldown_period = 240

    cpu_utilization {
      target = 0.75
    }
  }

  depends_on = [google_compute_region_instance_group_manager.main]
}

# -------------------------------------------------------------- #
# INTERNAL-LOAD-BALANCER
# -------------------------------------------------------------- #

resource "google_compute_region_backend_service" "main" {
  for_each              = google_compute_region_instance_group_manager.main
  name                  = format("%s-%02d", local.collector_vpc_name, index(local.subnet_key_count, each.key) + 1)
  project               = var.project_id
  region                = format("%s", element(split("/", each.value.instance_group), 8))
  health_checks         = [google_compute_health_check.main.id]
  load_balancing_scheme = "INTERNAL"

  backend {
    group = each.value.instance_group
  }

  depends_on = [google_compute_region_instance_group_manager.main, google_compute_region_autoscaler.main]
}

# -------------------------------------------------------------- #
# FORWARDING-RULE
# -------------------------------------------------------------- #

resource "google_compute_forwarding_rule" "main" {
  for_each               = google_compute_region_backend_service.main
  name                   = format("%s-%02d", local.collector_vpc_name, index(local.subnet_key_count, each.key) + 1)
  project                = var.project_id
  region                 = format("%s", element(split("/", each.value.id), 3))
  load_balancing_scheme  = "INTERNAL"
  backend_service        = each.value.id
  all_ports              = true
  allow_global_access    = false
  is_mirroring_collector = true
  network                = google_compute_network.main.self_link
  subnetwork             = google_compute_subnetwork.main[each.key].id
  depends_on             = [google_compute_region_backend_service.main]
}

# -------------------------------------------------------------- #
# PACKET-MIRRORING
# -------------------------------------------------------------- #

resource "google_compute_packet_mirroring" "main" {
  for_each = local.collector_vpc_subnets
  name     = format("%s-%02d", local.collector_vpc_name, index(local.subnet_key_count, each.key) + 1)
  project  = var.project_id
  region   = each.value.collector_vpc_subnet_region

  network {
    url = each.value.mirror_vpc_network
  }

  collector_ilb {
    url = google_compute_forwarding_rule.main[each.key].id
  }

  mirrored_resources {
    dynamic "subnetworks" {
      for_each = lookup(local.packet_mirroring_mirror_subnet_sources, each.key, [])
      content {
        url = subnetworks.value
      }
    }

    tags = lookup(local.packet_mirroring_mirror_tag_sources, each.key, [])

    dynamic "instances" {
      for_each = lookup(local.packet_mirroring_mirror_instance_sources, each.key, [])
      content {
        url = instances.value
      }
    }
  }

  filter {
    ip_protocols = var.ip_protocols
    direction    = var.direction
    cidr_ranges  = var.cidr_ranges
  }

  depends_on = [google_compute_forwarding_rule.main]
}
