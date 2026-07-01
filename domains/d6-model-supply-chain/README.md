        # D6 — Model Security & Supply Chain

        > **Phase:** Deploy & Operate (`p3-deploy-operate`) &nbsp;·&nbsp;
        > **Exit gate:** Gate C — Protected in production
        > (`gates/gate-c-protected-production.rego`)

        | Attribute | Value |
        |---|---|
        | Market maturity | Moderate-Low |
        | Current coverage | Limited coverage |
        | Coverage note | Model and supply chain security still early. |

        ## Purpose

        This domain packages the controls that answer for **model security & supply chain**
        within the Deploy & Operate phase. Every control is expressed as
        infrastructure and/or policy-as-code so it can be enforced in the delivery
        pipeline rather than asserted in a document.

        ## Controls

        | ID | Capability | Status | Owner |
        |---|---|---|---|
        | `D6-01` | Model Provenance & Lineage | not_started | TODO |
| `D6-02` | Model Scanning (Malware / Backdoors) | not_started | TODO |
| `D6-03` | Vulnerability Management (Models / Libraries) | not_started | TODO |
| `D6-04` | AI Bill of Materials (AI BOM) | not_started | TODO |
| `D6-05` | Secure Model Registry & Signing | not_started | TODO |
| `D6-06` | Dependency & Third-Party Risk Management | not_started | TODO |
| `D6-07` | Model Integrity Monitoring | not_started | TODO |

        Status vocabulary: `not_started` → `in_progress` → `implemented` → `verified`.
        The machine-readable source of truth is [`controls.yaml`](controls.yaml);
        keep it and this table in sync (regenerate with `tools/scaffold.py`).

        ## Standards this domain answers to

        - SLSA
- CISA SBOM
- NIST SSDF
- MITRE ATLAS

        ## Layout

        ```
        d6-model-supply-chain/
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
