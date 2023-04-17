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
  source                = "../.."
  project_id            = var.project_id

  collector_vpc_name = "collector-vpc"
  subnets = [
    {
      mirror_vpc_network          = "projects/mirror-project-123/global/networks/test-mirror"
      collector_vpc_subnet_cidr   = "10.11.0.0/24"
      collector_vpc_subnet_region = "us-west1"
    },
  ]

  mirror_vpc_subnets = {
    "mirror-project-123--mirror_vpc_name--us-west1" = ["projects/mirror-project-123/regions/us-west1/subnetworks/subnet-01"]
  }
}
