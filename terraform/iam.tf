resource "google_service_account" "hello_viewer_invoker_sa" {
  account_id   = "cloud-run-hello-view-invoker"
  display_name = "Cloud Run Hello View / Invoker"
}

resource "google_service_account" "hello_sa" {
  account_id   = "hello-service-account"
  display_name = "Hello Cloud Run service account"
}

resource "google_cloud_run_service_iam_policy" "run_view_invoke_policy" {
  location    = google_cloud_run_service.hello_run_service.location
  project     = google_cloud_run_service.hello_run_service.project
  service     = google_cloud_run_service.hello_run_service.name
  policy_data = data.google_iam_policy.run_invoker_viewer_policy.policy_data
}

resource "google_project_iam_member" "hello_sa_secrets_reader" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.hello_sa.email}"
}

data "google_iam_policy" "run_invoker_viewer_policy" {
  binding {
    role = "roles/run.invoker"
    members = [
      "serviceAccount:${google_service_account.hello_viewer_invoker_sa.email}",
    ]
  }
  binding {
    role = "roles/run.viewer"
    members = [
      "serviceAccount:${google_service_account.hello_viewer_invoker_sa.email}",
    ]
  }
}
