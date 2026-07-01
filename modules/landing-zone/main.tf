# Shared secure landing zone (stub).
#
# The baseline every new AI workload inherits by default. Ordering is deliberate:
# identity is modelled first, then key management, then network/compute hardening.
# Replace the null_resource placeholders with real provider resources
# (google_*, azurerm_*) as the baseline is implemented.

terraform {
  required_version = ">= 1.6.0"
}

locals {
  name_prefix = "aiscm-${var.environment}"

  base_labels = merge({
    "managed-by" = "ai-security-control-model"
    "env"        = var.environment
    "baseline"   = "landing-zone"
  }, var.labels)
}

# --- 1. Identity (primary perimeter) -----------------------------------------
# Non-human identities for AI workloads/agents, least privilege by construction.
# TODO: replace with google_service_account / azuread_service_principal + IAM.
resource "null_resource" "workload_identity" {
  for_each = var.workload_identities

  triggers = {
    name        = "${local.name_prefix}-${each.key}"
    roles       = join(",", each.value.roles)
    description = each.value.description
  }
}

# --- 2. Key management (BYOK) ------------------------------------------------
# TODO: replace with google_kms_key_ring/key or azurerm_key_vault_key.
resource "null_resource" "kms" {
  triggers = {
    name = "${local.name_prefix}-kms"
  }
}

# --- 3. Encrypted, versioned, access-controlled state backend ---------------
# State files must be encrypted, versioned and access-controlled; drift
# detection runs on a schedule (wired in CI, not here).
# TODO: replace with google_storage_bucket / azurerm_storage_account.
resource "null_resource" "state_backend" {
  triggers = {
    name       = "${local.name_prefix}-tfstate"
    versioning = "enabled"
    encryption = "cmek"
  }
}

# --- 4. Network / compute hardening baseline --------------------------------
# TODO: private networking, egress controls, hardened compute images.
resource "null_resource" "hardening_baseline" {
  triggers = {
    name = "${local.name_prefix}-hardening"
  }
}
