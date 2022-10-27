locals {
  subnet_name = "cloud-run-subnet"
}

module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 4.0.1"
  project_id   = var.project_id
  network_name = "cloud-run-vpc"

  subnets = [
    {
      subnet_name           = local.subnet_name
      subnet_ip             = "10.10.0.0/28"
      subnet_region         = var.region
      subnet_private_access = "true"
      description           = "Cloud Run VPC Connector Subnet"
    }
  ]
}

resource "google_compute_firewall" "allow_redis" {
  name    = "fw-allow-redis"
  network = module.vpc.network_name
  allow {
    protocol = "tcp"
    ports    = [local.redis_port]
  }
  source_service_accounts = [google_service_account.hello_sa.email]
}

module "serverless_connector" {
  source  = "terraform-google-modules/network/google//modules/vpc-serverless-connector-beta"
  version = "~> 4.0"

  project_id = var.project_id
  vpc_connectors = [{
    name            = "vpc-serverless-connector"
    region          = var.region
    subnet_name     = local.subnet_name
    host_project_id = var.project_id
    machine_type    = "e2-micro"
    min_instances   = 2
    max_instances   = 3
  }]
}
