# Gate B — Secure by build (exit gate for Phase 2: Build & Develop)
#
# Domains gated: D3 (Development Security & AI App Testing), D4 (Runtime Protection).
# This is the canonical CI gate: it runs on every AI release pull request and blocks
# the merge when criteria fail.
#
# Expected input shape (see gates/examples/gate-b.input.json):
#   input.scan.sast_critical            : number
#   input.scan.secrets_found            : number
#   input.tests.prompt_injection_passed : bool
#   input.tests.red_team_passed         : bool
#   input.tests.poisoning_critical      : number
#   input.policy.as_code_enforced       : bool
package gates.gate_b

import rego.v1

default allow := false

allow if count(deny) == 0

deny contains msg if {
	input.scan.sast_critical > 0
	msg := "SAST criticals must be zero"
}

deny contains msg if {
	input.scan.secrets_found > 0
	msg := "no exposed secrets permitted"
}

deny contains msg if {
	not input.tests.prompt_injection_passed
	msg := "injection suite must pass"
}

deny contains msg if {
	not input.tests.red_team_passed
	msg := "adversarial red-team suite must pass"
}

deny contains msg if {
	input.tests.poisoning_critical > 0
	msg := "no critical model/data poisoning findings permitted"
}

deny contains msg if {
	not input.policy.as_code_enforced
	msg := "policy-as-code required"
}
