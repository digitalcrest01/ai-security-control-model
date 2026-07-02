# Sandbox environment — D2 Identity slice (GCP)

The first vertical slice of the model, wired end-to-end: **inventory → IaC →
evidence → gate**. It provisions a managed, least-privilege identity for every
AI workload declared in [`estate.yaml`](estate.yaml) and proves the estate
passes **Gate A ("Known estate")**.

```
estate.yaml ──▶ Terraform (landing-zone) ──▶ managed service accounts (+ KMS, bucket)
     │                                                   │
     └────────────▶ collect_gate_a_evidence.py ◀─────────┘  (terraform show -json)
                                │
                                ▼
                    opa eval data.gates.gate_a  ──▶ deny == []  ✅
```

## What gets created

- One `google_service_account` per asset in `estate.yaml` (no user-managed keys).
- Least-privilege project IAM bindings (only each asset's declared `roles`).
- A BYOK KMS key ring + rotating crypto key.
- A versioned, access-controlled artifact bucket.

## Validate (no credentials needed)

```bash
cd environments/sandbox
terraform init -backend=false
terraform validate
```

## Deploy for real

Requires GCP credentials and an existing project you can create resources in.

```bash
cd environments/sandbox
cp terraform.tfvars.example terraform.tfvars      # set project_id, region
gcloud auth application-default login             # or export GOOGLE_APPLICATION_CREDENTIALS

terraform init                                    # uncomment the gcs backend in versions.tf first
terraform plan  -out plan.bin
terraform apply plan.bin
```

## Prove the gate on real infrastructure

After a plan/apply, derive Gate A evidence from actual Terraform output and
evaluate the gate against it (no hand-written fixture):

```bash
# from the repo root
terraform -chdir=environments/sandbox show -json environments/sandbox/plan.bin > plan.json

python3 tools/collect_gate_a_evidence.py \
  --estate environments/sandbox/estate.yaml \
  --provisioned plan.json \
  --out gate-a.evidence.json

opa eval -f pretty -d gates -i gate-a.evidence.json 'data.gates.gate_a.deny'
# [] means Gate A passes: every declared asset is classified, owned, risk-scored,
# and provisioned as a managed identity, with no Shadow AI over the threshold.
```

`--provisioned` accepts a `terraform show -json` document (service accounts are
extracted automatically) or a plain JSON array of `account_id`s. Omit it to
check the classification/ownership controls before anything is applied.

## How it fails (the gate has teeth)

- Add an asset to `estate.yaml` with no `owner`/`data_class`/`risk_score`
  → Gate A denies (unclassified / unowned / unscored).
- Add an entry to `shadow_ai` with `risk_score >= thresholds.shadow_ai_risk`
  → Gate A denies (untracked Shadow AI over threshold).
- Declare an asset but don't provision it (missing from `--provisioned`)
  → Gate A denies (identity not under management).

CI exercises the passing path on every push (see the **Gate A evidence chain**
job) and the failing paths as unit tests in
[`gates/gate-a-known-estate_test.rego`](../../gates/gate-a-known-estate_test.rego).

## Teardown

```bash
terraform destroy
```

(The BYOK crypto key has `prevent_destroy = true`; remove that lifecycle block or
destroy the key manually if you really intend to delete it.)
