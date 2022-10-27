provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

resource "google_project_service" "enabled_apis" {
  for_each                   = toset(local.enabled_apis)
  project                    = var.project_id
  service                    = each.value
  disable_dependent_services = true
  disable_on_destroy         = true
}

resource "google_cloud_run_service" "hello_run_service" {
  name     = "hello-app-${var.workspace}"
  location = var.region

  template {
    metadata {
      annotations = {
        "run.googleapis.com/vpc-access-connector" = element(tolist(module.serverless_connector.connector_ids), 1)
        "run.googleapis.com/vpc-access-egress"    = "all-traffic"
        "run.googleapis.com/ingress"              = "internal"
      }
    }
    spec {
      service_account_name = google_service_account.hello_sa.email
      containers {
        image = "gcr.io/cloudrun/hello:latest"
        env {
          name = "PASSWORD"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.super_secret_password.secret_id
              key  = "1"
            }
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [google_project_service.enabled_apis[0]]
}
