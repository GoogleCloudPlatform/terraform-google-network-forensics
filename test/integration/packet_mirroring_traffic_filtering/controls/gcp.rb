# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

project_id      = attribute('project_id')
network_name    = attribute('network_name')
region          = attribute('region')

control "gcp" do
  title "Google Cloud configuration"
  describe google_compute_network(
    project: project_id,
    name: network_name
  ) do
    it { should exist }
  end

  describe google_compute_subnetwork(
    project: project_id,
    name: "#{network_name}-subnet-01",
    region: "#{region}"
  ) do
    it { should exist }
  end

  describe google_compute_firewalls(project: project_id) do
    its('firewall_names') { should include "#{network_name}-rule-allow-ingress" }
    its('firewall_names') { should include "#{network_name}-rule-allow-health-check" }
  end

  describe google_compute_forwarding_rule(
    project: project_id, 
    region: region, 
    name: "#{network_name}-01"
    ) do
    its('load_balancing_scheme') { should match "INTERNAL" }
  end

  describe google_compute_health_check(
    project: project_id,
    region: region, 
    name: "#{network_name}-http-health-check"
    ) do
      it { should exist }
    end

  describe google_compute_instance_template(
    project: project_id,
    region: region, 
    name: "#{network_name}-01"
    ) do
      it { should exist }
    end

  describe google_compute_region_instance_group_manager(
    project: project_id,
    region: region, 
    name: "#{network_name}-01"
    ) do
      it { should exist }
    end
end