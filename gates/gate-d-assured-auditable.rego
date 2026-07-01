# Gate D — Assured & auditable (exit gate for Phase 4: Govern & Assure)
#
# Domains gated: D7 (Confidential AI & Infrastructure), D8 (Governance, Risk & Compliance).
# Gate D closes the loop: assurance findings re-open the estate inventory (Gate A).
#
# Expected input shape (see gates/examples/gate-d.input.json):
#   input.mapping.frameworks    : [string]  e.g. ["NIST AI RMF","ISO 42001","EU AI Act"]
#   input.evidence.captured     : bool
#   input.dashboards.live       : bool
#   input.improvement.loop_open : bool
package gates.gate_d

import rego.v1

# Frameworks that must all be mapped before assurance can be claimed.
required_frameworks := {"NIST AI RMF", "ISO 42001", "EU AI Act"}

default allow := false

allow if count(deny) == 0

# Every required framework must appear in the mapping evidence.
deny contains msg if {
	some fw in required_frameworks
	not fw in {f | some f in input.mapping.frameworks}
	msg := sprintf("controls not mapped to required framework: %v", [fw])
}

deny contains msg if {
	not input.evidence.captured
	msg := "audit evidence must be captured"
}

deny contains msg if {
	not input.dashboards.live
	msg := "assurance dashboards must be live"
}

deny contains msg if {
	not input.improvement.loop_open
	msg := "continuous-improvement loop must be running (findings feed discovery)"
}
