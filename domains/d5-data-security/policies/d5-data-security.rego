# D5 — Data Security for AI — domain policy (stub).
# Findings here are consumed by the phase gate: gates/gate-c-protected-production.rego
package domain.d5_data_security

# Example scaffold assertion. Replace with real control checks that read
# from `input` (scan results, terraform plan, inventory, etc.).
#
# deny contains msg if {
#   some c in input.controls
#   c.status == "not_started"
#   msg := sprintf("control %v is not started", [c.id])
# }
