# Shared secure landing zone (GCP).
#
# The baseline every new AI workload inherits by default. Ordering is deliberate:
# identity is modelled first, then key management (BYOK), then a versioned,
# access-controlled artifact store. Network/compute hardening is layered on top
# by domain modules.

locals {
  name_prefix = "aiscm-${var.environment}"

  base_labels = merge({
    "managed-by" = "ai-security-control-model"
    "env"        = var.environment
    "baseline"   = "landing-zone"
  }, var.labels)

  # Flatten {identity => roles[]} into one binding per (identity, role) pair.
  iam_bindings = merge([
    for id_key, cfg in var.workload_identities : {
      for role in cfg.roles :
      "${id_key}::${role}" => { id_key = id_key, role = role }
    }
  ]...)
}

# --- 1. Identity (primary perimeter) -----------------------------------------
# One dedicated service account per AI workload/agent. No user-managed keys are
# created, so these are managed non-human identities by construction (callers
# authenticate via workload identity / ADC, not exported key files).
resource "google_service_account" "workload" {
  for_each = var.workload_identities

  project      = var.project_id
  account_id   = each.key
  display_name = "AI workload: ${each.key}"
  description  = each.value.description
}

# Least-privilege project IAM: only the roles each identity declares.
resource "google_project_iam_member" "workload" {
  for_each = local.iam_bindings

  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.workload[each.value.id_key].email}"
}

# --- 2. Key management (BYOK) ------------------------------------------------
# Customer-managed key material for encrypted inference / private data
# processing. Rotated on a schedule; protected from accidental destruction.
resource "google_kms_key_ring" "byok" {
  project  = var.project_id
  name     = "${local.name_prefix}-byok"
  location = var.region
}

resource "google_kms_crypto_key" "byok" {
  name     = "${local.name_prefix}-inference"
  key_ring = google_kms_key_ring.byok.id

  rotation_period = var.key_rotation_period
  labels          = local.base_labels

  lifecycle {
    prevent_destroy = true
  }
}

# --- 3. Versioned, access-controlled artifact store -------------------------
# Encrypted (Google-managed by default; attach the BYOK key for CMEK), versioned,
# and locked down: uniform bucket-level access and public access prevention.
resource "google_storage_bucket" "artifacts" {
  project  = var.project_id
  name     = "${local.name_prefix}-${var.project_id}-artifacts"
  location = var.region

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false

  versioning {
    enabled = true
  }

  labels = local.base_labels
}
