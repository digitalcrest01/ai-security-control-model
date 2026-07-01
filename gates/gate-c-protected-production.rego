# Gate C — Protected in production (exit gate for Phase 3: Deploy & Operate)
#
# Domains gated: D5 (Data Security for AI), D6 (Model Security & Supply Chain).
#
# Expected input shape (see gates/examples/gate-c.input.json):
#   input.runtime.guardrails_live   : bool
#   input.runtime.dlp_live          : bool
#   input.registry.models           : [{id, signed}]
#   input.monitoring.data_pipeline  : bool
#   input.monitoring.model_pipeline : bool
package gates.gate_c

import rego.v1

default allow := false

allow if count(deny) == 0

deny contains msg if {
	not input.runtime.guardrails_live
	msg := "runtime guardrails must be live"
}

deny contains msg if {
	not input.runtime.dlp_live
	msg := "data loss prevention must be live"
}

# Every model in the registry must be signed.
deny contains msg if {
	some m in input.registry.models
	not m.signed
	msg := sprintf("model %v in registry is not signed", [m.id])
}

deny contains msg if {
	not input.monitoring.data_pipeline
	msg := "monitoring/anomaly detection must be operational on the data pipeline"
}

deny contains msg if {
	not input.monitoring.model_pipeline
	msg := "monitoring/anomaly detection must be operational on the model pipeline"
}
