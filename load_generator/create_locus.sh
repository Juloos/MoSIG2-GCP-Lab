#!/bin/sh

cd $(dirname $0)

IP=`terraform apply -auto-approve | tail -n 1 | grep -E -o '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'`
printf "[locust_node]\n$IP\n\n[all:vars]\nansible_ssh_user=ansible\nansible_ssh_private_key_file=~/.ssh/load_generator.key\n" > host
gcloud compute project-info add-metadata --metadata enable-oslogin=TRUE
gcloud compute os-login sshkeys add --key-file ~/.ssh/load_generator.key.pub --ttl 0
ssh -i ~/.ssh/load_generator.key ansible@$IP
