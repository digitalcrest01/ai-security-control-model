# Module: `landing-zone`

The shared secure baseline that new AI workloads inherit **by default**. This is
the anchor for the whole model — controls that live in slideware do not survive
contact with a release pipeline, so the baseline is expressed as code here.

Design rules (see the root README, "Built as code, enforced as policy"):

1. **Identity is modelled first**, before network or compute. Every workload
   gets a dedicated, least-privilege non-human identity.
2. **State files are encrypted, versioned and access-controlled.** Drift
   detection runs on a schedule (wired into CI).
3. **Secure landing zones carry the baseline** so new AI workloads inherit it.

> Status: **stub.** Resources are `null_resource` placeholders. Replace them
> with real provider resources (`google_*`, `azurerm_*`) as the baseline is
> implemented. It intentionally has no provider block so it stays cloud-agnostic
> until an environment root wires one in.

## Usage

```hcl
module "landing_zone" {
  source      = "../../modules/landing-zone"
  environment = "prod"
  cloud       = "gcp"
  org_id      = var.org_id

  workload_identities = {
    "rag-search" = {
      roles       = ["roles/aiplatform.user"]
      description = "RAG search agent"
    }
  }
}
```

Domain modules under `domains/<slug>/terraform/` consume this baseline.
