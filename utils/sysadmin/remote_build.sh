#!/bin/bash

start_path=$(pwd)

host=$1
type=$2 # eg: gpu

if [ -z "$SUBT_PATH" ]; then
    echo "SUBT_PATH not found!!! Make sure the deployer is installed and ~/bashrc is sourced!"
    exit 1
fi

if [ -z "$host" ]; then
    echo "remote_build.sh <host> <type>"
    echo "  <host> can be azure.perception1, robots.ugv1.ppc, etc..."
    echo "  <type> can be gpu or cpu (supposing the host has that option, otherwise this can be omitted)"
    echo
    echo "This script will do a skeleton copy of code to the host, then runs a catkin build in the docker."
    exit
fi
if [ -z "$type" ] && [[ $host == azure.perception* ]]; then
    type="gpu"
fi


cd $SUBT_PATH

./deployer -s ${host}.skel_t.to && \
./deployer -s ${host}.${type}.catkin.build

cd $start_path