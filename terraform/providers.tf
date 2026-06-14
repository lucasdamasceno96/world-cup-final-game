# terraform/providers.tf

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# Configures the Google Cloud provider.
# We use variables for project_id and region to allow environment-specific 
# deployments without changing the core infrastructure code.
provider "google" {
  project = var.project_id
  region  = var.region
}