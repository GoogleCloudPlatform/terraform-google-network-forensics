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
      mirror_vpc_network          = module.network.network_id
      collector_vpc_subnet_cidr   = module.network.subnets_ips[0]
      collector_vpc_subnet_region = module.network.subnets_regions[0]
    },
  ]

  mirror_vpc_subnets = {
    "${var.project_id}--${module.network.network_name}--${module.network.subnets_regions[0]}" = [module.network.subnets_ids[0]]
  }
}

module "network" {
  source  = "terraform-google-modules/network/google"
  version = "~> 7.0.0"

  project_id   = var.project_id
  network_name = "example-mirrored-vpc"

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "us-west1"
    }
  ]
}
