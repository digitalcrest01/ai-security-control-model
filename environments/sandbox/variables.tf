variable "project_id" {
  description = "GCP project to deploy the sandbox landing zone into."
  type        = string
}

variable "region" {
  description = "Default region for regional resources."
  type        = string
  default     = "europe-west2"
}
