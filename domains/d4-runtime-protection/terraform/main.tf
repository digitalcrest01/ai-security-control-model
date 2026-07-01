# D4 — Runtime Protection & Interaction Security
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
  domain = "D4"
  # Control register for this domain — see controls.yaml for status/owner.
  controls = [
    "D4-01", # Prompt Inspection & Content Filtering
    "D4-02", # PII / Secrets Detection
    "D4-03", # Jailbreak / Injection Detection
    "D4-04", # Output Safety / Policy Enforcement
    "D4-05", # Tool / Function Call Guardrails
    "D4-06", # Runtime Monitoring & Anomaly Detection
    "D4-07", # Response Validation & Blocking
  ]
}

# TODO: implement controls for Runtime Protection & Interaction Security.
# Each control above should map to concrete resources or data sources here.

output "d4_runtime_protection_controls" {
  description = "Control IDs this module is responsible for."
  value       = local.controls
}
