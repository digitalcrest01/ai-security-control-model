# D3 — Development Security & AI App Testing
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
  domain = "D3"
  # Control register for this domain — see controls.yaml for status/owner.
  controls = [
    "D3-01", # Build Secure AI Systems
    "D3-02", # AI / SAST / Code Scanning
    "D3-03", # Secrets & Data Exposure Scanning
    "D3-04", # AI Red Teaming & Adversarial Testing
    "D3-05", # Prompt Injection Testing
    "D3-06", # Agent Behavior Testing
    "D3-07", # Model / Data Poisoning Testing
    "D3-08", # CI/CD Integration & Policy as Code
  ]
}

# TODO: implement controls for Development Security & AI App Testing.
# Each control above should map to concrete resources or data sources here.

output "d3_development_security_testing_controls" {
  description = "Control IDs this module is responsible for."
  value       = local.controls
}
