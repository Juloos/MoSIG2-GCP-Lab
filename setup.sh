#!/bin/sh

cd $(dirname $0)

git clone --depth 1 --branch v0 https://github.com/GoogleCloudPlatform/microservices-demo.git
cd microservices-demo

gcloud config set project online-boutique-cloud-m2-jules
gcloud services enable container.googleapis.com
