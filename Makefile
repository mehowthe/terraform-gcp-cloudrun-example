# Populate with your variables
ENV := dev# dev / prod
PROJECT_NAME := ivy-xxxx
PROJECT_ID := $(PROJECT_NAME)-$(ENV)
STATE_BUCKET := $(PROJECT_NAME)-terraform-state
REGION := EUROPE-WEST3
SA_NAME := sa-tf-admin

all: create_project
setup_admin: create_state_bucket create_admin_service_account

create_project:
	# Create new project
	gcloud projects create $(PROJECT_ID) --set-as-default
	#Enable billing
	BILLING_ACCOUNT_ID=gcloud alpha billing accounts list --format 'value(name)'
	gcloud alpha billing projects link $PROJECT_ID --billing-account $BILLING_ACCOUNT_ID
	#Enable compute
	gcloud services enable compute.googleapis.com
	#Set project_id tfvars
	sed -i '' 's/{{PROJECT_ID}}/$(PROJECT_ID)/' ./terraform/app-$(ENV).tfvars

create_state_bucket:
	gsutil mb -l $(REGION) gs://$(STATE_BUCKET)
	#Set state bucket
	sed -i '' 's/{{STATE_BUCKET}}/$(STATE_BUCKET)/' ./terraform/backend.tf
	sed -i '' 's/{{PROJECT_NAME}}/$(PROJECT_NAME)/' ./terraform/backend.tf

# Optional
create_admin_service_account:
	gcloud iam service-accounts create $(SA_NAME) --description="Terraform Admin Service account" --display-name="Terraform Service Account"
	gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:sa-ivy-tf@tf-admin-366610.iam.gserviceaccount.com" --role="roles/editor"
