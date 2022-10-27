resource "google_secret_manager_secret" "super_secret_password" {
  provider = google-beta

  secret_id = "password"
  replication {
    automatic = true
  }
}
