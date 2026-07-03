# Threat → Technical-Control Catalogue

**The risk-driven view of the control model.** Where the [operating
model](operating-model.md) organises 59 controls by *delivery phase* (D1–D8,
Gates A–D), this catalogue organises **60 technical capabilities by the risk
they answer** — and maps every one back to a lifecycle domain, an architectural
enforcement point, and an exit gate. It is the bridge between "what can go
wrong with AI" and "where in our estate we stop it."

- **Machine-readable source:** [`spec/threat-control-catalogue.yaml`](../spec/threat-control-catalogue.yaml)
- **Enforcement points:** [`spec/control-plane-layers.yaml`](../spec/control-plane-layers.yaml)
- **Lifecycle register it complements:** [`spec/domains.yaml`](../spec/domains.yaml)

---

## What it is

The catalogue is a normalised, ID-stable rendering of a risk × capability ×
market matrix. It has four moving parts:

1. **A risk taxonomy** — 24 named risks in four tiers that escalate with
   autonomy:

   | Tier | Risk surface | Example risks |
   |---|---|---|
   | **IM — Inherent Model Risks** | The model in isolation | Correctness, Opacity, Untestability, Latent Capability, Static Goal Alignment |
   | **MU — Model Use Risks** | The model in an application | Hallucination, Non-determinism, Input Sensitivity, Robustness, Output Safety |
   | **AG — Agentic Risks** | Autonomous, tool-using agents | Dynamic Goal, Behavioral Compliance, Context Sensitivity |
   | **SYS — Agent Security Control Plane** | The estate of agents as a system | Rogue Agents, Identity Abuse, Insecure MCP, Supply-Chain Compromise |

2. **60 technical-capability controls** (`TC-001`…`TC-060`) — the concrete
   capability that mitigates each risk, e.g. *Prompt-Injection Detection
   Classifier*, *Least-Privilege Tool / Action Scoping*, *AI Supply-Chain
   Integrity / AIBOM*.

3. **12 control-plane layers** — the *architectural enforcement point* where a
   control lives (Runtime Mediation, Observability, Continuous Testing,
   Authorization, Data Boundary, Kill Switch, Tool Gateway, Memory Governance,
   Sandbox, Inventory, Identity, Lifecycle Governance). This is the
   **reference-architecture** axis the lifecycle model did not previously make
   explicit.

4. **A build-vs-buy signal** — derived from the count of commercial platforms
   observed to offer each capability. It tells you how to *source* a control,
   never whether you *need* it.

## The two views reconcile

The lifecycle model asks **"WHEN in delivery is this owned?"** The catalogue
asks **"WHAT risk does it answer, and WHERE is it enforced?"** Every
control-plane layer projects onto one or more lifecycle domains, so the risk
lens and the phase lens describe the same estate:

| Control-plane layer | Enforcement point | Lifecycle domain(s) | Gate |
|---|---|---|---|
| Runtime Mediation | Inline request/response interception | **D4** | B |
| Observability | Telemetry, tracing, drift detection | **D4**, D8 | B |
| Continuous Testing | Pre-deploy & drift-triggered eval | **D3** | B |
| Authorization | What an identity/agent may do | **D2** | A |
| Data Boundary | Data in/out of the model | **D5**, D4 | C |
| Kill Switch | Fail-safe interruption | **D4** | B |
| Tool Gateway | Agent↔tool / MCP brokering | **D2**, D4 | B |
| Memory Governance | Agent context/memory integrity | **D4**, D5 | B |
| Sandbox | Isolated action execution | **D7** | D |
| Inventory | Agent/asset discovery | **D1** | A |
| Identity | Non-human identity lifecycle | **D2** | A |
| Lifecycle Governance | Attestation, AIBOM, accountability | **D8**, D6 | D |

## What the risk lens reveals about the model

Rolling the 60 controls up by their **primary** lifecycle domain exposes where
the phase-oriented register is thin relative to the actual threat surface:

