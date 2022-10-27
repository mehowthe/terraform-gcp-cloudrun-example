## Terraform + GCP 

Includes:
* Cloud Run with `gcr.io/cloudrun/hello` image
* Service Account with the roles `roles/run.viewer` and `roles/run.invoker`
* Ingress set to allow only internal traffic
* access to a Redis instance through a VPC
* multi env support (Terraform workspaces)

## Initial setup

1. Use `Makefile` to setup backend: `make create_state_bucket`
2. Use `Makefile` to create projects (dev, prod). It should replace values in .tfvars

### Authenticate to gcp:

* use cached local credentials: 
    
    `gcloud auth application-default login`

* or use service account (`make create_admin_service_account`) + download this service account credentials in json
  https://cloud.google.com/iam/docs/creating-managing-service-account-keys
and specify your credentials in main.tf -> provider "google"




___
by mehowthe 2022, MIT license. See the LICENSE file for more info.
