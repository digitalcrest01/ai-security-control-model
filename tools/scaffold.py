#!/usr/bin/env python3
"""Scaffold generator for the AI Security Control Model.

Single source of truth -> spec/*.yaml + per-domain directories.
Re-runnable: rewrites generated files, leaves hand-authored files alone.
"""
import os, textwrap, pathlib

ROOT = pathlib.Path(os.environ.get("REPO", ".")).resolve()

PHASES = [
    dict(idx=0, id="p1-plan-discover",  n="PHASE 1", name="Plan & Discover",
         doing="Inventory, classify, assess risk", color="p1",
         gate=dict(id="A", slug="gate-a-known-estate", name="Known estate",
                   crit="AI assets inventoried, classified, owned and risk-scored. "
                        "Non-human identities under management. No untracked Shadow AI "
                        "above risk threshold.")),
    dict(idx=1, id="p2-build-develop",  n="PHASE 2", name="Build & Develop",
         doing="Design, code, test, validate", color="p2",
         gate=dict(id="B", slug="gate-b-secure-by-build", name="Secure by build",
                   crit="SAST and secrets clean. Red team and injection suites passed. "
                        "Policy-as-code enforced in CI/CD. No critical poisoning findings.")),
    dict(idx=2, id="p3-deploy-operate", n="PHASE 3", name="Deploy & Operate",
         doing="Run, interact, monitor, protect", color="p3",
         gate=dict(id="C", slug="gate-c-protected-production", name="Protected in production",
                   crit="Runtime guardrails and DLP live. Model registry signed. "
                        "Monitoring and anomaly detection operational across data and "
                        "model pipelines.")),
    dict(idx=3, id="p4-govern-assure",  n="PHASE 4", name="Govern & Assure",
         doing="Govern, audit, comply, improve", color="p4",
         gate=dict(id="D", slug="gate-d-assured-auditable", name="Assured & auditable",
                   crit="Controls mapped to NIST AI RMF, ISO 42001 and EU AI Act. "
                        "Evidence captured, dashboards live, improvement loop running. "
                        "Findings feed discovery.")),
]

MAT = {
    "mod-high":  "Moderate-High",
    "moderate":  "Moderate",
    "mod-low":   "Moderate-Low",
    "early-mod": "Early-Moderate",
}
COV = {
    "good":     "Good but fragmented",
    "partial":  "Partial coverage",
    "limited":  "Limited coverage",
    "vlimited": "Very limited coverage",
}

