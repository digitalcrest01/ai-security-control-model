# Shared secure landing zone (GCP) — outputs.

output "name_prefix" {
  description = "Resource name prefix used across the landing zone."
  value       = local.name_prefix
}

output "base_labels" {
  description = "Baseline labels every workload inherits."
  value       = local.base_labels
}

output "workload_identity_emails" {
  description = "Provisioned service-account emails, keyed by workload."
  value       = { for k, sa in google_service_account.workload : k => sa.email }
}

output "workload_identity_ids" {
  description = "Provisioned service-account account_ids (the inventory identity keys)."
  value       = sort(keys(google_service_account.workload))
}

output "kms_crypto_key_id" {
  description = "BYOK crypto key id for encrypted inference / private data processing."
  value       = google_kms_crypto_key.byok.id
}

output "artifacts_bucket" {
  description = "Versioned, access-controlled artifact bucket name."
  value       = google_storage_bucket.artifacts.name
}
