# D8 — Governance, Risk & Compliance
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
  domain = "D8"
  # Control register for this domain — see controls.yaml for status/owner.
  controls = [
    "D8-01", # AI Risk Assessment
    "D8-02", # Model Risk Management
    "D8-03", # Regulatory Mapping & Controls
    "D8-04", # Audit Logging & Evidence
    "D8-05", # Reporting & Dashboards
    "D8-06", # Policy Management
    "D8-07", # Continuous Improvement
    "D8-08", # Continuous Monitoring & Assurance
  ]
}

# TODO: implement controls for Governance, Risk & Compliance.
# Each control above should map to concrete resources or data sources here.

output "d8_governance_risk_compliance_controls" {
  description = "Control IDs this module is responsible for."
  value       = local.controls
}
