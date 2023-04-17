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
      mirror_vpc_network          = "{{mirror_vpc_network}}"
      collector_vpc_subnet_cidr   = "{{subnet_cidr}}"
      collector_vpc_subnet_region = "{{region}}"
    },
    # Note: For each mirror VPC and regions, user needs to repeat above block accordingly.
  ]

  mirror_vpc_subnets = {
    "{{mirror_project_id--mirror_vpc_name--region}}" = ["{{subnet_id}}"]
  }


  # Packet Mirroring Traffic Filtering
  ip_protocols = ["{{protocol}}"]           # Protocols that apply as a filter on mirrored traffic. Possible values: ["tcp", "udp", "icmp"]
  direction    = "{{direction_of_traffic}}" # Direction of traffic to mirror. Possible values: "INGRESS", "EGRESS", "BOTH"
  cidr_ranges  = ["{{cidr}}"]               # "IP CIDR ranges that apply as a filter on the source (ingress) or destination (egress) IP in the IP header."
}