| Domain | Controls (primary) | Reading |
|---|--:|---|
| **D4 Runtime Protection** | **35** | The threat surface is overwhelmingly *runtime*. The lifecycle register lists 7 D4 controls; the risk lens demands ~5× that. **D4 is the model's most under-specified domain.** |
| D3 Dev Security & Testing | 7 | Continuous testing / red-teaming is mature and well-covered. |
| D2 Identity & Access | 5 | The agent control plane leans heavily on identity + authorization. |
| D8 Governance | 5 | Interpretability, attestation and audit evidence concentrate here. |
| D5 Data Security | 3 | Data-boundary controls, reinforced as secondaries elsewhere. |
| D6 Supply Chain | 2 | AIBOM + signed manifests. |
| D7 Confidential AI | 2 | Encrypted inference + action sandboxing. |
| D1 Asset & Posture | 1 | Agent discovery — the precondition for everything else. |

**Action:** treat this as a backlog signal — D4's control register in
[`domains/d4-runtime-protection/`](../domains/d4-runtime-protection) should be
expanded toward the runtime capabilities enumerated here.

## Build-vs-buy: the market-maturity signal

The `platforms` count is a **sourcing** signal, not a priority. A control can be
mandatory *and* have zero products (you must build it); it can be optional *and*
commoditised. Distribution across all 60 controls:

| Signal | Platforms | Count | Meaning |
|---|---|--:|---|
| 🔴 **Build** | 0 | 12 | No market product — **architecture-owned; specify and build natively.** |
| 🟠 **Emerging** | 1–5 | 9 | Thin/immature market — build or partner, expect gaps. |
| 🟡 **Buy-select** | 6–15 | 22 | Competitive market — select against requirements and integrate. |
| 🟢 **Commodity** | 16+ | 17 | Mature market — procure to spec; differentiate on integration. |

### The white space (🔴 Build — 12 controls the market does not sell)

These cluster tightly around **model quality and assurance** — Correctness,
Hallucination, Non-determinism, Interpretability — plus agent **execution
isolation**. No vendor packages them, so they are the framework's own
responsibility to specify:

- **Correctness** — `TC-001` Self-Consistency / Ensemble Cross-Checking · `TC-002` Calibrated Confidence Scoring
- **Hallucination** — `TC-015` Grounded Generation w/ Citation Enforcement · `TC-017` Uncertainty Estimation & Abstention
- **Non-determinism** — `TC-019` Deterministic Inference Config · `TC-020` Majority-Vote Checking · `TC-021` Response Caching
- **Interpretability** — `TC-004` Saliency · `TC-030` Rationale Generation · `TC-031` Evidence/Citation Surfacing · `TC-032` Counterfactual Explanation
- **Agent isolation** — `TC-046` Action Sandboxing / Execution Isolation

> These twelve are the strongest argument for an *architecture* framework: they
> are real, high-severity mitigations that cannot be bought, so they must be
> designed in. They are prime candidates for reference implementations under the
> owning domains (mostly D4, with D7/D8).

---

## The catalogue

Legend — **Gate:** the exit gate the control's phase ends in (A–D).
**Platforms:** commercial products observed offering the capability.
**Sourcing:** 🔴 Build · 🟠 Emerging · 🟡 Buy-select · 🟢 Commodity.

<!-- BEGIN GENERATED TABLES — see spec/threat-control-catalogue.yaml -->
### IM — Inherent Model Risks

*Risks intrinsic to the model itself, independent of how it is used.*

| ID | Technical capability | Risk | Control-plane layer | Domain(s) | Gate | Platforms | Sourcing |
|---|---|---|---|---|---|:--:|---|
| `TC-001` | Self-Consistency / Ensemble Cross-Checking | Correctness | Runtime Mediation | D4 | B | 0 | 🔴 Build |
| `TC-002` | Calibrated Confidence Scoring & Thresholding | " | Runtime Mediation | D4 | B | 0 | 🔴 Build |
| `TC-003` | Inference Telemetry & Trace Logging | Opacity | Observability | D4 · D8 | B | 11 | 🟡 Buy-select |
| `TC-004` | Feature Attribution / Saliency Analysis | " | Observability | D8 | D | 0 | 🔴 Build |
| `TC-005` | Reasoning / Chain-of-Thought Capture | " | Observability | D4 · D8 | B | 11 | 🟡 Buy-select |
| `TC-006` | Automated Adversarial & Fuzzing Harness | Untestability | Continuous Testing | D3 | B | 17 | 🟢 Commodity |
| `TC-007` | Behavioral Benchmark & Regression Test Suite | " | Continuous Testing | D3 | B | 21 | 🟢 Commodity |
| `TC-008` | Drift-Triggered Re-Evaluation Pipeline | " | Continuous Testing | D3 · D6 | B | 27 | 🟢 Commodity |
| `TC-009` | Capability Elicitation / Jailbreak Probing | Latent Capability | Continuous Testing | D3 | B | 17 | 🟢 Commodity |
| `TC-010` | Capability-Scoping Guardrails | " | Authorization | D2 · D4 | A | 10 | 🟡 Buy-select |
| `TC-011` | Out-of-Scope Request Classifier | " | Runtime Mediation | D4 | B | 11 | 🟡 Buy-select |
| `TC-012` | Alignment Evaluation Test Sets | Static Goal Alignment | Continuous Testing | D3 | B | 21 | 🟢 Commodity |
| `TC-013` | System-Prompt / Guardrail Enforcement Layer | " | Runtime Mediation | D4 | B | 1 | 🟠 Emerging |
| `TC-014` | Output-vs-Objective Conformance Monitor | " | Observability | D4 · D8 | B | 20 | 🟢 Commodity |

