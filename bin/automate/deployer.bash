#!/usr/bin/env bash
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/automate/.header.bash"
. "$SUBT_PATH/operations/bin/automate/.help.bash"

# //////////////////////////////////////////////////////////////////////////////
# @brief: main entrypoint
# //////////////////////////////////////////////////////////////////////////////
pushd "$SUBT_PATH/"

# TODO: get catkin package name flag, then export for catkin build & clean

./deployer -s $@
popd

exit_success
