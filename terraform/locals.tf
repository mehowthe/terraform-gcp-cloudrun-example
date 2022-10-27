locals {
  enabled_apis = [
    "run.googleapis.com",
    "secretmanager.googleapis.com",
    "vpcaccess.googleapis.com"
  ]
  redis_port = 6379
}
