variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "<PROJECT_ID_HERE>" #Insert your Project ID here
}

variable "region" {
  description = "Default region for resources"
  type        = string
  default     = "us-central1"
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "ha-webserver-vpc"
}

variable "vm_type" {
  description = "The machine type to use for the VM instances"
  type        = string
  default     = "e2-medium"
}