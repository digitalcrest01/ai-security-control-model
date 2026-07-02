output "workload_identity_emails" {
  description = "Provisioned service-account emails, keyed by inventory asset id."
  value       = module.landing_zone.workload_identity_emails
}

output "workload_identity_ids" {
  description = "Provisioned service-account account_ids (should match estate.yaml asset ids)."
  value       = module.landing_zone.workload_identity_ids
}

output "kms_crypto_key_id" {
  description = "BYOK crypto key id."
  value       = module.landing_zone.kms_crypto_key_id
}

output "artifacts_bucket" {
  description = "Versioned, access-controlled artifact bucket."
  value       = module.landing_zone.artifacts_bucket
}
