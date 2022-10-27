output "service_url" {
  value = google_cloud_run_service.hello_run_service.status[0].url
}