### MU — Model Use Risks

*Risks that surface when the model is invoked in an application context.*

| ID | Technical capability | Risk | Control-plane layer | Domain(s) | Gate | Platforms | Sourcing |
|---|---|---|---|---|---|:--:|---|
| `TC-015` | Grounded Generation with Citation Enforcement | Hallucination | Runtime Mediation | D4 | B | 0 | 🔴 Build |
| `TC-016` | Faithfulness / Entailment Verifier | " | Runtime Mediation | D4 | B | 7 | 🟡 Buy-select |
| `TC-017` | Uncertainty Estimation & Abstention | " | Runtime Mediation | D4 | B | 0 | 🔴 Build |
| `TC-018` | Claim Extraction & Source Cross-Check | " | Runtime Mediation | D4 | B | 7 | 🟡 Buy-select |
| `TC-019` | Deterministic Inference Configuration | Non-determinism | Runtime Mediation | D4 | B | 0 | 🔴 Build |
| `TC-020` | Output Consistency / Majority-Vote Checking | " | Runtime Mediation | D4 | B | 0 | 🔴 Build |
| `TC-021` | Response Caching for Stable Inputs | " | Runtime Mediation | D4 | B | 0 | 🔴 Build |
| `TC-022` | Prompt-Injection Detection Classifier | Input Sensitivity | Runtime Mediation | D4 | B | 11 | 🟡 Buy-select |
| `TC-023` | Input Sanitization & Normalization | " | Data Boundary | D4 · D5 | B | 18 | 🟢 Commodity |
| `TC-024` | Instruction-Channel Segregation | " | Runtime Mediation | D4 | B | 11 | 🟡 Buy-select |
| `TC-025` | Adversarial Perturbation / Input Anomaly Detection | " | Runtime Mediation | D4 | B | 17 | 🟢 Commodity |
| `TC-026` | Out-of-Distribution / Anomaly Input Detection | Robustness | Runtime Mediation | D4 | B | 13 | 🟡 Buy-select |
| `TC-027` | Adversarial Training & Input Filtering | " | Continuous Testing | D3 · D4 | B | 23 | 🟢 Commodity |
| `TC-028` | Rate Limiting & Abuse Throttling | " | Tool Gateway | D4 · D2 | B | 3 | 🟠 Emerging |
| `TC-029` | Graceful Degradation / Fail-Safe Fallback | " | Kill Switch | D4 | B | 1 | 🟠 Emerging |
| `TC-030` | Feature Attribution & Rationale Generation | Interpretability | Observability | D8 | D | 0 | 🔴 Build |
| `TC-031` | Evidence / Citation Surfacing | " | Data Boundary | D5 · D4 | C | 0 | 🔴 Build |
| `TC-032` | Counterfactual Explanation Generation | " | Observability | D8 | D | 0 | 🔴 Build |
| `TC-033` | Behavioral Baselining & Drift Detection | Emergent Capability | Observability | D4 · D8 | B | 20 | 🟢 Commodity |
| `TC-034` | Output Anomaly / Novelty Detection | " | Observability | D4 | B | 20 | 🟢 Commodity |
| `TC-035` | Automated Containment / Rollback Trigger | " | Kill Switch | D4 | B | 1 | 🟠 Emerging |
| `TC-036` | Content-Safety / Toxicity Classifier | Output Safety | Runtime Mediation | D4 | B | 9 | 🟡 Buy-select |
| `TC-037` | PII & Secret Leakage Detection | " | Data Boundary | D5 · D4 | C | 14 | 🟡 Buy-select |
| `TC-038` | Output Moderation Filter | " | Runtime Mediation | D4 | B | 18 | 🟢 Commodity |
| `TC-039` | Structured Output Validation & Schema Enforcement | " | Runtime Mediation | D4 | B | 1 | 🟠 Emerging |

