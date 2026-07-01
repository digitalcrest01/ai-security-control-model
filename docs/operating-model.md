# AI Security Control Model — operating model

> The interactive version of this page is [`docs/index.html`](index.html).
> The machine-readable source of truth is [`spec/`](../spec); the diagrams and
> tables below are generated from it.

## BLUF

AI security capability exists, but it is scattered across the lifecycle and
uneven in depth. This model packages **59 capabilities across 8 domains** into a
single **gated workflow** that moves an organisation from *unknown estate* to
*audit-ready assurance*. Identity is the primary perimeter; controls ship as
Terraform and policy-as-code; each phase ends in an **exit gate** that must pass
before work advances.

## The gated lifecycle

Four phases run as a continuous loop. Each phase owns two capability domains and
ends in an exit gate. Gate D closes the loop — assurance findings re-open the
estate inventory that Gate A guards.

| Phase | Activities | Domains | Exit gate |
|---|---|---|---|
| **1. Plan & Discover** | Inventory, classify, assess risk | D1, D2 | **A — Known estate** |
| **2. Build & Develop** | Design, code, test, validate | D3, D4 | **B — Secure by build** |
| **3. Deploy & Operate** | Run, interact, monitor, protect | D5, D6 | **C — Protected in production** |
| **4. Govern & Assure** | Govern, audit, comply, improve | D7, D8 | **D — Assured & auditable** |

```
        ┌──────────────┐   Gate A   ┌──────────────┐   Gate B
        │ 1. Plan &    │──────────▶ │ 2. Build &   │──────────▶
        │   Discover   │            │   Develop    │
        └──────────────┘            └──────────────┘
               ▲                                          │
        Gate D │                                          │ Gate C
               │            ┌──────────────┐   ◀──────────┘
        findings re-open    │ 4. Govern &  │   ┌──────────────┐
        the inventory  ◀────│   Assure     │◀──│ 3. Deploy &  │
                            └──────────────┘   │   Operate    │
                                               └──────────────┘
```

## Domains

| ID | Domain | Phase | Maturity | Coverage |
|---|---|---|---|---|
| D1 | AI Asset & Posture Management | Plan & Discover | Moderate-High | Good but fragmented |
| D2 | Identity & Access for Agents & AI | Plan & Discover | Moderate-High | Good but fragmented |
| D3 | Development Security & AI App Testing | Build & Develop | Moderate | Partial coverage |
| D4 | Runtime Protection & Interaction Security | Build & Develop | Moderate | Partial coverage |
| D5 | Data Security for AI | Deploy & Operate | Moderate-Low | Limited coverage |
| D6 | Model Security & Supply Chain | Deploy & Operate | Moderate-Low | Limited coverage |
| D7 | Confidential AI & Infrastructure | Govern & Assure | Early-Moderate | Very limited coverage |
| D8 | Governance, Risk & Compliance | Govern & Assure | Moderate | Partial coverage |

Each domain lives under [`domains/<slug>/`](../domains) with its control
register, Terraform, and policy stubs. See [`spec/domains.yaml`](../spec/domains.yaml)
for the full control list.

## Exit gates

Gates are **policy-as-code, not review meetings** — they run in CI, read
aggregated evidence as JSON, and block a merge/deploy on any failure. See
[`gates/`](../gates).

| Gate | Passes when |
|---|---|
| **A — Known estate** | Assets inventoried, classified, owned, risk-scored; NHIs managed; no Shadow AI over threshold |
| **B — Secure by build** | SAST/secrets clean; injection + red-team suites pass; no critical poisoning; policy-as-code enforced |
| **C — Protected in production** | Runtime guardrails + DLP live; models signed; monitoring operational |
| **D — Assured & auditable** | Mapped to NIST AI RMF / ISO 42001 / EU AI Act; evidence captured; dashboards live; improvement loop running |

## Delivery / engagement model

The same model is the delivery motion. See [`spec/delivery-model.yaml`](../spec/delivery-model.yaml).

| Step | Duration | Deliverable |
|---|---|---|
| 1. Diagnostic sprint | 2–3 weeks | Maturity heat map + gap register |
| 2. Target operating model | 2 weeks | Reference architecture + control catalogue |
| 3. Roadmap & business case | 1 week | Phased roadmap + cost/risk model |
| 4. Build & embed | 6–12 weeks | IaC modules + OPA/Sentinel policies live |
| 5. Assure & run | Ongoing | Dashboards + audit pack + improvement loop |

## Attribution

Domain and control names retained from source; maturity and coverage states as
published; standards mapping and gate criteria are analytical additions.
