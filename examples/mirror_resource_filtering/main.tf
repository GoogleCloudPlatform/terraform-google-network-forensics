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
    # For each mirror VPC and regions, user needs to repeat below block accordingly.
    {
      mirror_vpc_network          = module.network.network_id
      collector_vpc_subnet_cidr   = module.network.subnets_ips[0]
      collector_vpc_subnet_region = module.network.subnets_regions[0]
    },
  ]

  # Mirror Resource Filtering
  mirror_vpc_subnets = {
    "${var.project_id}--${module.network.network_name}--${module.network.subnets_regions[0]}" = [module.network.subnets_ids[0]]
  }
  # Allowed only if mirror and collector vpc are in same project.
  mirror_vpc_instances = {
    "${var.project_id}--${module.network.network_name}--${module.network.subnets_regions[0]}" = [google_compute_instance.instance1.id]

  }
  mirror_vpc_tags = {
    "${var.project_id}--${module.network.network_name}--${module.network.subnets_regions[0]}" = ["test-tag-1"]
  }
}

module "network" {
  source  = "terraform-google-modules/network/google"
  version = "~> 7.0.0"

  project_id   = var.project_id
  network_name = "example-mirrored-vpc"

  subnets = [
    {
      subnet_name           = "subnet-01"
      subnet_ip             = "10.10.10.0/24"
      subnet_region         = "us-west1"
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
    network = module.network.network_name
  }
  tags = ["test-tag-1"]
}
