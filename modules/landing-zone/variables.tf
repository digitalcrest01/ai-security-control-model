# Shared secure landing zone — inputs.
# Identity is modelled first, before network or compute (see README).

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)."
  type        = string
}

variable "cloud" {
  description = "Target cloud for the landing zone."
  type        = string
  default     = "gcp"

  validation {
    condition     = contains(["gcp", "azure"], var.cloud)
    error_message = "cloud must be one of: gcp, azure."
  }
}

variable "org_id" {
  description = "Cloud organisation / tenant identifier that owns the landing zone."
  type        = string
}

variable "human_admins" {
  description = "Break-glass human admin principals. Kept deliberately small."
  type        = list(string)
  default     = []
}

variable "workload_identities" {
  description = <<-EOT
    Non-human identities for AI workloads and agents. Identity is the primary
    perimeter: every workload gets a dedicated, least-privilege identity here.
  EOT
  type = map(object({
    roles       = list(string)
    description = string
  }))
  default = {}
}

variable "labels" {
  description = "Common resource labels/tags applied across the landing zone."
  type        = map(string)
  default     = {}
}
