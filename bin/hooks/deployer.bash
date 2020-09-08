#!/usr/bin/env bash
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/hooks/.header.bash"
. "$SUBT_PATH/operations/bin/hooks/.help.bash"

__inrepo=""
 pushd "$SUBT_PATH/"
./deployer -s $1
popd

exit_success
