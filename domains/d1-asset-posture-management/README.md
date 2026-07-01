        # D1 — AI Asset & Posture Management

        > **Phase:** Plan & Discover (`p1-plan-discover`) &nbsp;·&nbsp;
        > **Exit gate:** Gate A — Known estate
        > (`gates/gate-a-known-estate.rego`)

        | Attribute | Value |
        |---|---|
        | Market maturity | Moderate-High |
        | Current coverage | Good but fragmented |
        | Coverage note | Well-established controls and tools. |

        ## Purpose

        This domain packages the controls that answer for **ai asset & posture management**
        within the Plan & Discover phase. Every control is expressed as
        infrastructure and/or policy-as-code so it can be enforced in the delivery
        pipeline rather than asserted in a document.

        ## Controls

        | ID | Capability | Status | Owner |
        |---|---|---|---|
        | `D1-01` | AI Asset Inventory & Discovery | not_started | TODO |
| `D1-02` | AI Inventory & Classification | not_started | TODO |
| `D1-03` | Owner / Steward Mapping | not_started | TODO |
| `D1-04` | Data & Model Lineage | not_started | TODO |
| `D1-05` | Shadow AI Detection | not_started | TODO |
| `D1-06` | Posture & Config Assessment | not_started | TODO |
| `D1-07` | Risk Scoring & Prioritization | not_started | TODO |

        Status vocabulary: `not_started` → `in_progress` → `implemented` → `verified`.
        The machine-readable source of truth is [`controls.yaml`](controls.yaml);
        keep it and this table in sync (regenerate with `tools/scaffold.py`).

        ## Standards this domain answers to

        - NIST AI RMF · MAP
- ISO/IEC 42001
- CIS Benchmarks

        ## Layout

        ```
        d1-asset-posture-management/
          README.md        this file
          controls.yaml    machine-readable control register
          terraform/       IaC that implements the controls (stubs)
          policies/        domain-level OPA policy (feeds the phase gate)
        ```

        ## Contributing controls

        1. Move the control's `status` forward in `controls.yaml`.
        2. Implement it under `terraform/` and/or `policies/`.
        3. Ensure the relevant assertion is exercised by
           `gates/gate-a-known-estate.rego` so the phase gate can see it.
