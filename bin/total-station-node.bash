#!/usr/bin/env bash
# //////////////////////////////////////////////////////////////////////////////
# display usage


usage_msg="\
Usage: $(basename $0)
options:
  * optional arguments are enclosed in square brackets
  Removes all bag files on all robots

For more help, please see the README.md or wiki."


# load print-info
. "$(dirname $0)/utils.bash"
validate "load utils failed"

# load args
. "$(dirname $0)/args.bash"
validate "load utils failed"

pushd "/home/$(whoami)/deploy_ws/src/"

divider_large
warning_title "launching total station node"
./deployer -s basestation.total-station-node;

echo "Exiting."


# roslaunch ~/deploy_ws/src/basestation/total_station_gate_node/launch/total_station_node.launch