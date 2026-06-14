# terraform/variables.tf

variable "project_id" {
  description = "The GCP project ID where resources will be provisioned."
  type        = string
}

variable "region" {
  description = "The default GCP region for resources. us-central1 is chosen for its broad availability and cost-effectiveness for this demo."
  type        = string
  default     = "us-central1"
}