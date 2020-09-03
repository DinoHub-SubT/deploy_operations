#!/usr/bin/env bash
. "$(dirname $0)/.header.bash"
. "$(dirname $0)/../.header.bash"

# //////////////////////////////////////////////////////////////////////////////
# @brief: script main entrypoint
# //////////////////////////////////////////////////////////////////////////////
# title "Deployer Git Fetch\n"

# push script path
# __dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
# pushd $__dir

# trap ctrl-c and call ctrl_c
# trap ctrl_c INT

# check every connection in the user's ssh config
# sshtraverse $GL_SSH_CONFIG display

if check_nth_flag 1 "subt" "$@"; then
  echo "check nth success"
else
  echo "check nth failed"
fi
