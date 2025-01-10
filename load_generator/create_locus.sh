#!/bin/sh

cd $(dirname $0)

IP=`terraform apply -auto-approve | tail -n 1 | grep -E -o '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'`
printf "[locust_node]\n$IP\n\n[all:vars]\nansible_ssh_user=$(cat ../.username)\nansible_ssh_private_key_file=~/.ssh/load_generator.key\nansible_ssh_common_args='-o StrictHostKeyChecking=no'\n" > host
echo "Instance created, IP: $IP"
