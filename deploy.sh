#!/bin/sh

kubectl apply -f ./kubernetes-manifests.yaml
echo "Everything is up, IP: $(kubectl get service frontend-external | awk '{print $4}' | tail -n 1)"
