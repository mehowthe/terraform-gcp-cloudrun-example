terraform {
  backend "gcs" {
    bucket = "{{STATE_BUCKET}}"
    prefix = "{{PROJECT_NAME}}/state"
  }
}