DOMAINS = [
    dict(phase=0, no="D1", slug="d1-asset-posture-management",
         name="AI Asset & Posture Management", mat="mod-high", cov="good",
         note="Well-established controls and tools.",
         std=["NIST AI RMF · MAP", "ISO/IEC 42001", "CIS Benchmarks"],
         caps=["AI Asset Inventory & Discovery", "AI Inventory & Classification",
               "Owner / Steward Mapping", "Data & Model Lineage", "Shadow AI Detection",
               "Posture & Config Assessment", "Risk Scoring & Prioritization"]),
    dict(phase=0, no="D2", slug="d2-identity-access",
         name="Identity & Access for Agents & AI", mat="mod-high", cov="good",
         note="Identity and access maturing for agents.",
         std=["NIST SP 800-207", "OWASP NHI Top 10", "CIS IAM"],
         caps=["Secure Non-human Identities", "Agent Identity Management",
               "MCP / Tool Authorization", "Least Privilege Enforcement",
               "Token & Session Control", "Secrets / Credential Management",
               "Entitlement & Policy Evaluation", "Anomaly Detection (Agents & NHIs)"]),
    dict(phase=1, no="D3", slug="d3-development-security-testing",
         name="Development Security & AI App Testing", mat="moderate", cov="partial",
         note="Shift-left improving, gaps remain.",
         std=["OWASP LLM Top 10", "NIST SSDF 800-218", "OWASP ASVS"],
         caps=["Build Secure AI Systems", "AI / SAST / Code Scanning",
               "Secrets & Data Exposure Scanning", "AI Red Teaming & Adversarial Testing",
               "Prompt Injection Testing", "Agent Behavior Testing",
               "Model / Data Poisoning Testing", "CI/CD Integration & Policy as Code"]),
    dict(phase=1, no="D4", slug="d4-runtime-protection",
         name="Runtime Protection & Interaction Security", mat="moderate", cov="partial",
         note="Runtime safeguards evolving.",
         std=["OWASP LLM01", "MITRE ATLAS", "NIST AI RMF · MANAGE"],
         caps=["Prompt Inspection & Content Filtering", "PII / Secrets Detection",
               "Jailbreak / Injection Detection", "Output Safety / Policy Enforcement",
               "Tool / Function Call Guardrails", "Runtime Monitoring & Anomaly Detection",
               "Response Validation & Blocking"]),
    dict(phase=2, no="D5", slug="d5-data-security",
         name="Data Security for AI", mat="mod-low", cov="limited",
         note="Data controls improving but uneven.",
         std=["ISO/IEC 27001", "NIST AI RMF · MEASURE", "UK GDPR / DPA 2018"],
         caps=["Data Discovery & Classification", "Access Control & Entitlements (RAG)",
               "Data Loss Prevention (DLP)", "Data Minimization & Masking",
               "Data Lineage (AI Pipelines)", "Retention & Destruction Controls",
               "Data Usage Auditing"]),
    dict(phase=2, no="D6", slug="d6-model-supply-chain",
         name="Model Security & Supply Chain", mat="mod-low", cov="limited",
         note="Model and supply chain security still early.",
         std=["SLSA", "CISA SBOM", "NIST SSDF", "MITRE ATLAS"],
         caps=["Model Provenance & Lineage", "Model Scanning (Malware / Backdoors)",
               "Vulnerability Management (Models / Libraries)", "AI Bill of Materials (AI BOM)",
               "Secure Model Registry & Signing", "Dependency & Third-Party Risk Management",
               "Model Integrity Monitoring"]),
    dict(phase=3, no="D7", slug="d7-confidential-ai-infrastructure",
         name="Confidential AI & Infrastructure", mat="early-mod", cov="vlimited",
         note="Confidential AI and infrastructure emerging.",
         std=["Confidential Computing Consortium", "FIPS 140-3", "ISO/IEC 27001"],
         caps=["Confidential Computing", "Encrypted Inference", "Key Management (BYOK)",
               "Private Data Processing", "Secure Multi-Party Computation",
               "Isolated Runtimes & Sandboxing", "Infrastructure Hardening"]),
    dict(phase=3, no="D8", slug="d8-governance-risk-compliance",
         name="Governance, Risk & Compliance", mat="moderate", cov="partial",
         note="Governance enabling, enforcement evolving.",
         std=["ISO/IEC 42001", "NIST AI RMF · GOVERN", "EU AI Act"],
         caps=["AI Risk Assessment", "Model Risk Management", "Regulatory Mapping & Controls",
               "Audit Logging & Evidence", "Reporting & Dashboards", "Policy Management",
               "Continuous Improvement", "Continuous Monitoring & Assurance"]),
]

FLOW = [
    dict(sn="STEP 1", h="Diagnostic sprint", dur="2–3 weeks",
         p="Score the current estate against all 8 domains. Run Shadow AI discovery and "
           "rank gaps by blast radius.",
         out="Maturity heat map + gap register"),
    dict(sn="STEP 2", h="Target operating model", dur="2 weeks",
         p="Define the secure target per domain. Identity as perimeter, control ownership "
           "set as a RACI.",
         out="Reference architecture + control catalogue"),
    dict(sn="STEP 3", h="Roadmap & business case", dur="1 week",
         p="Sequence the delta. Prioritise by coverage gap and risk reduction per pound spent.",
         out="Phased roadmap + cost/risk model"),
    dict(sn="STEP 4", h="Build & embed", dur="6–12 weeks",
         p="Ship landing zones, guardrails and gates as Terraform and policy-as-code wired "
           "into the pipeline.",
         out="IaC modules + OPA/Sentinel policies live"),
    dict(sn="STEP 5", h="Assure & run", dur="Ongoing",
         p="Continuous monitoring, evidence capture and audit mapping. Findings re-open "
           "discovery.",
         out="Dashboards + audit pack + improvement loop"),
]


def w(rel, content):
    p = ROOT / rel
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(textwrap.dedent(content).lstrip("\n"), encoding="utf-8")
    print("wrote", rel)


def yq(s):
    """Quote a scalar for YAML if it contains special chars."""
    if any(c in s for c in ":#·&*!|>%@`\"") or s.strip() != s:
        return '"' + s.replace('"', '\\"') + '"'
    return s


def ctrl_id(dno, i):
    return f"{dno}-{i:02d}"


