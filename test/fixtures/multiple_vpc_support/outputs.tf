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

output "collector_vpc_network_id" {
  description = "The identifier of the VPC network with format projects/{{project}}/global/networks/{{name}}."
  value       = module.multiple_vpc_support.collector_vpc_network_id
}

output "collector_vpc_subnets_ids" {
  description = "Sub Network identifier for the resource with format projects/{{project}}/regions/{{region}}/subnetworks/{{name}}"
  value       = module.multiple_vpc_support.collector_vpc_subnets_ids
}

output "intance_template_ids" {
  description = "Instance Templates identifier for the resource with format projects/{{project}}/global/instanceTemplates/{{name}}"
  value       = module.multiple_vpc_support.intance_template_ids
}

output "health_check_id" {
  description = "Health Check identifier for the resource with format projects/{{project}}/global/healthChecks/{{name}}"
  value       = module.multiple_vpc_support.health_check_id
}

output "intance_group_ids" {
  description = "Managed Instance Group identifier for the resource with format {{disk.name}}"
  value       = module.multiple_vpc_support.intance_group_ids
}

output "intance_groups" {
  description = "The full URL of the instance group created by the manager."
  value       = module.multiple_vpc_support.intance_groups
}

output "autoscaler_ids" {
  description = "Autoscaler identifier for the resource with format projects/{{project}}/regions/{{region}}/autoscalers/{{name}}"
  value       = module.multiple_vpc_support.autoscaler_ids
}

output "loadbalancer_ids" {
  description = "Internal Load Balancer identifier for the resource with format projects/{{project}}/regions/{{region}}/backendServices/{{name}}"
  value       = module.multiple_vpc_support.loadbalancer_ids
}

output "forwarding_rule_ids" {
  description = "Forwarding Rule identifier for the resource with format projects/{{project}}/regions/{{region}}/forwardingRules/{{name}}"
  value       = module.multiple_vpc_support.forwarding_rule_ids
}

output "packet_mirroring_policy_ids" {
  description = "Packet Mirroring Policy identifier for the resource with format projects/{{project}}/regions/{{region}}/packetMirrorings/{{name}}"
  value       = module.multiple_vpc_support.packet_mirroring_policy_ids
}
