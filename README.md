# AI Security Control Model

**A gated operating model for AI security — built as code, enforced as policy.**

AI security capability exists, but it is scattered across the lifecycle and
uneven in depth. This framework packages **59 controls across 8 domains** into a
single **gated workflow** that moves an organisation from *unknown estate* to
*audit-ready assurance*. Identity is the primary perimeter; controls ship as
Terraform and policy-as-code; each lifecycle phase ends in an **exit gate** that
must pass before work advances.

> The interactive one-page version is [`docs/index.html`](docs/index.html);
> the narrative is in [`docs/operating-model.md`](docs/operating-model.md).

## The model at a glance

Four phases run as a continuous loop; each owns two capability domains and ends
in a gate. Gate D closes the loop — assurance findings re-open the estate
inventory that Gate A guards.

| Phase | Domains | Exit gate |
|---|---|---|
| **1. Plan & Discover** | D1 Asset & Posture · D2 Identity & Access | **A — Known estate** |
| **2. Build & Develop** | D3 Dev Security & Testing · D4 Runtime Protection | **B — Secure by build** |
| **3. Deploy & Operate** | D5 Data Security · D6 Model & Supply Chain | **C — Protected in production** |
| **4. Govern & Assure** | D7 Confidential AI & Infra · D8 Governance, Risk & Compliance | **D — Assured & auditable** |

| | |
|---|---|
| **4** lifecycle phases | **8** capability domains |
| **59** controls | **4** exit gates |

## Two views of the same estate

The lifecycle model above answers *"**when** in delivery is a control owned?"*
The [**Threat → Technical-Control Catalogue**](docs/threat-control-catalogue.md)
answers the orthogonal question *"**what** AI/agent risk does a control answer,
and **where** in the architecture is it enforced?"* — mapping **24 risks** to
**60 technical capabilities**, each pinned to one of **12 control-plane layers**
(Runtime Mediation, Authorization, Tool Gateway, …) and mapped back to a domain
and gate. It also carries a **build-vs-buy** signal from market coverage, which
surfaces the **12 controls no vendor sells** — the ones this framework must
specify natively. Use it to threat-model a workload into a ready-made control
set; use the lifecycle model to drive it through the gates.

The catalogue is **operational, not just descriptive**:

- **Validated as code** — [`tools/validate_catalogue.py`](tools/validate_catalogue.py)
  checks IDs, cross-references and enums and emits a flattened
  [`spec/threat-control-catalogue.json`](spec/threat-control-catalogue.json); CI
  blocks drift.
- **Enforced as a gate** — [`gates/workload-controls.rego`](gates/workload-controls.rego)
  takes a workload's *risk exposure* + *control-implementation status* and
  returns a pass/deny verdict for any exit gate A–D.

## Repository layout

```
ai-security-control-model/
├── spec/                     # source of truth (YAML) — phases, domains, controls, standards, gates
│   ├── threat-control-catalogue.yaml   #   risk-driven view: 24 risks → 60 technical controls
│   └── control-plane-layers.yaml       #   12 architectural enforcement points → domains
├── domains/                  # one directory per capability domain (D1–D8)
│   └── <slug>/
│       ├── README.md         #   domain overview + control register
│       ├── controls.yaml     #   machine-readable control status/owner
│       ├── terraform/        #   IaC that implements the controls (stubs)
│       └── policies/         #   domain OPA policy feeding the phase gate
├── gates/                    # exit gates A–D as OPA/Rego + example evidence + tests
│   └── workload-controls.rego      #   operational gate: a workload's risk exposure → gate verdict
├── modules/
│   └── landing-zone/         # shared secure GCP baseline every AI workload inherits
├── environments/
│   └── sandbox/              # D2 Identity slice: estate.yaml → IaC → evidence → Gate A
├── docs/                     # index.html + operating-model.md + threat-control-catalogue.md
├── tools/
│   ├── scaffold.py           # regenerates spec/ (+ scaffolds domains/) from the source of truth
│   ├── validate_catalogue.py # validates the threat catalogue + emits its flattened JSON view
│   └── collect_gate_a_evidence.py  # inventory + provisioned identities → Gate A evidence
└── .github/workflows/        # CI: policy checks, gate evaluation, terraform validate, evidence chain
```

## Built as code, enforced as policy

Controls that live in slideware do not survive contact with a release pipeline.
Every domain is expressed as infrastructure and/or policy-as-code, and the phase
gates are wired in as pipeline checks that block a merge or a deploy when
criteria fail.

- **Identity is modelled first** (GCP IAM / Entra ID), before network or compute
  — see [`modules/landing-zone`](modules/landing-zone).
- **State files are encrypted, versioned, access-controlled**; drift detection
  runs on a schedule.
- **Gates A–D are OPA policies, not review meetings** — see [`gates/`](gates).
- **Secure landing zones carry the baseline** so new AI workloads inherit it.

## Quick start

```bash
# Evaluate an exit gate against example evidence (empty result == pass)
opa eval -d gates -i gates/examples/gate-b.input.json 'data.gates.gate_b.deny'

# Run the gate unit tests
opa test gates -v

# Check every policy parses; check Terraform is formatted
opa check gates domains
terraform fmt -check -recursive

# Regenerate spec/ + domain scaffolds from the source of truth
python3 tools/scaffold.py && terraform fmt -recursive
```

## Working with the model

1. **`spec/` is the source of truth.** Phases, domains, controls, standards and
   gates are defined there and generated into the tree by
   [`tools/scaffold.py`](tools/scaffold.py). CI fails if the tree drifts from spec.
2. **Advance a control** by moving its `status` forward in the domain's
   `controls.yaml` (`not_started → in_progress → implemented → verified`) and
   implementing it under `terraform/` and/or `policies/`.
3. **A phase cannot exit** until its gate policy returns an empty `deny` set
   against real pipeline evidence.

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for the workflow and the checks CI runs.

## Standards mapping

Every domain ties to named standards (NIST AI RMF, ISO/IEC 42001, EU AI Act,
OWASP LLM Top 10, MITRE ATLAS, SLSA, and more) so audit and regulatory questions
have a pre-built answer. See [`spec/standards-map.yaml`](spec/standards-map.yaml).

## Status

**D2 Identity slice — live on GCP.** The [`sandbox` environment](environments/sandbox)
provisions a managed, least-privilege service account for every AI workload in
`estate.yaml`, and CI proves the estate clears **Gate A** end-to-end
(inventory → IaC → evidence → gate). Implemented D2 controls: secure non-human
identities, agent identity management, least-privilege enforcement.

The remaining domains (D1, D3–D8) are scaffolds — control registers plus stub
Terraform/policies. Each is built out by following the D2 pattern: real IaC
under a module, evidence collected from that IaC, evaluated by the phase gate.
See each domain's `README.md` for its control register.

## Contributing

Contributions are welcome from anyone — new domain slices, real Terraform/policy
implementations, gate criteria, standards mappings. See
[`CONTRIBUTING.md`](CONTRIBUTING.md) for the workflow and the checks CI runs.

## License

Released under the [MIT License](LICENSE) — free to use, modify and distribute,
including commercially. © 2026 Vertotech LLC.

## Attribution

Domain and control names retained from the source capability model; maturity and
coverage states as published. Standards mapping, gate criteria, and the
code-scaffold are analytical additions of this repository.