# ---------------- spec/phases.yaml ----------------
def gen_phases():
    lines = ["# Lifecycle phases — generated from tools/scaffold.py (source of truth).",
             "# Four phases run as a continuous loop; each owns two domains and ends in a gate.",
             "phases:"]
    for ph in PHASES:
        dom_ids = [d["no"] for d in DOMAINS if d["phase"] == ph["idx"]]
        lines += [
            f"  - id: {ph['id']}",
            f"    index: {ph['idx']}",
            f"    label: {yq(ph['n'])}",
            f"    name: {yq(ph['name'])}",
            f"    activities: {yq(ph['doing'])}",
            f"    domains: [{', '.join(dom_ids)}]",
            f"    gate:",
            f"      id: {ph['gate']['id']}",
            f"      slug: {ph['gate']['slug']}",
            f"      name: {yq(ph['gate']['name'])}",
            f"      exit_criteria: {yq(ph['gate']['crit'])}",
        ]
    w("spec/phases.yaml", "\n".join(lines) + "\n")


# ---------------- spec/domains.yaml ----------------
def gen_domains_spec():
    lines = ["# Capability domains — generated from tools/scaffold.py (source of truth).",
             "domains:"]
    for d in DOMAINS:
        ph = PHASES[d["phase"]]
        lines += [
            f"  - id: {d['no']}",
            f"    slug: {d['slug']}",
            f"    name: {yq(d['name'])}",
            f"    phase: {ph['id']}",
            f"    maturity: {yq(MAT[d['mat']])}",
            f"    coverage: {yq(COV[d['cov']])}",
            f"    coverage_note: {yq(d['note'])}",
            f"    standards: [{', '.join(yq(s) for s in d['std'])}]",
            f"    controls:",
        ]
        for i, c in enumerate(d["caps"], 1):
            lines += [
                f"      - id: {ctrl_id(d['no'], i)}",
                f"        name: {yq(c)}",
                f"        status: not_started   # not_started | in_progress | implemented | verified",
                f"        owner: TODO",
            ]
    w("spec/domains.yaml", "\n".join(lines) + "\n")


# ---------------- spec/standards-map.yaml ----------------
def gen_standards():
    # invert: standard -> domains
    inv = {}
    for d in DOMAINS:
        for s in d["std"]:
            inv.setdefault(s, []).append(d["no"])
    lines = ["# Standards → domains mapping — the defensible audit answer.",
             "# Generated from tools/scaffold.py (source of truth).",
             "standards:"]
    for s in sorted(inv):
        lines += [f"  - name: {yq(s)}",
                  f"    domains: [{', '.join(inv[s])}]"]
    w("spec/standards-map.yaml", "\n".join(lines) + "\n")


# ---------------- spec/gates.yaml ----------------
def gen_gates_spec():
    lines = ["# Exit gates — generated from tools/scaffold.py (source of truth).",
             "# Each gate is enforced as an OPA policy under gates/<slug>.rego.",
             "gates:"]
    for ph in PHASES:
        g = ph["gate"]
        lines += [
            f"  - id: {g['id']}",
            f"    slug: {g['slug']}",
            f"    name: {yq(g['name'])}",
            f"    phase: {ph['id']}",
            f"    policy: gates/{g['slug']}.rego",
            f"    exit_criteria: {yq(g['crit'])}",
        ]
    w("spec/gates.yaml", "\n".join(lines) + "\n")


# ---------------- spec/delivery-model.yaml ----------------
def gen_flow():
    lines = ["# Delivery / engagement model — generated from tools/scaffold.py.",
             "steps:"]
    for s in FLOW:
        lines += [
            f"  - step: {yq(s['sn'])}",
            f"    name: {yq(s['h'])}",
            f"    duration: {yq(s['dur'])}",
            f"    activity: {yq(s['p'])}",
            f"    deliverable: {yq(s['out'])}",
        ]
    w("spec/delivery-model.yaml", "\n".join(lines) + "\n")


