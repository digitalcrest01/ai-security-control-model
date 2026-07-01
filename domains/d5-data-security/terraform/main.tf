# D5 — Data Security for AI
# Terraform stub. Replace resources with the real implementation per control.
# This module is intended to be consumed from an environment root that also
# instantiates modules/landing-zone (the shared secure baseline).

terraform {
  required_version = ">= 1.6.0"
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)."
  type        = string
}

variable "labels" {
  description = "Common resource labels/tags."
  type        = map(string)
  default     = {}
}

locals {
  domain = "D5"
  # Control register for this domain — see controls.yaml for status/owner.
  controls = [
    "D5-01", # Data Discovery & Classification
    "D5-02", # Access Control & Entitlements (RAG)
    "D5-03", # Data Loss Prevention (DLP)
    "D5-04", # Data Minimization & Masking
    "D5-05", # Data Lineage (AI Pipelines)
    "D5-06", # Retention & Destruction Controls
    "D5-07", # Data Usage Auditing
  ]
}

# TODO: implement controls for Data Security for AI.
# Each control above should map to concrete resources or data sources here.

output "d5_data_security_controls" {
  description = "Control IDs this module is responsible for."
  value       = local.controls
}
