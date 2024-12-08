#!/bin/sh

cd $(dirname $0)
source ./.env
cd microservices-demo

gcloud container clusters create online-boutique -m ${MACHINE_TYPE} --region=${REGION} --num-nodes=${NUM_NODES}
( sleep 12h ; ./delete_cluster.sh ) &
