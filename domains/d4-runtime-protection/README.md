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

        ## Production expansion backlog

        The threat-control catalogue maps the largest share of AI and agentic
        technical controls to D4. Keep the seven lifecycle controls stable, but
        build their production implementation around these runtime capability
        families:

        | Family | Example catalogue controls | Gate evidence |
        |---|---|---|
        | Prompt and instruction mediation | `TC-011`, `TC-013`, `TC-022`, `TC-024` | detector verdicts, policy decisions |
        | Grounding and correctness | `TC-001`, `TC-002`, `TC-015`, `TC-017`, `TC-018` | citation checks, abstention thresholds |
        | Tool and action safety | `TC-028`, `TC-040`, `TC-041`, `TC-042`, `TC-051` | tool scopes, pre-execution approvals, circuit-breaker state |
        | Memory and context integrity | `TC-048`, `TC-049`, `TC-050` | memory-source validation, poisoning findings |
        | Output and schema enforcement | `TC-036`, `TC-038`, `TC-039` | moderation decisions, schema validation failures |
        | Observability and anomaly response | `TC-003`, `TC-005`, `TC-033`, `TC-034`, `TC-035`, `TC-043` | traces, anomaly alerts, rollback records |

        See [`../../docs/production-readiness.md`](../../docs/production-readiness.md)
        for the operating cadence and cloud production invariants.

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
