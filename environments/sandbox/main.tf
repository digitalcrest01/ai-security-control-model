# Sandbox environment — the D2 Identity vertical slice on GCP.
#
# estate.yaml is the single inventory source of truth. Terraform turns every
# declared AI asset into a managed, least-privilege service account via the
# landing zone; the same file drives Gate A ("Known estate"). Add a workload =
# add an entry to estate.yaml.

provider "google" {
  project = var.project_id
  region  = var.region
}

locals {
  estate = yamldecode(file("${path.module}/estate.yaml"))

  # Project each inventory asset into a landing-zone workload identity.
  workload_identities = {
    for a in local.estate.assets : a.id => {
      roles       = a.roles
      description = a.description
      owner       = a.owner
      data_class  = a.data_class
    }
  }
}

module "landing_zone" {
  source = "../../modules/landing-zone"

  project_id          = var.project_id
  region              = var.region
  environment         = "sandbox"
  workload_identities = local.workload_identities

  labels = {
    team  = "security"
    slice = "d2-identity"
  }
}
