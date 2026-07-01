# Tests for Gate B. Run with: opa test gates
package gates.gate_b_test

import rego.v1

import data.gates.gate_b

# A clean release passes the gate.
test_clean_release_allowed if {
	gate_b.allow with input as {
		"scan": {"sast_critical": 0, "secrets_found": 0},
		"tests": {"prompt_injection_passed": true, "red_team_passed": true, "poisoning_critical": 0},
		"policy": {"as_code_enforced": true},
	}
}

# A SAST critical blocks the gate.
test_sast_critical_denied if {
	not gate_b.allow with input as {
		"scan": {"sast_critical": 1, "secrets_found": 0},
		"tests": {"prompt_injection_passed": true, "red_team_passed": true, "poisoning_critical": 0},
		"policy": {"as_code_enforced": true},
	}
}

# A failed injection suite blocks the gate.
test_injection_failure_denied if {
	count(gate_b.deny) > 0 with input as {
		"scan": {"sast_critical": 0, "secrets_found": 0},
		"tests": {"prompt_injection_passed": false, "red_team_passed": true, "poisoning_critical": 0},
		"policy": {"as_code_enforced": true},
	}
}

# Missing policy-as-code blocks the gate.
test_policy_as_code_required if {
	count(gate_b.deny) > 0 with input as {
		"scan": {"sast_critical": 0, "secrets_found": 0},
		"tests": {"prompt_injection_passed": true, "red_team_passed": true, "poisoning_critical": 0},
		"policy": {"as_code_enforced": false},
	}
}
