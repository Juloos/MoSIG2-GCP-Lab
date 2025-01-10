#!/bin/sh

cd $(dirname $0)

yes | python3 -m ansible playbook -i host locust_config.yaml
