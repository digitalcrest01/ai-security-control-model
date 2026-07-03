# Control Plane console — prototype

A working, data-driven prototype of what the model looks like **as a product**:
a console where a security architect registers an AI workload, declares its
**risk exposure**, and watches its **required controls** derive and an **exit
gate** pass or fail — live.

- **The console:** [`../docs/prototype.html`](../docs/prototype.html) — a
  self-contained page (open it in any browser). It is driven entirely by
  [`../spec/threat-control-catalogue.json`](../spec/threat-control-catalogue.json),
  and its gate verdict runs the **same rule** as the platform policy
  [`../gates/workload-controls.rego`](../gates/workload-controls.rego).
- **The GCP deployment shape:** [`main.tf`](main.tf) — an illustrative Cloud Run
  stub showing how the console is served in GCP behind a least-privilege runtime
  identity, private by default. A stub, not a live estate.

## What a user does

1. **Pick a workload** — three presets model different autonomy levels
   (assisted RAG agent, autonomous coding agent, batch classifier).
2. **Declare risk exposure** — toggle the risks the workload is subject to,
   grouped by the four tiers (Inherent Model → Model Use → Agentic → Control
   Plane). The required control set re-derives instantly.
3. **Work the controls** — each required control shows its control-plane layer,
   owning domain, exit gate and build-vs-buy sourcing. Click a status to advance
   it (`not started → in progress → implemented → verified`).
4. **Read the verdict** — the banner and the four gate chips show, live, whether
   the workload clears each gate for its risk profile, and which controls block.

## How the simulation stays honest

The verdict is not hand-waved. `evalGate()` in the console applies exactly what
the OPA policy applies: *a control is satisfied only when `implemented` or
`verified`; any in-scope, in-gate control below that blocks the gate.* So what
you see in the browser is what CI would enforce on a release.

## Deploying the shape (illustrative)

```bash
cd prototype
terraform init
terraform apply \
  -var project_id=my-ai-security-project \
  -var console_image=REGION-docker.pkg.dev/my-project/aegis/console:latest
# invoker_domain left empty => service stays private (no public access)
```

`terraform validate`/`fmt` are exercised repo-wide by CI (Terraform ≥ 1.6).
