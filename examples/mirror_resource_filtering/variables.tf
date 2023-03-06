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

# -------------------------------------------------------------- #
# BACKEND CONFIGURATION VARIABLES
# -------------------------------------------------------------- #

variable "credentials" {
  description = "Path to a service account credentials file with rights to run the Google Zeek Automation. If this file is absent Terraform will fall back to Application Default Credentials."
  type        = string
  default     = ""
}

# -------------------------------------------------------------- #
# MODULE VARIABLES
# -------------------------------------------------------------- #

variable "gcp_project_id" {
  description = "GCP Project ID where collector vpc will be provisioned."
  type        = string
}

variable "service_account_email" {
  description = "User's Service Account Email."
  type        = string
}

variable "collector_vpc_name" {
  description = "This is name of collector vpc."
  type        = string
}

variable "subnets" {
  description = "The list of subnets being created."
  type = list(object({
    mirror_vpc_network          = string
    collector_vpc_subnet_cidr   = string
    collector_vpc_subnet_region = string
  }))
}

variable "mirror_vpc_subnets" {
  description = "Mirror VPC Subnets list to be mirrored."
  type        = map(list(string))
  default     = {}
}

variable "mirror_vpc_tags" {
  description = "Mirror VPC Tags list to be mirrored."
  type        = map(list(string))
  default     = {}
}

variable "mirror_vpc_instances" {
  description = "Mirror VPC Instances list to be mirrored. (Note: Mirror VPC should reside in the same project as collector VPC because cross project referencing of instances is not allowed by GCP)"
  type        = map(list(string))
  default     = {}
}
