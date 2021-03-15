#!/usr/bin/env bash
# //////////////////////////////////////////////////////////////////////////////
# docker entrypoint script
# //////////////////////////////////////////////////////////////////////////////
set -e

# log message
echo " == SubT Basestation roscore == "

# setup roscore IP/hostnames and source any workspaces
_SET_ROSCORE=true
_SET_WS=true
_ROS_WS="/opt/ros/melodic/setup.bash"
source /docker-entrypoint/roscore-env-setup.bash

# source the bashrc to set the added ros variables
source ~/.bashrc

# start roscore using deployer
roscore

# TODO: if error, catch & stay open.
