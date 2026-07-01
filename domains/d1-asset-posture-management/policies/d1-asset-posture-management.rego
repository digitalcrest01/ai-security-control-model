# D1 — AI Asset & Posture Management — domain policy (stub).
# Findings here are consumed by the phase gate: gates/gate-a-known-estate.rego
package domain.d1_asset_posture_management

# Example scaffold assertion. Replace with real control checks that read
# from `input` (scan results, terraform plan, inventory, etc.).
#
# deny contains msg if {
#   some c in input.controls
#   c.status == "not_started"
#   msg := sprintf("control %v is not started", [c.id])
# }
