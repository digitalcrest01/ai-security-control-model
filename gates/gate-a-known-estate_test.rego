# Tests for Gate A. Run with: opa test gates
package gates.gate_a_test

import rego.v1

import data.gates.gate_a

clean_estate := {
	"inventory": {
		"assets": [
			{"id": "rag-search", "classified": true, "owner": "platform-eng", "risk_score": 3},
			{"id": "support-bot", "classified": true, "owner": "cx-eng", "risk_score": 5},
		],
		"shadow_ai": [{"id": "adhoc-notebook", "risk_score": 2}],
	},
	"identity": {"non_human": [
		{"id": "rag-search", "managed": true},
		{"id": "support-bot", "managed": true},
	]},
	"thresholds": {"shadow_ai_risk": 4},
}

test_clean_estate_allowed if {
	gate_a.allow with input as clean_estate
}

test_unclassified_denied if {
	count(gate_a.deny) > 0 with input as json.patch(clean_estate, [{
		"op": "replace",
		"path": "/inventory/assets/0/classified",
		"value": false,
	}])
}

test_missing_owner_denied if {
	count(gate_a.deny) > 0 with input as json.patch(clean_estate, [{
		"op": "remove",
		"path": "/inventory/assets/0/owner",
	}])
}

test_shadow_ai_over_threshold_denied if {
	count(gate_a.deny) > 0 with input as json.patch(clean_estate, [{
		"op": "add",
		"path": "/inventory/shadow_ai/-",
		"value": {"id": "rogue-llm", "risk_score": 7},
	}])
}

test_unmanaged_identity_denied if {
	count(gate_a.deny) > 0 with input as json.patch(clean_estate, [{
		"op": "replace",
		"path": "/identity/non_human/0/managed",
		"value": false,
	}])
}
