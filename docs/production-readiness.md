# Production-ready operating model

This layer turns the control model from a reference framework into an operating
system for real AI workloads. It answers three production questions:

1. What must be true before an AI workload is allowed to advance?
2. What evidence proves those conditions without a manual review meeting?
3. Which gaps must be closed first when the estate changes?

## Production posture

| Dimension | Production expectation | Evidence source |
|---|---|---|
| Ownership | Every AI workload, agent, model, dataset, tool, and non-human identity has an accountable owner. | Estate inventory, IAM inventory, service catalogue |
| Environment boundary | Sandbox, staging, and production have separate identities, secrets, data paths, and policy bundles. | Terraform state, cloud configuration export |
| Gate evidence | Gates A-D read machine-generated JSON evidence, not slide decks or attestations alone. | CI output, runtime telemetry, audit export |
| Runtime control plane | Prompt, output, tool, memory, and data-boundary controls run inline for production traffic. | Gateway config, policy decisions, traces |
| Drift management | Control drift reopens the owning gate and creates a dated remediation record. | Scheduled evidence collection, policy diff, issue tracker |
| Audit pack | Every production release can produce a control map, gate verdicts, exceptions, owners, and signed evidence. | Evidence archive, standards map, release metadata |

## Gate hardening

The four exit gates remain the lifecycle spine, but production use requires
each gate to have a stable evidence contract.

| Gate | Production hardening |
|---|---|
| A - Known estate | Fail if any production workload lacks owner, criticality, data classification, model/tool inventory, or managed non-human identity. |
| B - Secure by build | Fail if red-team, injection, tool-scope, dependency, model, or policy tests are missing for the workload's declared risk exposure. |
| C - Protected in production | Fail if runtime guardrails, DLP, model provenance, supply-chain integrity, monitoring, or rollback controls are not active in the target environment. |
| D - Assured & auditable | Fail if standards mappings, exception approvals, evidence retention, dashboards, and continuous-improvement tickets are incomplete. |

## Runtime anomaly

The threat catalogue exposes an important asymmetry: D4 Runtime Protection owns
the largest share of technical risk controls, while the lifecycle register keeps
D4 intentionally compact. Treat that as a production backlog signal, not a data
error.

| Runtime capability family | Catalogue controls | Owning gate |
|---|---|---|
| Prompt and instruction mediation | TC-011, TC-013, TC-022, TC-024 | B |
| Grounding, correctness, and abstention | TC-001, TC-002, TC-015, TC-017, TC-018, TC-019, TC-020, TC-021 | B |
| Tool and action safety | TC-028, TC-040, TC-041, TC-042, TC-051, TC-054 | A/B |
| Memory and context integrity | TC-048, TC-049, TC-050 | B |
| Output and schema enforcement | TC-036, TC-038, TC-039 | B |
| Observability and anomaly response | TC-003, TC-005, TC-014, TC-033, TC-034, TC-035, TC-043 | B |

Production adoption should therefore prioritize D4 reference implementations
after the existing D2 identity slice:

1. Runtime mediation gateway with policy-as-code decisions.
2. Tool gateway with least-privilege scopes and signed manifests.
3. Trace schema for prompts, retrieval, tool calls, decisions, and denials.
4. Evaluated response validation for grounded generation and structured output.
5. Circuit breaker and rollback evidence wired into Gate B.

## Cloud landing-zone requirements

The operating model is cloud-neutral, but production delivery should implement
the same invariants on AWS, GCP, and Azure.

| Control invariant | AWS implementation signal | GCP implementation signal | Azure implementation signal |
|---|---|---|---|
| Workload identity | IAM role per agent/workload, no long-lived keys | Service account per workload, Workload Identity Federation | Managed identity per workload, federated credentials |
| Policy decision point | Verified Permissions / OPA sidecar / gateway policy | IAM Conditions / OPA sidecar / gateway policy | Azure RBAC + ABAC / OPA sidecar / gateway policy |
| Secretless access | STS and short-lived credentials | short-lived access tokens | Entra workload identity and managed identity tokens |
| Evidence export | CloudTrail, Config, Security Hub, CI artifacts | Cloud Asset Inventory, Audit Logs, Security Command Center, CI artifacts | Activity Logs, Resource Graph, Defender for Cloud, CI artifacts |
| Data boundary | Macie, Lake Formation, KMS, VPC endpoints | Sensitive Data Protection, KMS, VPC Service Controls | Purview, Key Vault, Private Link |

## Operating cadence

| Cadence | Activity | Output |
|---|---|---|
| Per pull request | Evaluate declared risks, policy tests, IaC drift, and gate evidence. | Gate verdict and signed build evidence |
| Per deployment | Confirm target-environment controls and rollback path. | Release audit pack |
| Daily | Recollect estate, identity, runtime, and posture evidence. | Drift register and reopened gates |
| Weekly | Review exceptions, unresolved denies, and runtime anomalies. | Remediation backlog |
| Monthly | Reconcile standards map and control maturity. | Management report and audit delta |
| Quarterly | Retest agentic abuse cases and cloud landing-zone assumptions. | Red-team report and roadmap refresh |

## Definition of production-ready

A workload is production-ready only when:

- It is discoverable in the estate inventory and tied to a business owner.
- Its model, data, tool, identity, and cloud-resource dependencies are known.
- Its declared risk exposure maps to a complete technical-control set.
- Gates A-D can be evaluated from machine evidence.
- Runtime control points are enforced inline, logged, and alertable.
- Exceptions are time-bound, owner-approved, and visible to Gate D.
- The audit pack can be regenerated for the exact deployed version.

