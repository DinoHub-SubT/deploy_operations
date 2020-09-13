#!/usr/bin/env bash
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/hooks/.header.bash"
. "$SUBT_PATH/operations/bin/hooks/.help.bash"

# //////////////////////////////////////////////////////////////////////////////
# @brief: main entrypoint
# //////////////////////////////////////////////////////////////////////////////
pushd "$SUBT_PATH/"

# TODO: get catkin package name flag, then export for catkin build & clean

./deployer -s $@
popd

exit_success
