# Workload control-set gate — the operational use of the threat catalogue.
#
# Turns the catalogue from a reference document into an enforcement input:
# given a workload's RISK EXPOSURE and the IMPLEMENTATION STATUS of its controls,
# decide whether it clears a chosen exit gate (A-D) for that risk profile.
#
# Data (loaded with -d spec/threat-control-catalogue.json):
#   data.catalogue.controls[_] : {id, risk, gate, name, ...}
#
# Expected input shape (see gates/examples/workload.input.json):
#   input.workload.id        : string
#   input.gate               : "A" | "B" | "C" | "D"
#   input.applicable_risks   : [ "R-MU-01", ... ]   # risks this workload is exposed to
#   input.control_status     : { "TC-015": "implemented", ... }  # per-control status
#
# A control counts as satisfied only when its status is `implemented` or
# `verified`; anything else (or missing) blocks the gate.
package platform.workload

import rego.v1

satisfied := {"implemented", "verified"}

# Controls the catalogue requires for THIS workload: risk in scope AND gated here.
required contains c if {
	some c in data.catalogue.controls
	c.gate == input.gate
	c.risk in input.applicable_risks
}

# A required control that is not implemented/verified blocks the gate.
deny contains msg if {
	some c in required
	status := object.get(input.control_status, c.id, "not_started")
	not satisfied[status]
	msg := sprintf(
		"Gate %s blocked: %s '%s' (risk %s) is '%s' — needs implemented|verified",
		[input.gate, c.id, c.name, c.risk, status],
	)
}

default allow := false

allow if count(deny) == 0

# Handy summary for the platform UI / CLI.
summary := {
	"workload": input.workload.id,
	"gate": input.gate,
	"required": count(required),
	"blocking": count(deny),
	"allow": allow,
}
