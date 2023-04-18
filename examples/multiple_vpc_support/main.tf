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

module "google_zeek_automation" {
  source     = "../.."
  project_id = var.project_id

  collector_vpc_name = "collector-vpc"

  subnets = [
    {
      mirror_vpc_network          = module.network1.network_id
      collector_vpc_subnet_cidr   = module.network1.subnets_ips[0]
      collector_vpc_subnet_region = module.network1.subnets_regions[0]
    },
    {
      mirror_vpc_network          = module.network2.network_id
      collector_vpc_subnet_cidr   = module.network2.subnets_ips[0]
      collector_vpc_subnet_region = module.network2.subnets_regions[0]
    },
    {
      mirror_vpc_network          = module.network3.network_id
      collector_vpc_subnet_cidr   = module.network3.subnets_ips[0]
      collector_vpc_subnet_region = module.network3.subnets_regions[0]
    },
    {
      mirror_vpc_network          = module.network4.network_id
      collector_vpc_subnet_cidr   = module.network4.subnets_ips[0]
      collector_vpc_subnet_region = module.network4.subnets_regions[0]
    },
    # Note: For each mirror VPC and regions, user needs to repeat above block accordingly.
  ]

  mirror_vpc_subnets = {
    "${var.project_id}--${module.network1.network_name}--${module.network1.subnets_regions[0]}" = [module.network1.subnets_ids[0]],
    "${var.project_id}--${module.network2.network_name}--${module.network2.subnets_regions[0]}" = [module.network2.subnets_ids[0]],
    "${var.project_id}--${module.network3.network_name}--${module.network3.subnets_regions[0]}" = [module.network3.subnets_ids[0]],
    "${var.project_id}--${module.network4.network_name}--${module.network4.subnets_regions[0]}" = [module.network4.subnets_ids[0]],
  }

  mirror_vpc_instances = {
    "${var.project_id}--${module.network1.network_name}--${module.network1.subnets_regions[0]}" = [google_compute_instance.instance1.id]
    "${var.project_id}--${module.network2.network_name}--${module.network2.subnets_regions[0]}" = [google_compute_instance.instance2.id]
    "${var.project_id}--${module.network3.network_name}--${module.network3.subnets_regions[0]}" = [google_compute_instance.instance3.id]
    "${var.project_id}--${module.network4.network_name}--${module.network4.subnets_regions[0]}" = [google_compute_instance.instance4.id]
    # Note: Allowed only if mirror and collector vpc are in same project.
  }

  mirror_vpc_tags = {
    "${var.project_id}--${module.network1.network_name}--${module.network1.subnets_regions[0]}" = ["test-tag-1"]
    "${var.project_id}--${module.network2.network_name}--${module.network2.subnets_regions[0]}" = ["test-tag-2"]
    "${var.project_id}--${module.network3.network_name}--${module.network3.subnets_regions[0]}" = ["test-tag-3"]
    "${var.project_id}--${module.network4.network_name}--${module.network4.subnets_regions[0]}" = ["test-tag-4"]
  }

  # Packet Mirroring Traffic Filtering
  ip_protocols = ["tcp","udp"] # Protocols that apply as a filter on mirrored traffic. Possible values: ["tcp", "udp", "icmp"]
  direction    = "BOTH"        # Direction of traffic to mirror. Possible values: "INGRESS", "EGRESS", "BOTH"
  cidr_ranges  = ["0.0.0.0/0"] # "IP CIDR ranges that apply as a filter on the source (ingress) or destination (egress) IP in the IP header."
}

module "network1" {
  source  = "terraform-google-modules/network/google"
  version = "~> 7.0.0"

  project_id   = var.project_id
  network_name = "example-mirrored-vpc-1"

  subnets = [
    {
      subnet_name           = "subnet-01"
      subnet_ip             = "10.10.10.0/24"
      subnet_region         = "us-west1"
    }
  ]
}

module "network2" {
  source  = "terraform-google-modules/network/google"
  version = "~> 7.0.0"

  project_id   = var.project_id
  network_name = "example-mirrored-vpc-2"

  subnets = [
    {
      subnet_name           = "subnet-02"
      subnet_ip             = "10.10.20.0/24"
      subnet_region         = "us-west2"
    }
  ]
}

module "network3" {
  source  = "terraform-google-modules/network/google"
  version = "~> 7.0.0"

  project_id   = var.project_id
  network_name = "example-mirrored-vpc-3"

  subnets = [
    {
      subnet_name           = "subnet-03"
      subnet_ip             = "10.10.30.0/24"
      subnet_region         = "us-central1"
    }
  ]
}

module "network4" {
  source  = "terraform-google-modules/network/google"
  version = "~> 7.0.0"

  project_id   = var.project_id
  network_name = "example-mirrored-vpc-4"

  subnets = [
    {
      subnet_name           = "subnet-04"
      subnet_ip             = "10.10.40.0/24"
      subnet_region         = "us-east4"
    }
  ]
}

resource "google_compute_instance" "instance1" {
  project      = var.project_id
  zone         = "us-west1-a"
  name         = "instance1"
  machine_type = "e2-medium"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    network = module.network1.network_name
  }
  tags = ["test-tag-1"]
}

resource "google_compute_instance" "instance2" {
  project      = var.project_id
  zone         = "us-west2-a"
  name         = "instance2"
  machine_type = "e2-medium"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    network = module.network2.network_name
  }
  tags = ["test-tag-2"]
}

resource "google_compute_instance" "instance3" {
  project      = var.project_id
  zone         = "us-central1-b"
  name         = "instance3"
  machine_type = "e2-medium"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    network = module.network3.network_name
  }
  tags = ["test-tag-3"]
}

resource "google_compute_instance" "instance4" {
  project      = var.project_id
  zone         = "us-east4-a"
  name         = "instance4"
  machine_type = "e2-medium"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    network = module.network4.network_name
  }
  tags = ["test-tag-4"]
}