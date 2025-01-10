#!/bin/sh

cd $(dirname $0)

ansible-playbook -i host locust_config.yaml
