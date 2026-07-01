# D8 — Governance, Risk & Compliance — domain policy (stub).
# Findings here are consumed by the phase gate: gates/gate-d-assured-auditable.rego
package domain.d8_governance_risk_compliance

# Example scaffold assertion. Replace with real control checks that read
# from `input` (scan results, terraform plan, inventory, etc.).
#
# deny contains msg if {
#   some c in input.controls
#   c.status == "not_started"
#   msg := sprintf("control %v is not started", [c.id])
# }
