#!/bin/sh

cd $(dirname $0)
cd microservices-demo

kubectl apply -f ./release/kubernetes-manifests.yaml
