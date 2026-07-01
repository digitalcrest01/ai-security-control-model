        # D2 — Identity & Access for Agents & AI

        > **Phase:** Plan & Discover (`p1-plan-discover`) &nbsp;·&nbsp;
        > **Exit gate:** Gate A — Known estate
        > (`gates/gate-a-known-estate.rego`)

        | Attribute | Value |
        |---|---|
        | Market maturity | Moderate-High |
        | Current coverage | Good but fragmented |
        | Coverage note | Identity and access maturing for agents. |

        ## Purpose

        This domain packages the controls that answer for **identity & access for agents & ai**
        within the Plan & Discover phase. Every control is expressed as
        infrastructure and/or policy-as-code so it can be enforced in the delivery
        pipeline rather than asserted in a document.

        ## Controls

        | ID | Capability | Status | Owner |
        |---|---|---|---|
        | `D2-01` | Secure Non-human Identities | not_started | TODO |
| `D2-02` | Agent Identity Management | not_started | TODO |
| `D2-03` | MCP / Tool Authorization | not_started | TODO |
| `D2-04` | Least Privilege Enforcement | not_started | TODO |
| `D2-05` | Token & Session Control | not_started | TODO |
| `D2-06` | Secrets / Credential Management | not_started | TODO |
| `D2-07` | Entitlement & Policy Evaluation | not_started | TODO |
| `D2-08` | Anomaly Detection (Agents & NHIs) | not_started | TODO |

        Status vocabulary: `not_started` → `in_progress` → `implemented` → `verified`.
        The machine-readable source of truth is [`controls.yaml`](controls.yaml);
        keep it and this table in sync (regenerate with `tools/scaffold.py`).

        ## Standards this domain answers to

        - NIST SP 800-207
- OWASP NHI Top 10
- CIS IAM

        ## Layout

        ```
        d2-identity-access/
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
