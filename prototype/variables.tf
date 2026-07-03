variable "project_id" {
  type        = string
  description = "GCP project that hosts the Control Plane console prototype."
}

variable "region" {
  type        = string
  description = "Cloud Run region."
  default     = "europe-west2"
}

variable "console_image" {
  type        = string
  description = "Container image serving the static console (docs/prototype.html) + the catalogue JSON."
  default     = "gcr.io/cloudrun/hello" # placeholder; replace with the built console image
}

variable "invoker_domain" {
  type        = string
  description = "Workspace domain allowed to invoke the console (via IAM). Empty string = keep private (no public access)."
  default     = ""
}
