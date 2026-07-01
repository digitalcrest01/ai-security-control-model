        # D3 — Development Security & AI App Testing

        > **Phase:** Build & Develop (`p2-build-develop`) &nbsp;·&nbsp;
        > **Exit gate:** Gate B — Secure by build
        > (`gates/gate-b-secure-by-build.rego`)

        | Attribute | Value |
        |---|---|
        | Market maturity | Moderate |
        | Current coverage | Partial coverage |
        | Coverage note | Shift-left improving, gaps remain. |

        ## Purpose

        This domain packages the controls that answer for **development security & ai app testing**
        within the Build & Develop phase. Every control is expressed as
        infrastructure and/or policy-as-code so it can be enforced in the delivery
        pipeline rather than asserted in a document.

        ## Controls

        | ID | Capability | Status | Owner |
        |---|---|---|---|
        | `D3-01` | Build Secure AI Systems | not_started | TODO |
| `D3-02` | AI / SAST / Code Scanning | not_started | TODO |
| `D3-03` | Secrets & Data Exposure Scanning | not_started | TODO |
| `D3-04` | AI Red Teaming & Adversarial Testing | not_started | TODO |
| `D3-05` | Prompt Injection Testing | not_started | TODO |
| `D3-06` | Agent Behavior Testing | not_started | TODO |
| `D3-07` | Model / Data Poisoning Testing | not_started | TODO |
| `D3-08` | CI/CD Integration & Policy as Code | not_started | TODO |

        Status vocabulary: `not_started` → `in_progress` → `implemented` → `verified`.
        The machine-readable source of truth is [`controls.yaml`](controls.yaml);
        keep it and this table in sync (regenerate with `tools/scaffold.py`).

        ## Standards this domain answers to

        - OWASP LLM Top 10
- NIST SSDF 800-218
- OWASP ASVS

        ## Layout

        ```
        d3-development-security-testing/
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
