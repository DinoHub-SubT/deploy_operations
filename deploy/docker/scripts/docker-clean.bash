#!/usr/bin/env bash

# get the docker registry argument
REGISTRTY_FILTER=${1}

# get the docker name and tag
docker rmi $(docker images --format '{{.Repository}}:{{.Tag}}' | grep "${REGISTRTY_FILTER}") || true
