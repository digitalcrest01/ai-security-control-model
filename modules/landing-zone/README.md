# Module: `landing-zone` (GCP)

The shared secure baseline that new AI workloads inherit **by default**, and the
anchor for the whole model — controls that live in slideware do not survive
contact with a release pipeline, so the baseline is real Terraform.

Design order is deliberate (identity first, then keys, then storage):

1. **Identity is the primary perimeter.** One dedicated `google_service_account`
   per AI workload, with **no user-managed keys** — managed non-human identities
   by construction (callers use workload identity / ADC, not exported key files).
2. **Least privilege.** Each identity is granted only the project IAM roles it
   declares (`google_project_iam_member`, one binding per identity×role).
3. **Key management (BYOK).** A KMS key ring + rotating crypto key for encrypted
   inference / private data processing, protected with `prevent_destroy`.
4. **Versioned, access-controlled storage.** An artifact bucket with versioning,
   uniform bucket-level access, and public-access prevention enforced.

## Inputs

| Name | Type | Description |
|---|---|---|
| `project_id` | string | GCP project that hosts the landing zone. |
| `region` | string | Region for regional resources (default `europe-west2`). |
| `environment` | string | e.g. `dev`, `staging`, `prod`, `sandbox`. |
| `workload_identities` | map(object) | `{roles, description, owner, data_class}` per identity; the key is the service-account `account_id`. |
| `labels` | map(string) | Common labels. |
| `key_rotation_period` | string | BYOK key rotation (default `7776000s` = 90 days). |

## Outputs

`workload_identity_emails`, `workload_identity_ids`, `kms_crypto_key_id`,
`artifacts_bucket`, `name_prefix`, `base_labels`.

## Usage

Consumed by an environment root (see [`environments/sandbox`](../../environments/sandbox)),
which builds `workload_identities` from the estate inventory:

```hcl
module "landing_zone" {
  source      = "../../modules/landing-zone"
  project_id  = var.project_id
  region      = var.region
  environment = "sandbox"

  workload_identities = {
    "rag-search" = {
      roles       = ["roles/aiplatform.user", "roles/secretmanager.secretAccessor"]
      description = "RAG search agent"
      owner       = "platform-eng"
      data_class  = "internal"
    }
  }
}
```

> **Note:** `terraform validate` needs no credentials, but `terraform plan`/
> `apply` do (the Google provider loads ADC at init). Authenticate with
> `gcloud auth application-default login` or a service-account key before planning.
