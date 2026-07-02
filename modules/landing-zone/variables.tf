# Shared secure landing zone (GCP) — inputs.
# Identity is modelled first, before network or compute (see README).

variable "project_id" {
  description = "GCP project that hosts the landing zone."
  type        = string
}

variable "region" {
  description = "Default region for regional resources (KMS key ring, bucket)."
  type        = string
  default     = "europe-west2"
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)."
  type        = string
}

variable "workload_identities" {
  description = <<-EOT
    Non-human identities for AI workloads and agents. Identity is the primary
    perimeter: every workload gets a dedicated, least-privilege service account.

    Keys become the service-account account_id (6-30 chars, lowercase, digits,
    hyphens). `roles` are project IAM roles granted to that identity — keep them
    least-privilege. `owner` and `data_class` are carried through to the asset
    inventory that Gate A evaluates.
  EOT
  type = map(object({
    roles       = list(string)
    description = string
    owner       = string
    data_class  = string
  }))
  default = {}

  validation {
    condition = alltrue([
      for k in keys(var.workload_identities) :
      can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", k))
    ])
    error_message = "Each workload identity key must be a valid service-account account_id (6-30 chars, lowercase letters/digits/hyphens, not starting or ending with a hyphen)."
  }
}

variable "labels" {
  description = "Common resource labels applied across the landing zone."
  type        = map(string)
  default     = {}
}

variable "key_rotation_period" {
  description = "Rotation period for the BYOK crypto key (seconds suffix, e.g. 7776000s = 90 days)."
  type        = string
  default     = "7776000s"
}
