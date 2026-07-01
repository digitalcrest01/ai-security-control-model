# D2 — Identity & Access for Agents & AI
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
  domain = "D2"
  # Control register for this domain — see controls.yaml for status/owner.
  controls = [
    "D2-01", # Secure Non-human Identities
    "D2-02", # Agent Identity Management
    "D2-03", # MCP / Tool Authorization
    "D2-04", # Least Privilege Enforcement
    "D2-05", # Token & Session Control
    "D2-06", # Secrets / Credential Management
    "D2-07", # Entitlement & Policy Evaluation
    "D2-08", # Anomaly Detection (Agents & NHIs)
  ]
}

# TODO: implement controls for Identity & Access for Agents & AI.
# Each control above should map to concrete resources or data sources here.

output "d2_identity_access_controls" {
  description = "Control IDs this module is responsible for."
  value       = local.controls
}
