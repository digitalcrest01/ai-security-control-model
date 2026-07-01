        # D4 — Runtime Protection & Interaction Security

        > **Phase:** Build & Develop (`p2-build-develop`) &nbsp;·&nbsp;
        > **Exit gate:** Gate B — Secure by build
        > (`gates/gate-b-secure-by-build.rego`)

        | Attribute | Value |
        |---|---|
        | Market maturity | Moderate |
        | Current coverage | Partial coverage |
        | Coverage note | Runtime safeguards evolving. |

        ## Purpose

        This domain packages the controls that answer for **runtime protection & interaction security**
        within the Build & Develop phase. Every control is expressed as
        infrastructure and/or policy-as-code so it can be enforced in the delivery
        pipeline rather than asserted in a document.

        ## Controls

        | ID | Capability | Status | Owner |
        |---|---|---|---|
        | `D4-01` | Prompt Inspection & Content Filtering | not_started | TODO |
| `D4-02` | PII / Secrets Detection | not_started | TODO |
| `D4-03` | Jailbreak / Injection Detection | not_started | TODO |
| `D4-04` | Output Safety / Policy Enforcement | not_started | TODO |
| `D4-05` | Tool / Function Call Guardrails | not_started | TODO |
| `D4-06` | Runtime Monitoring & Anomaly Detection | not_started | TODO |
| `D4-07` | Response Validation & Blocking | not_started | TODO |

        Status vocabulary: `not_started` → `in_progress` → `implemented` → `verified`.
        The machine-readable source of truth is [`controls.yaml`](controls.yaml);
        keep it and this table in sync (regenerate with `tools/scaffold.py`).

        ## Standards this domain answers to

        - OWASP LLM01
- MITRE ATLAS
- NIST AI RMF · MANAGE

        ## Layout

        ```
        d4-runtime-protection/
          README.md        this file
          controls.yaml    machine-readable control register
          terraform/       IaC that implements the controls (stubs)
          policies/        domain-level OPA policy (feeds the phase gate)
        ```

        ## Contributing controls

        1. Move the control's `status` forward in `controls.yaml`.
        2. Implement it under `terraform/` and/or `policies/`.
        3. Ensure the relevant assertion is exercised by
           `gates/gate-b-secure-by-build.rego` so the phase gate can see it.
