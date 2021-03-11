#!/usr/bin/env bash

set -e

# log message
echo " == Perception Shell == "

# Install the deploy workspace
echo " ==  Install The Deploy Workspace =="
cd ~/deploy_ws/src/
./install-deployer.bash --install

# source the bashrc -- so we have the deploy_ws path set
source ~/.bashrc

# setup roscore IP/hostnames
_SET_ROSCORE=true
_SET_WS=false
source /docker-entrypoint/roscore-env-setup.bash

# remove any previous alias
remove_ros_top_level_ws "zshrc"
remove_ros_top_level_ws "bashrc"

# //////////////////////////////////////////////////////////////////////////////
# add ros melodic source to bashrc and zshrc
echo " ==  Add ROS Melodic Source =="
# setup source
_SET_ROSCORE=false
_SET_WS=false
_ROS_WS="/opt/ros/melodic/setup.bash"

# add source path to zsh, bash configs
add_ros_top_level_ws "zshrc"
add_ros_top_level_ws "bashrc"

# //////////////////////////////////////////////////////////////////////////////
# add deploy source
echo " ==  Add Deploy Source =="
# setup source
_SET_ROSCORE=false
_SET_WS=false
_ROS_WS="\$ws_devel_source"

# add source path to zsh, bash configs
add_ros_top_level_ws "zshrc"
add_ros_top_level_ws "bashrc"

# //////////////////////////////////////////////////////////////////////////////
# source openvino
echo "# ==  OpenVino =="  >> /$homedir/.bashrc
# echo "/opt/intel/openvino/bin/setupvars.sh" >> /$homedir/.bashrc
echo "export PYTHONPATH=\$PYTHONPATH:/tensorflow/models/research:/tensorflow/models/research/slim/" >> /$homedir/.bashrc
# echo "source /opt/intel/openvino/bin/setupvars.sh" >> /$homedir/.bashrc
echo "export LD_LIBRARY_PATH=/usr/local/lib:\$LD_LIBRARY_PATH" >> /$homedir/.bashrc

# source the bashrc again -- to set the added ros variables
source ~/.bashrc

# Disallow docker exit -- keep container running
echo "Entrypoint ended";
/bin/bash "$@"
