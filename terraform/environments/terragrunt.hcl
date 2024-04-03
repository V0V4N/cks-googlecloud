locals {
  region                 = "asia-east2-a"
  backend_region         = "ASIA"
  backend_bucket         = "v0v4n-cks-state-backet"
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "gcs" {}
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.40"
    }
  }
}
variable "s3_k8s_config" {
default="${local.backend_bucket}"
}

EOF
}

remote_state {
  backend = "gcs"
  config  = {
    bucket         = local.backend_bucket
    location       = local.backend_region
    prefix   = "${path_relative_to_include()}/terraform.tfstate"
  }
}
inputs = {
 region = local.backend_region
 backend_bucket=local.backend_bucket
}
