# Exit gates

Four gates, one per lifecycle phase. A gate is **policy-as-code, not a review
meeting** — it runs in CI, reads aggregated evidence as JSON, and produces a
`deny` set. A non-empty `deny` fails the gate and blocks the phase transition
(a merge or a deploy).

| Gate | Phase | Policy | Passes when |
|---|---|---|---|
| **A — Known estate** | Plan & Discover | [`gate-a-known-estate.rego`](gate-a-known-estate.rego) | Assets inventoried, classified, owned, risk-scored; NHIs managed; no Shadow AI over threshold |
| **B — Secure by build** | Build & Develop | [`gate-b-secure-by-build.rego`](gate-b-secure-by-build.rego) | SAST/secrets clean; injection + red-team suites pass; no critical poisoning; policy-as-code enforced |
| **C — Protected in production** | Deploy & Operate | [`gate-c-protected-production.rego`](gate-c-protected-production.rego) | Runtime guardrails + DLP live; models signed; monitoring operational |
| **D — Assured & auditable** | Govern & Assure | [`gate-d-assured-auditable.rego`](gate-d-assured-auditable.rego) | Mapped to NIST AI RMF / ISO 42001 / EU AI Act; evidence captured; dashboards live; improvement loop running |

Gate D closes the loop: its findings re-open the estate inventory that Gate A
guards, and the cycle repeats.

## Evaluate a gate locally

Each gate ships an example evidence file under [`examples/`](examples). With
[OPA](https://www.openpolicyagent.org/) installed:

```bash
# Show the deny reasons (empty result == gate passes)
opa eval -d gates -i gates/examples/gate-b.input.json 'data.gates.gate_b.deny'

# Boolean allow decision
opa eval -d gates -i gates/examples/gate-b.input.json 'data.gates.gate_b.allow'
```

Or with [conftest](https://www.conftest.dev/), which treats `deny` as failures:

```bash
conftest test --policy gates --namespace gates.gate_b gates/examples/gate-b.input.json
```

## Run the tests

```bash
opa test gates -v
```

## Wiring a gate into a real pipeline

1. A CI job collects evidence for the phase (scan output, test results,
   inventory export, terraform plan) and writes it to a single JSON document
   matching the gate's expected input shape (documented at the top of each
   `.rego` file).
2. The job evaluates the gate policy against that evidence.
3. A non-empty `deny` set fails the job, which blocks the merge/deploy.

The domain policies under `domains/<slug>/policies/` produce the lower-level
findings that these gate policies aggregate.
