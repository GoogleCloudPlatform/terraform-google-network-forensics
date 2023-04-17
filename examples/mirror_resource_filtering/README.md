# Mirror Resouce Filtering
This example demonstrates how to specify mirror vpc network sources, for packet mirroring policy.

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
}
```
Above variables can be set either by specifying it through [Environment Variables](https://www.terraform.io/docs/cli/config/environment-variables.html#tf_var_name) or setting it in `terraform.tfvars` file. Below is an example of how to set the variables in `terraform.tfvars` file.

```tf
  gcp_project_id = "{{collector_project_id}}"
  collector_vpc_name    = "{{collector-vpc}}"

  subnets = [
    {
      mirror_vpc_network          = "{{mirror_vpc_network}}"
      collector_vpc_subnet_cidr   = "{{subnet_cidr}}"
      collector_vpc_subnet_region = "{{region}}"
    },

    # Note: For each mirror VPC and regions, user needs to repeat above block accordingly.
  ]

  
  # Mirror Resource Filtering
  
  mirror_vpc_subnets = {
    "{{mirror_project_id--mirror_vpc_name--region}}" = ["{{subnet_id}}"]
  }

  mirror_vpc_instances = {
    "{{collector_project_id--mirror_vpc_name--region}}" = ["{{instance_id}}"]

    # Note: Allowed only if mirror and collector vpc are in same project.  
  }

  mirror_vpc_tags = {
    "{{mirror_project_id--mirror_vpc_name--region}}" = ["{{tag-1}}", "{{tag-2}}"]
  }

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
