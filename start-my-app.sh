#!/bin/bash

ProjectID="roi-takeoff-user4"

if [ $GOOGLE_CLOUD_PROJECT == "" ]; then
	export GOOGLE_CLOUD_PROJECT=$ProjectID
fi
echo "ProjectID ="$GOOGLE_CLOUD_PROJECT

gcloud builds submit --tag gcr.io/$GOOGLE_CLOUD_PROJECT/image10

cd tf 
terraform init && terraform apply -auto-approve

gcloud endpoints services deploy openapi-run.yaml --project $GOOGLE_CLOUD_PROJECT


gcloud services enable servicemanagement.googleapis.com &&
gcloud services enable servicecontrol.googleapis.com &&
gcloud services enable endpoints.googleapis.com &&
gcloud services enable cloudrun-srv-ega5bq4rma-uc.a.run.app