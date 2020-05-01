#!/bin/bash
# Install docker & docker-tools on the remote VM
ansible-playbook -v -i inventory/azure.ini docker.yaml --limit azure-perception
ansible-playbook -v -i inventory/azure.ini docker-tools.yaml --limit azure-perception

# Clones the deploy repo on the remote VM (can take 30 minutes)
# You do not need to clone the repo on the remote VM manually, this command will do that for you.
ansible-playbook -v -i inventory/azure.ini git-repository.yaml --limit azure-perception
