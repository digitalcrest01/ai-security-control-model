# D1 — AI Asset & Posture Management
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
  domain = "D1"
  # Control register for this domain — see controls.yaml for status/owner.
  controls = [
    "D1-01", # AI Asset Inventory & Discovery
    "D1-02", # AI Inventory & Classification
    "D1-03", # Owner / Steward Mapping
    "D1-04", # Data & Model Lineage
    "D1-05", # Shadow AI Detection
    "D1-06", # Posture & Config Assessment
    "D1-07", # Risk Scoring & Prioritization
  ]
}

# TODO: implement controls for AI Asset & Posture Management.
# Each control above should map to concrete resources or data sources here.

output "d1_asset_posture_management_controls" {
  description = "Control IDs this module is responsible for."
  value       = local.controls
}
