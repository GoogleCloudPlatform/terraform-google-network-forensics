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
  service_account_email = var.service_account_email

  collector_vpc_name = "collector-vpc"

  subnets = [
    {
      mirror_vpc_network          = "{{mirror_vpc_network_1}}"
      collector_vpc_subnet_cidr   = "{{subnet_cidr_1}}"
      collector_vpc_subnet_region = "{{region_1}}"
    },
    {
      mirror_vpc_network          = "{{mirror_vpc_network_2}}"
      collector_vpc_subnet_cidr   = "{{subnet_cidr_2}}"
      collector_vpc_subnet_region = "{{region_1}}"
    },
    {
      mirror_vpc_network          = "{{mirror_vpc_network_3}}"
      collector_vpc_subnet_cidr   = "{{subnet_cidr_3}}"
      collector_vpc_subnet_region = "{{region_2}}"
    },
    {
      mirror_vpc_network          = "{{mirror_vpc_network_N}}"
      collector_vpc_subnet_cidr   = "{{subnet_cidr_N}}"
      collector_vpc_subnet_region = "{{region_N}}"
    },
    # Note: For each mirror VPC and regions, user needs to repeat above block accordingly.
  ]

  mirror_vpc_subnets = {
    "{{mirror_project_id_1--mirror_vpc_name_1--region_1}}" = ["{{subnet_id-1}},{{subnet_id-2}}"],
    "{{mirror_project_id_2--mirror_vpc_name_2--region_1}}" = ["{{subnet_id-3}},{{subnet_id-4}}"],
    "{{mirror_project_id_3--mirror_vpc_name_3--region_2}}" = ["{{subnet_id-5}},{{subnet_id-6}}"],
    "{{mirror_project_id_N--mirror_vpc_name_N--region_N}}" = ["{{subnet_id-N}},{{subnet_id-M}}"]
  }

  mirror_vpc_instances = {
    "{{collector_project_id--mirror_vpc_name_1--region_1}}" = ["{{instance_id-1}},{{instance_id-2}}"],
    "{{collector_project_id--mirror_vpc_name_2--region_1}}" = ["{{instance_id-3}},{{instance_id-4}}"],
    "{{collector_project_id--mirror_vpc_name_3--region_2}}" = ["{{instance_id-5}},{{instance_id-6}}"],
    "{{collector_project_id--mirror_vpc_name_N--region_N}}" = ["{{instance_id-N}},{{instance_id-M}}"]
    # Note: Allowed only if mirror and collector vpc are in same project.
  }

  mirror_vpc_tags = {
    "{{mirror_project_id_1--mirror_vpc_name_1--region_1}}" = ["{{tag-1}}", "{{tag-2}}"],
    "{{mirror_project_id_2--mirror_vpc_name_2--region_1}}" = ["{{tag-3}}", "{{tag-4}}"],
    "{{mirror_project_id_3--mirror_vpc_name_3--region_2}}" = ["{{tag-5}}", "{{tag-6}}"],
    "{{mirror_project_id_N--mirror_vpc_name_N--region_N}}" = ["{{tag-N}}", "{{tag-M}}"]
  }

  # Packet Mirroring Traffic Filtering
  ip_protocols = ["{{protocol}}"]           # Protocols that apply as a filter on mirrored traffic. Possible values: ["tcp", "udp", "icmp"]
  direction    = "{{direction_of_traffic}}" # Direction of traffic to mirror. Possible values: "INGRESS", "EGRESS", "BOTH"
  cidr_ranges  = ["{{cidr}}"]               # "IP CIDR ranges that apply as a filter on the source (ingress) or destination (egress) IP in the IP header."
}
