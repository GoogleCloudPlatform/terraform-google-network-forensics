/**
 * Copyright 2019 Google LLC
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

provider "google" {
  version = "~> 3.0"
}

provider "google-beta" {
  version = "~> 3.0"
}

provider "null" {
  version = "~> 2.1"
}

provider "random" {
  version = "~> 2.2"
}

module "project_ci_vm" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.0"

  name                 = "ci-vm-module"
  random_project_id    = true
  org_id               = var.org_id
  folder_id            = var.folder_id
  billing_account      = var.billing_account
  skip_gcloud_download = true

  activate_apis = [
    "cloudresourcemanager.googleapis.com",
    "storage.googleapis.com",
    "serviceusage.googleapis.com",
    "compute.googleapis.com",
    "monitoring.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "cloudbilling.googleapis.com",
  ]
}