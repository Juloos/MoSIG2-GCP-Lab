#!/bin/sh

cd $(dirname $0)

# Terraform will output the line ip = "X.X.X.X" which we need to extract for ansible
echo "[locust_node]\n" > host
terraform apply -auto-approve | grep "ip = " | sed -e 's/ip = //' -e 's/"//g' >> host
