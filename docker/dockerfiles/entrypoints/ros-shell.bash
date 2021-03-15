#!/usr/bin/env bash
# //////////////////////////////////////////////////////////////////////////////
# docker entrypoint script
# //////////////////////////////////////////////////////////////////////////////
set -e

# log message
echo " == ROS Shell == "

# Update deployer workspace & python install permissions
# -- for some reason, these paths sometimes are set as root user. For now just set it to the developer
# -- Yes, it is ugly to hardcode 'developer'. For now its fine, should fix the hardcode later.
# chown -R developer:developer /home/developer/.local/lib/python2.7/site-packages/
# chown -R developer:developer /home/developer/deploy_ws/

# setup roscore IP/hostnames and source any workspaces
_SET_ROSCORE=true
_SET_WS=true
_ROS_WS="/opt/ros/melodic/setup.bash"
source /docker-entrypoint/roscore-env-setup.bash

# source the bashrc to set the added ros variables
source ~/.bashrc

# Disallow docker exit -- keep container running
echo "Entrypoint ended";
/bin/bash "$@"
