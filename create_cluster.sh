#!/bin/sh

cd $(dirname $0)

source .env

gcloud container clusters create online-boutique -m ${MACHINE_TYPE} --project=${PROJECT_ID} --region=${REGION} --num-nodes=${NUM_NODES}

( sleep 12h ; ./delete_cluster.sh ) &
