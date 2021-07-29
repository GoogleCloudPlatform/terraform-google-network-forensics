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
  value       = google_compute_network.main.id
}

output "collector_vpc_subnets_ids" {
  description = "Sub Network identifier for the resource with format projects/{{project}}/regions/{{region}}/subnetworks/{{name}}"
  value       = [for subnet in google_compute_subnetwork.main : subnet.id]
}

output "intance_template_ids" {
  description = "Instance Templates identifier for the resource with format projects/{{project}}/global/instanceTemplates/{{name}}"
  value       = [for it in google_compute_instance_template.main : it.id]
}

output "health_check_id" {
  description = "Health Check identifier for the resource with format projects/{{project}}/global/healthChecks/{{name}}"
  value       = google_compute_health_check.main.id
}

output "intance_group_ids" {
  description = "Managed Instance Group identifier for the resource with format {{disk.name}}"
  value       = [for ig in google_compute_region_instance_group_manager.main : ig.id]
}

output "intance_groups" {
  description = "The full URL of the instance group created by the manager."
  value       = [for ig in google_compute_region_instance_group_manager.main : ig.instance_group]
}

output "autoscaler_ids" {
  description = "Autoscaler identifier for the resource with format projects/{{project}}/regions/{{region}}/autoscalers/{{name}}"
  value       = [for scaler in google_compute_region_autoscaler.main : scaler.id]
}

output "loadbalancer_ids" {
  description = "Internal Load Balancer identifier for the resource with format projects/{{project}}/regions/{{region}}/backendServices/{{name}}"
  value       = [for ilb in google_compute_region_backend_service.main : ilb.id]
}

output "forwarding_rule_ids" {
  description = "Forwarding Rule identifier for the resource with format projects/{{project}}/regions/{{region}}/forwardingRules/{{name}}"
  value       = [for rule in google_compute_forwarding_rule.main : rule.id]
}

output "packet_mirroring_policy_ids" {
  description = "Packet Mirroring Policy identifier for the resource with format projects/{{project}}/regions/{{region}}/packetMirrorings/{{name}}"
  value       = [for policy in google_compute_packet_mirroring.main : policy.id]
}