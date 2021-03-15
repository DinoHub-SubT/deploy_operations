#!/usr/bin/env bash
# //////////////////////////////////////////////////////////////////////////////
# docker entrypoint script
# //////////////////////////////////////////////////////////////////////////////
set -e

# add source of ros in bashrc so that on docker entry we will always have it sourced
echo "# Source ros melodic " >> ~/.bashrc
echo "source /opt/ros/melodic/setup.bash " >> ~/.bashrc
source /opt/ros/melodic/setup.bash
