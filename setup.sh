#!/bin/sh

cd $(dirname $0)
source ./.env

git clone --depth 1 --branch v0 https://github.com/GoogleCloudPlatform/microservices-demo.git
cd microservices-demo

gcloud config set project $PROJECT_ID
gcloud services enable container.googleapis.com
