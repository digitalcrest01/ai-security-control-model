# D4 — Runtime Protection & Interaction Security — domain policy (stub).
# Findings here are consumed by the phase gate: gates/gate-b-secure-by-build.rego
package domain.d4_runtime_protection

# Example scaffold assertion. Replace with real control checks that read
# from `input` (scan results, terraform plan, inventory, etc.).
#
# deny contains msg if {
#   some c in input.controls
#   c.status == "not_started"
#   msg := sprintf("control %v is not started", [c.id])
# }