### AG — Agentic Risks

*Risks arising from autonomous, goal-directed, tool-using agent behavior.*

| ID | Technical capability | Risk | Control-plane layer | Domain(s) | Gate | Platforms | Sourcing |
|---|---|---|---|---|---|:--:|---|
| `TC-040` | Goal / Plan Monitoring vs. Intended Objective | Dynamic Goal | Runtime Mediation | D4 | B | 21 | 🟢 Commodity |
| `TC-041` | Pre-Execution Action Validation | " | Runtime Mediation | D4 · D2 | B | 10 | 🟡 Buy-select |
| `TC-042` | Kill-Switch / Circuit Breaker | " | Kill Switch | D4 | B | 1 | 🟠 Emerging |
| `TC-043` | Goal-Change Anomaly Detection | " | Observability | D4 | B | 20 | 🟢 Commodity |
| `TC-044` | Least-Privilege Tool / Action Scoping | Behavioral Compliance | Authorization | D2 | A | 14 | 🟡 Buy-select |
| `TC-045` | Policy-as-Code Action Guardrails | " | Authorization | D2 · D3 | A | 10 | 🟡 Buy-select |
| `TC-046` | Action Sandboxing / Execution Isolation | " | Sandbox | D7 | D | 0 | 🔴 Build |
| `TC-047` | Tamper-Evident Action Logging | " | Observability | D8 | D | 4 | 🟠 Emerging |
| `TC-048` | Context / Memory Source Validation & Isolation | Context Sensitivity | Memory Governance | D4 · D5 | B | 11 | 🟡 Buy-select |
| `TC-049` | Context-Poisoning / Memory Integrity Detection | " | Memory Governance | D4 · D5 | B | 14 | 🟡 Buy-select |
| `TC-050` | Context-Window / Memory Horizon Bounding | " | Memory Governance | D4 | B | 3 | 🟠 Emerging |
| `TC-051` | State Re-Validation Before Consequential Actions | " | Runtime Mediation | D4 | B | 12 | 🟡 Buy-select |

### SYS — Agent Security Control Plane (Systems)

*System-level controls governing the agent estate, identity, tooling and supply chain.*

| ID | Technical capability | Risk | Control-plane layer | Domain(s) | Gate | Platforms | Sourcing |
|---|---|---|---|---|---|:--:|---|
| `TC-052` | Agent Discovery & Inventory | Rogue / Shadow Agents | Inventory | D1 | A | 18 | 🟢 Commodity |
| `TC-053` | Non-Human Agent Identity (NHI) | Identity & Privilege Abuse | Identity | D2 | A | 9 | 🟡 Buy-select |
| `TC-054` | Tool Gateway / MCP Brokering | Tool Misuse / Insecure MCP | Tool Gateway | D2 · D4 | A | 14 | 🟡 Buy-select |
| `TC-055` | Signed Tool Manifests & Provenance | Agentic Supply-Chain Compromise | Tool Gateway | D6 · D2 | C | 4 | 🟠 Emerging |
| `TC-056` | Confidential / Encrypted Inference | Sensitive Data Exposure | Data Boundary | D7 | D | 7 | 🟡 Buy-select |
| `TC-057` | Sensitive Data Classification & Need-to-Know | Data Leakage / Over-Broad Context | Data Boundary | D5 | C | 15 | 🟡 Buy-select |
| `TC-058` | Lifecycle Governance & Attestation | Ungoverned / Unaccountable Agents | Lifecycle Governance | D8 | D | 12 | 🟡 Buy-select |
| `TC-059` | AI Supply-Chain Integrity / AIBOM | Supply-Chain Compromise | Lifecycle Governance | D6 | C | 19 | 🟢 Commodity |
| `TC-060` | Continuous Agent Workflow Red-Teaming | Goal Hijacking / Emergent Misuse | Continuous Testing | D3 | B | 17 | 🟢 Commodity |
<!-- END GENERATED TABLES -->

