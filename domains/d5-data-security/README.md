        # D5 — Data Security for AI

        > **Phase:** Deploy & Operate (`p3-deploy-operate`) &nbsp;·&nbsp;
        > **Exit gate:** Gate C — Protected in production
        > (`gates/gate-c-protected-production.rego`)

        | Attribute | Value |
        |---|---|
        | Market maturity | Moderate-Low |
        | Current coverage | Limited coverage |
        | Coverage note | Data controls improving but uneven. |

        ## Purpose

        This domain packages the controls that answer for **data security for ai**
        within the Deploy & Operate phase. Every control is expressed as
        infrastructure and/or policy-as-code so it can be enforced in the delivery
        pipeline rather than asserted in a document.

        ## Controls

        | ID | Capability | Status | Owner |
        |---|---|---|---|
        | `D5-01` | Data Discovery & Classification | not_started | TODO |
| `D5-02` | Access Control & Entitlements (RAG) | not_started | TODO |
| `D5-03` | Data Loss Prevention (DLP) | not_started | TODO |
| `D5-04` | Data Minimization & Masking | not_started | TODO |
| `D5-05` | Data Lineage (AI Pipelines) | not_started | TODO |
| `D5-06` | Retention & Destruction Controls | not_started | TODO |
| `D5-07` | Data Usage Auditing | not_started | TODO |

        Status vocabulary: `not_started` → `in_progress` → `implemented` → `verified`.
        The machine-readable source of truth is [`controls.yaml`](controls.yaml);
        keep it and this table in sync (regenerate with `tools/scaffold.py`).

        ## Standards this domain answers to

        - ISO/IEC 27001
- NIST AI RMF · MEASURE
- UK GDPR / DPA 2018

        ## Layout

        ```
        d5-data-security/
          README.md        this file
          controls.yaml    machine-readable control register
          terraform/       IaC that implements the controls (stubs)
          policies/        domain-level OPA policy (feeds the phase gate)
        ```

        ## Contributing controls

        1. Move the control's `status` forward in `controls.yaml`.
        2. Implement it under `terraform/` and/or `policies/`.
        3. Ensure the relevant assertion is exercised by
           `gates/gate-c-protected-production.rego` so the phase gate can see it.
