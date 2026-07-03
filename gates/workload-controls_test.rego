# Tests for the workload control-set gate. Run with: opa test gates
#
# The catalogue is mocked inline (`with data.catalogue as ...`) so the test is
# deterministic and independent of spec/threat-control-catalogue.json.
package platform.workload_test

import rego.v1

import data.platform.workload

mock_catalogue := {
	"controls": [
		{"id": "TC-015", "name": "Grounded Generation", "risk": "R-MU-01", "gate": "B"},
		{"id": "TC-017", "name": "Uncertainty Estimation", "risk": "R-MU-01", "gate": "B"},
		{"id": "TC-022", "name": "Prompt-Injection Detection", "risk": "R-MU-03", "gate": "B"},
		{"id": "TC-037", "name": "PII & Secret Leakage", "risk": "R-MU-07", "gate": "C"},
	],
}

# A workload with every in-scope, in-gate control implemented clears the gate.
test_all_implemented_allows if {
	workload.allow with data.catalogue as mock_catalogue
		with input as {
			"workload": {"id": "w1"},
			"gate": "B",
			"applicable_risks": ["R-MU-01", "R-MU-03"],
			"control_status": {"TC-015": "implemented", "TC-017": "verified", "TC-022": "implemented"},
		}
}

# One missing control blocks the gate.
test_missing_control_denied if {
	not workload.allow with data.catalogue as mock_catalogue
		with input as {
			"workload": {"id": "w1"},
			"gate": "B",
			"applicable_risks": ["R-MU-01", "R-MU-03"],
			"control_status": {"TC-015": "implemented", "TC-017": "verified"},
		}
}

# A not_started control blocks the gate with a specific reason.
test_not_started_denied if {
	count(workload.deny) == 1 with data.catalogue as mock_catalogue
		with input as {
			"workload": {"id": "w1"},
			"gate": "B",
			"applicable_risks": ["R-MU-01"],
			"control_status": {"TC-015": "implemented", "TC-017": "not_started"},
		}
}

# Controls gated elsewhere (TC-037 is Gate C) are not required at Gate B.
test_other_gate_not_required if {
	workload.allow with data.catalogue as mock_catalogue
		with input as {
			"workload": {"id": "w1"},
			"gate": "B",
			"applicable_risks": ["R-MU-01", "R-MU-07"],
			"control_status": {"TC-015": "implemented", "TC-017": "implemented"},
		}
}

# Risks outside the workload's exposure impose no controls.
test_out_of_scope_risk_ignored if {
	workload.allow with data.catalogue as mock_catalogue
		with input as {
			"workload": {"id": "w1"},
			"gate": "B",
			"applicable_risks": [],
			"control_status": {},
		}
}
