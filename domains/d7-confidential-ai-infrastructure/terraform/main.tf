# D7 — Confidential AI & Infrastructure
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
  domain = "D7"
  # Control register for this domain — see controls.yaml for status/owner.
  controls = [
    "D7-01", # Confidential Computing
    "D7-02", # Encrypted Inference
    "D7-03", # Key Management (BYOK)
    "D7-04", # Private Data Processing
    "D7-05", # Secure Multi-Party Computation
    "D7-06", # Isolated Runtimes & Sandboxing
    "D7-07", # Infrastructure Hardening
  ]
}

# TODO: implement controls for Confidential AI & Infrastructure.
# Each control above should map to concrete resources or data sources here.

output "d7_confidential_ai_infrastructure_controls" {
  description = "Control IDs this module is responsible for."
  value       = local.controls
}
