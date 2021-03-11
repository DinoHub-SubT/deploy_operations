#!/usr/bin/env bash
# //////////////////////////////////////////////////////////////////////////////
# docker entrypoint script
# //////////////////////////////////////////////////////////////////////////////
set -e

# log message
echo " == Workspace Shell == "

# Install the deploy workspace
echo " ==  Install The Deploy Workspace =="
cd ~/deploy_ws/src/
./install-deployer.bash --install

# source the bashrc -- so we have the deploy_ws path set
source ~/.bashrc

# setup roscore IP/hostnames and source the project workspaces
_SET_ROSCORE=false
_SET_WS=true
_ROS_WS="\$ws_devel_source"
# _ROS_WS="/opt/ros/melodic/setup.bash"
source /docker-entrypoint/roscore-env-setup.bash

# source the bashrc again -- to set the added ros variables
source ~/.bashrc

# unset ROS_HOSTNAME
unset ROS_IP

# Disallow docker exit -- keep container running
echo "Entrypoint ended";
/bin/bash "$@"