---

## Vendor market map (informative)

The source matrix scored each capability against ~50 commercial platforms in
eight segments. The **segment shape** is durable; individual vendor names drift,
so this model keeps only the **coverage count** per control as the normative
signal and treats the vendor list as informative context:

| Segment | What it covers | Maps chiefly to |
|---|---|---|
| AI-SPM & Posture | Discovery, posture, shadow-AI | D1, D2 |
| Runtime Guardrails | Inline prompt/output mediation | D4 |
| Agent Authorization | NHI, FGA, MCP authz | D2 |
| Supply Chain & Testing | Red-team, eval, AIBOM | D3, D6 |
| Data Security for AI | Classification, DLP, need-to-know | D5 |
| Confidential AI | TEEs, encrypted inference | D7 |
| AI Governance | Risk, attestation, reporting | D8 |
| AI Evaluation | Scoring, judgment, observability | D3, D4 |

> Do **not** encode specific vendor names as normative in `spec/`. If a
> procurement shortlist is needed, keep it in a separate, dated,
> clearly-informative file so the model stays vendor-neutral and audit-defensible.

---

## How it is used

1. **Threat-model a system → pull its controls.** Identify which of the 24 risks
   a workload is exposed to (an agentic RAG app hits IM + MU + AG + SYS; a
   batch classifier may hit only IM + MU). The catalogue returns the exact
   `TC-*` controls, their enforcement layer, and the owning domain — a ready-made
   control set instead of a blank-page design.

2. **Design the reference architecture.** Group a system's required controls by
   **control-plane layer** to see the enforcement points to stand up — one
   Runtime Mediation pipeline, one Tool Gateway, one Observability plane — rather
   than 60 disconnected features.

3. **Feed the gates.** Each control carries its gate, so a workload's control set
   rolls straight into the Gate A–D evidence checks. "Which controls must clear
   Gate B for this app?" becomes a filter, not a workshop.

4. **Drive build-vs-buy and procurement.** The sourcing signal splits the
   backlog: 🔴 Build items go to engineering as reference implementations; 🟡/🟢
   items become procurement requirements mapped to the vendor segments above.

5. **Prioritise the roadmap.** The primary-domain roll-up is a heat map of where
   the control register is thin (D4 today). Expanding a domain's `controls.yaml`
   toward its `TC-*` set is a concrete, risk-justified backlog.

## Operational, not just descriptive

The catalogue is wired into the same as-code enforcement as the rest of the model:

| Capability | Where | What it does |
|---|---|---|
| **Validation** | [`tools/validate_catalogue.py`](../tools/validate_catalogue.py) | Checks IDs are contiguous, every `layer`/`domain`/`gate` resolves, signals match the platform band; emits the flattened [`spec/threat-control-catalogue.json`](../spec/threat-control-catalogue.json). CI fails on drift. |
| **Workload gate** | [`gates/workload-controls.rego`](../gates/workload-controls.rego) | Given a workload's `applicable_risks` + `control_status`, returns a pass/deny verdict for a chosen gate. Example: [`gates/examples/workload.input.json`](../gates/examples/workload.input.json). |
| **Console prototype** | [`prototype/`](../prototype) · [`prototype.html`](prototype.html) | Interactive UI to register a workload, declare risk exposure, and see controls + gate verdict compute live — running the same rule as the OPA policy. |

Evaluate a workload against a gate the way CI does:

```bash
opa eval -d gates -d spec/threat-control-catalogue.json \
  -i gates/examples/workload.input.json \
  'data.platform.workload.summary'
# => { "workload": "acme-support-agent", "gate": "B", "required": 15, "blocking": 0, "allow": true }
```

## Maintenance

- The YAML files are the source of truth; this document's tables are generated
  from [`spec/threat-control-catalogue.yaml`](../spec/threat-control-catalogue.yaml)
  and must be regenerated when it changes (see the marker block above).
- These files are **hand-authored** and intentionally **not** produced by
  `tools/scaffold.py`; they will not be overwritten by a scaffold run.
- When a new AI risk or capability emerges, add it here first (assign the next
  `TC-*` id, set `layer`/`domains`/`gate`/`platforms`/`signal`), then decide
  whether it warrants a new control in the owning domain's register.