# ---------------- per-domain scaffolds ----------------
def gen_domain_dirs():
    for d in DOMAINS:
        ph = PHASES[d["phase"]]
        base = f"domains/{d['slug']}"
        caps_md = "\n".join(
            f"| `{ctrl_id(d['no'], i)}` | {c} | not_started | TODO |"
            for i, c in enumerate(d["caps"], 1))
        std_md = "\n".join(f"- {s}" for s in d["std"])

        readme = f"""
        # {d['no']} — {d['name']}

        > **Phase:** {ph['name']} (`{ph['id']}`) &nbsp;·&nbsp;
        > **Exit gate:** Gate {ph['gate']['id']} — {ph['gate']['name']}
        > (`gates/{ph['gate']['slug']}.rego`)

        | Attribute | Value |
        |---|---|
        | Market maturity | {MAT[d['mat']]} |
        | Current coverage | {COV[d['cov']]} |
        | Coverage note | {d['note']} |

        ## Purpose

        This domain packages the controls that answer for **{d['name'].lower()}**
        within the {ph['name']} phase. Every control is expressed as
        infrastructure and/or policy-as-code so it can be enforced in the delivery
        pipeline rather than asserted in a document.

        ## Controls

        | ID | Capability | Status | Owner |
        |---|---|---|---|
        {caps_md}

        Status vocabulary: `not_started` → `in_progress` → `implemented` → `verified`.
        The machine-readable source of truth is [`controls.yaml`](controls.yaml);
        keep it and this table in sync (regenerate with `tools/scaffold.py`).

        ## Standards this domain answers to

        {std_md}

        ## Layout

        ```
        {d['slug']}/
          README.md        this file
          controls.yaml    machine-readable control register
          terraform/       IaC that implements the controls (stubs)
          policies/        domain-level OPA policy (feeds the phase gate)
        ```

        ## Contributing controls

        1. Move the control's `status` forward in `controls.yaml`.
        2. Implement it under `terraform/` and/or `policies/`.
        3. Ensure the relevant assertion is exercised by
           `gates/{ph['gate']['slug']}.rego` so the phase gate can see it.
        """
        w(f"{base}/README.md", readme)

        # controls.yaml (domain-scoped slice)
        cy = [f"# {d['no']} — {d['name']}",
              f"# Generated by tools/scaffold.py; edit status/owner here as work progresses.",
              f"domain: {d['no']}",
              f"slug: {d['slug']}",
              f"phase: {ph['id']}",
              f"gate: {ph['gate']['slug']}",
              f"maturity: {yq(MAT[d['mat']])}",
              f"coverage: {yq(COV[d['cov']])}",
              f"controls:"]
        for i, c in enumerate(d["caps"], 1):
            cy += [f"  - id: {ctrl_id(d['no'], i)}",
                   f"    name: {yq(c)}",
                   f"    status: not_started",
                   f"    owner: TODO",
                   f"    evidence: []"]
        w(f"{base}/controls.yaml", "\n".join(cy) + "\n")

        # terraform stub
        modname = d["slug"].replace("-", "_")
        tf = f"""
        # {d['no']} — {d['name']}
        # Terraform stub. Replace resources with the real implementation per control.
        # This module is intended to be consumed from an environment root that also
        # instantiates modules/landing-zone (the shared secure baseline).

        terraform {{
          required_version = ">= 1.6.0"
        }}

        variable "environment" {{
          description = "Deployment environment (e.g. dev, staging, prod)."
          type        = string
        }}

        variable "labels" {{
          description = "Common resource labels/tags."
          type        = map(string)
          default     = {{}}
        }}

        locals {{
          domain = "{d['no']}"
          # Control register for this domain — see controls.yaml for status/owner.
          controls = [
        {os.linesep.join(f'            "{ctrl_id(d["no"], i)}", # {c}' for i, c in enumerate(d['caps'], 1))}
          ]
        }}

        # TODO: implement controls for {d['name']}.
        # Each control above should map to concrete resources or data sources here.

        output "{modname}_controls" {{
          description = "Control IDs this module is responsible for."
          value       = local.controls
        }}
        """
        w(f"{base}/terraform/main.tf", tf)

        # policy stub
        pkg = "domain." + d["slug"].replace("-", "_")
        rego = f"""
        # {d['no']} — {d['name']} — domain policy (stub).
        # Findings here are consumed by the phase gate: gates/{ph['gate']['slug']}.rego
        package {pkg}

        # Example scaffold assertion. Replace with real control checks that read
        # from `input` (scan results, terraform plan, inventory, etc.).
        #
        # deny contains msg if {{
        #   some c in input.controls
        #   c.status == "not_started"
        #   msg := sprintf("control %v is not started", [c.id])
        # }}
        """
        w(f"{base}/policies/{d['slug']}.rego", rego)


gen_phases()
gen_domains_spec()
gen_standards()
gen_gates_spec()
gen_flow()
gen_domain_dirs()
print("done")
