#!/bin/sh

cd $(dirname $0)

source .env

gcloud container clusters delete online-boutique --project=${PROJECT_ID} --region=${REGION}
