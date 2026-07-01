        # D7 — Confidential AI & Infrastructure

        > **Phase:** Govern & Assure (`p4-govern-assure`) &nbsp;·&nbsp;
        > **Exit gate:** Gate D — Assured & auditable
        > (`gates/gate-d-assured-auditable.rego`)

        | Attribute | Value |
        |---|---|
        | Market maturity | Early-Moderate |
        | Current coverage | Very limited coverage |
        | Coverage note | Confidential AI and infrastructure emerging. |

        ## Purpose

        This domain packages the controls that answer for **confidential ai & infrastructure**
        within the Govern & Assure phase. Every control is expressed as
        infrastructure and/or policy-as-code so it can be enforced in the delivery
        pipeline rather than asserted in a document.

        ## Controls

        | ID | Capability | Status | Owner |
        |---|---|---|---|
        | `D7-01` | Confidential Computing | not_started | TODO |
| `D7-02` | Encrypted Inference | not_started | TODO |
| `D7-03` | Key Management (BYOK) | not_started | TODO |
| `D7-04` | Private Data Processing | not_started | TODO |
| `D7-05` | Secure Multi-Party Computation | not_started | TODO |
| `D7-06` | Isolated Runtimes & Sandboxing | not_started | TODO |
| `D7-07` | Infrastructure Hardening | not_started | TODO |

        Status vocabulary: `not_started` → `in_progress` → `implemented` → `verified`.
        The machine-readable source of truth is [`controls.yaml`](controls.yaml);
        keep it and this table in sync (regenerate with `tools/scaffold.py`).

        ## Standards this domain answers to

        - Confidential Computing Consortium
- FIPS 140-3
- ISO/IEC 27001

        ## Layout

        ```
        d7-confidential-ai-infrastructure/
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
