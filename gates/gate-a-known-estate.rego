# Gate A — Known estate (exit gate for Phase 1: Plan & Discover)
#
# Domains gated: D1 (AI Asset & Posture Management), D2 (Identity & Access).
# Enforced in CI with `conftest test --policy gates <evidence>.json` or `opa eval`.
# A non-empty `deny` set fails the gate and blocks the phase transition.
#
# Expected input shape (see gates/examples/gate-a.input.json):
#   input.inventory.assets            : [{id, classified, owner, risk_score}]
#   input.inventory.shadow_ai         : [{id, risk_score}]
#   input.identity.non_human          : [{id, managed}]
#   input.thresholds.shadow_ai_risk   : number
package gates.gate_a

import rego.v1

default allow := false

allow if count(deny) == 0

# Every discovered asset must be classified.
deny contains msg if {
	some a in input.inventory.assets
	not a.classified
	msg := sprintf("asset %v is not classified", [a.id])
}

# Every discovered asset must have an accountable owner/steward.
deny contains msg if {
	some a in input.inventory.assets
	not a.owner
	msg := sprintf("asset %v has no owner", [a.id])
}

# Every discovered asset must carry a risk score.
deny contains msg if {
	some a in input.inventory.assets
	not a.risk_score
	msg := sprintf("asset %v has no risk score", [a.id])
}

# No untracked Shadow AI above the configured risk threshold.
deny contains msg if {
	some s in input.inventory.shadow_ai
	s.risk_score >= input.thresholds.shadow_ai_risk
	msg := sprintf("shadow AI %v is above the risk threshold (%v)", [s.id, s.risk_score])
}

# Non-human identities must be under management.
deny contains msg if {
	some nhi in input.identity.non_human
	not nhi.managed
	msg := sprintf("non-human identity %v is not under management", [nhi.id])
}
