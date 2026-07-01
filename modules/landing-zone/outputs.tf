# Shared secure landing zone — outputs.

output "name_prefix" {
  description = "Resource name prefix used across the landing zone."
  value       = local.name_prefix
}

output "base_labels" {
  description = "Baseline labels/tags every workload inherits."
  value       = local.base_labels
}

output "workload_identity_names" {
  description = "Provisioned non-human identity names, keyed by workload."
  value       = { for k, r in null_resource.workload_identity : k => r.triggers.name }
}
