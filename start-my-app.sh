#!/bin/bash

ProjectID="roi-takeoff-user4"

if [ $GOOGLE_CLOUD_PROJECT == "" ]; then
	export GOOGLE_CLOUD_PROJECT=$ProjectID
fi
echo "ProjectID ="$GOOGLE_CLOUD_PROJECT

gcloud builds submit --tag gcr.io/$GOOGLE_CLOUD_PROJECT/image10

cd tf 
terraform init && terraform apply -auto-approve