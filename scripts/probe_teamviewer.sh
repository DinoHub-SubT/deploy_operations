#!/usr/bin/env bash

# load header helper functions
. "$SUBT_PATH/operations/scripts/header.sh"
. "$SUBT_PATH/operations/scripts/formatters.sh"

if chk_flag --help $@ || chk_flag help $@ || chk_flag -h $@; then
  GL_TEXT_COLOR=$FG_LCYAN
  text
  title "Usage: $(basename $0) [flag] "
  text_color  "Flags:"
  text_color "      -help : shows usage message."
  text_color "Shows which teamviewer connections are are available to connect."
  text_color "For more help, please see the README.md or wiki."
  GL_TEXT_COLOR=$FG_DEFAULT
  exit_success
fi

# display teamviewer ids for all ssh conections
function display() {
  local connection=$1
  if ssh -q -o BatchMode=yes -o ConnectTimeout=1 $str exit 2>/dev/null; then
    teamviewer_id=$(ssh $connection 'sudo teamviewer --info | grep "TeamViewer ID"')
    teamviewer_id=$(echo $teamviewer_id | awk '{print $NF}')
    printf "${FG_LCYAN} %30s %13s ${FG_DEFAULT} \n" "$connection" "$teamviewer_id"
  else
    printf "${FG_RED} %30s %13s ${FG_DEFAULT} \n" "$connection" "FAIL."
  fi
}

# //////////////////////////////////////////////////////////////////////////////
# @brief: script main entrypoint
# //////////////////////////////////////////////////////////////////////////////
title "Available Teamviewer Connections\n"

# push script path
__dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
pushd $__dir

# trap ctrl-c and call ctrl_c
trap ctrl_c INT

# check every connection in the user's ssh config
sshtraverse $GL_SSH_CONFIG display

# cleanup & exit
exit_pop_success
