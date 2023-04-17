# Multiple VPC Support
This example demonstrates how to configure packet mirroring for multiple mirror VPCs.

## Usage

```tf
module "google_zeek_automation" {
  source                = "<link>/google_zeek_automation"
  gcp_project           = var.gcp_project_id

  collector_vpc_name    = var.collector_vpc_name
  subnets               = var.subnets
  mirror_vpc_subnets    = var.mirror_vpc_subnets
  mirror_vpc_instances  = var.mirror_vpc_instances
  mirror_vpc_tags       = var.mirror_vpc_tags

  # Optional Parameters
  ip_protocols = var.ip_protocols
  direction    = var.direction
  cidr_ranges  = var.cidr_ranges
}
```
Above variables can be set either by specifying it through [Environment Variables](https://www.terraform.io/docs/cli/config/environment-variables.html#tf_var_name) or setting it in `terraform.tfvars` file. Below is an example of how to set the variables in `terraform.tfvars` file.

```tf
  gcp_project_id = "{{collector_project_id}}"
  collector_vpc_name    = "{{collector-vpc}}"

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
    .
    .
    .,
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
    .
    .
    .,
    "{{mirror_project_id_N--mirror_vpc_name_N--region_N}}" = ["{{subnet_id-N}},{{subnet_id-M}}"]
  }

  mirror_vpc_instances = {
    "{{collector_project_id--mirror_vpc_name_1--region_1}}" = ["{{instance_id-1}},{{instance_id-2}}"],
    "{{collector_project_id--mirror_vpc_name_2--region_1}}" = ["{{instance_id-3}},{{instance_id-4}}"],
    "{{collector_project_id--mirror_vpc_name_3--region_2}}" = ["{{instance_id-5}},{{instance_id-6}}"],
    .
    .
    .,
    "{{collector_project_id--mirror_vpc_name_N--region_N}}" = ["{{instance_id-N}},{{instance_id-M}}"]


    # Note: Allowed only if mirror and collector vpc are in same project.
  }

  mirror_vpc_tags = {
    "{{mirror_project_id_1--mirror_vpc_name_1--region_1}}" = ["{{tag-1}}", "{{tag-2}}"],
    "{{mirror_project_id_2--mirror_vpc_name_2--region_1}}" = ["{{tag-3}}", "{{tag-4}}"],
    "{{mirror_project_id_3--mirror_vpc_name_3--region_2}}" = ["{{tag-5}}", "{{tag-6}}"],
    .
    .
    .,
    "{{mirror_project_id_N--mirror_vpc_name_N--region_N}}" = ["{{tag-N}}", "{{tag-M}}"]
  }

  # Packet Mirroring Traffic Filtering

  ip_protocols = ["{{protocol}}"]              # Protocols that apply as a filter on mirrored traffic. Possible values: ["tcp", "udp", "icmp"]

  direction = "{{direction_of_traffic}}"       # Direction of traffic to mirror. Possible values: "INGRESS", "EGRESS", "BOTH"

  cidr_ranges = ["{{cidr}}"]                   # "IP CIDR ranges that apply as a filter on the source (ingress) or destination (egress) IP in the IP header."

```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | GCP Project ID where collector vpc will be provisioned. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| autoscaler\_ids | Autoscaler identifier for the resource with format projects/{{project}}/regions/{{region}}/autoscalers/{{name}} |
| collector\_vpc\_network\_id | The identifier of the VPC network with format projects/{{project}}/global/networks/{{name}}. |
| collector\_vpc\_subnets\_ids | Sub Network identifier for the resource with format projects/{{project}}/regions/{{region}}/subnetworks/{{name}} |
| forwarding\_rule\_ids | Forwarding Rule identifier for the resource with format projects/{{project}}/regions/{{region}}/forwardingRules/{{name}} |
| health\_check\_id | Health Check identifier for the resource with format projects/{{project}}/global/healthChecks/{{name}} |
| intance\_group\_ids | Managed Instance Group identifier for the resource with format {{disk.name}} |
| intance\_groups | The full URL of the instance group created by the manager. |
| intance\_template\_ids | Instance Templates identifier for the resource with format projects/{{project}}/global/instanceTemplates/{{name}} |
| loadbalancer\_ids | Internal Load Balancer identifier for the resource with format projects/{{project}}/regions/{{region}}/backendServices/{{name}} |
| packet\_mirroring\_policy\_ids | Packet Mirroring Policy identifier for the resource with format projects/{{project}}/regions/{{region}}/packetMirrorings/{{name}} |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
