# D6 — Model Security & Supply Chain
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
  domain = "D6"
  # Control register for this domain — see controls.yaml for status/owner.
  controls = [
    "D6-01", # Model Provenance & Lineage
    "D6-02", # Model Scanning (Malware / Backdoors)
    "D6-03", # Vulnerability Management (Models / Libraries)
    "D6-04", # AI Bill of Materials (AI BOM)
    "D6-05", # Secure Model Registry & Signing
    "D6-06", # Dependency & Third-Party Risk Management
    "D6-07", # Model Integrity Monitoring
  ]
}

# TODO: implement controls for Model Security & Supply Chain.
# Each control above should map to concrete resources or data sources here.

output "d6_model_supply_chain_controls" {
  description = "Control IDs this module is responsible for."
  value       = local.controls
}
