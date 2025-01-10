#!/bin/sh

cd $(dirname $0)
source ./.env
cd microservices-demo

gcloud container clusters delete online-boutique --region=${REGION}
