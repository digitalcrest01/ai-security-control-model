# Control Plane console — GCP reference deployment (prototype / illustrative).
#
# Shows the SHAPE of how the console in docs/prototype.html is served in GCP:
# a Cloud Run service running behind a least-privilege runtime identity, kept
# private by default. It is a stub — `console_image` points at a placeholder and
# no state is wired — so it documents intent without provisioning a real estate.
#
# It deliberately mirrors the model's own doctrine: every workload gets its own
# managed, least-privilege service account (see modules/landing-zone), and
# nothing is public unless explicitly granted.

locals {
  service_name = "aegis-control-plane-console"
}

# Dedicated runtime identity for the console — no default compute SA.
resource "google_service_account" "console" {
  project      = var.project_id
  account_id   = "aegis-console"
  display_name = "Aegis Control Plane console (runtime)"
  description  = "Least-privilege runtime identity for the AI Security Control Plane console."
}

resource "google_cloud_run_v2_service" "console" {
  project  = var.project_id
  name     = local.service_name
  location = var.region

  # Private by default; expose only through an authenticated ingress/IAP.
  ingress = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"

  template {
    service_account = google_service_account.console.email

    scaling {
      min_instance_count = 0
      max_instance_count = 2
    }

    containers {
      image = var.console_image

      # The console is driven entirely by the catalogue; in a real build the
      # image bundles spec/threat-control-catalogue.json (or reads it from a
      # bucket) so gate evaluation matches what CI enforces.
      env {
        name  = "CATALOGUE_SOURCE"
        value = "spec/threat-control-catalogue.json"
      }

      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }
    }
  }
}

# Grant invoke only when a domain is provided; otherwise the service stays private.
resource "google_cloud_run_v2_service_iam_member" "invoker" {
  count    = var.invoker_domain == "" ? 0 : 1
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.console.name
  role     = "roles/run.invoker"
  member   = "domain:${var.invoker_domain}"
}

output "console_url" {
  description = "Cloud Run URL of the console (reachable per the ingress/IAM policy above)."
  value       = google_cloud_run_v2_service.console.uri
}

output "runtime_service_account" {
  description = "Least-privilege identity the console runs as."
  value       = google_service_account.console.email
}
