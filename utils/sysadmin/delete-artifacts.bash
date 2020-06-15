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
warning_title "removing artifacts from basestation"
./deployer -s basestation.delete-artifacts

echo "Done delete artifacts."