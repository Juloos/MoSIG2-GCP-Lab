#!/bin/sh

cd $(dirname $0)

terraform apply -auto-approve
