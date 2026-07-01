        # D8 — Governance, Risk & Compliance

        > **Phase:** Govern & Assure (`p4-govern-assure`) &nbsp;·&nbsp;
        > **Exit gate:** Gate D — Assured & auditable
        > (`gates/gate-d-assured-auditable.rego`)

        | Attribute | Value |
        |---|---|
        | Market maturity | Moderate |
        | Current coverage | Partial coverage |
        | Coverage note | Governance enabling, enforcement evolving. |

        ## Purpose

        This domain packages the controls that answer for **governance, risk & compliance**
        within the Govern & Assure phase. Every control is expressed as
        infrastructure and/or policy-as-code so it can be enforced in the delivery
        pipeline rather than asserted in a document.

        ## Controls

        | ID | Capability | Status | Owner |
        |---|---|---|---|
        | `D8-01` | AI Risk Assessment | not_started | TODO |
| `D8-02` | Model Risk Management | not_started | TODO |
| `D8-03` | Regulatory Mapping & Controls | not_started | TODO |
| `D8-04` | Audit Logging & Evidence | not_started | TODO |
| `D8-05` | Reporting & Dashboards | not_started | TODO |
| `D8-06` | Policy Management | not_started | TODO |
| `D8-07` | Continuous Improvement | not_started | TODO |
| `D8-08` | Continuous Monitoring & Assurance | not_started | TODO |

        Status vocabulary: `not_started` → `in_progress` → `implemented` → `verified`.
        The machine-readable source of truth is [`controls.yaml`](controls.yaml);
        keep it and this table in sync (regenerate with `tools/scaffold.py`).

        ## Standards this domain answers to

        - ISO/IEC 42001
- NIST AI RMF · GOVERN
- EU AI Act

        ## Layout

        ```
        d8-governance-risk-compliance/
          README.md        this file
          controls.yaml    machine-readable control register
          terraform/       IaC that implements the controls (stubs)
          policies/        domain-level OPA policy (feeds the phase gate)
        ```

        ## Contributing controls

        1. Move the control's `status` forward in `controls.yaml`.
        2. Implement it under `terraform/` and/or `policies/`.
        3. Ensure the relevant assertion is exercised by
           `gates/gate-d-assured-auditable.rego` so the phase gate can see it.
