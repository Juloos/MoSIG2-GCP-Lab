#!/bin/sh

cd $(dirname $0)

ssh-keygen -f ~/.ssh/known_hosts -R "$IP" > /dev/null
yes | python3 -m ansible playbook -i host locust_config.yaml
