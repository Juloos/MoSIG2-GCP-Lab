#!/bin/sh

cd $(dirname $0)
source ./.env

git clone --depth 1 --branch v0 https://github.com/GoogleCloudPlatform/microservices-demo.git

cd microservices-demo
gcloud config set project $PROJECT_ID
gcloud services enable compute.googleapis.com

if [ -z "$(command -v terraform)" ]; then
    wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install terraform
fi

cd ..
terraform init

pip3 install ansible
