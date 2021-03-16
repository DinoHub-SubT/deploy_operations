#!/usr/bin/env bash

# source the subt environment variables
. ~/.subt/subtrc.sh

# include headers
. "$SUBT_PATH/operations/scripts/header.sh"
. "$SUBT_PATH/operations/scripts/formatters.sh"

if chk_flag --help $@ || chk_flag help $@ || chk_flag -h $@; then
  GL_TEXT_COLOR=$FG_LCYAN
  text
  title "Usage: $(basename $0) [ flag1 ] [ flag2 ] < container1 >  < container2 > ...  "
  text_color "Flags:"
  text_color "      -h      : shows usage message."
  text_color "      -st     : start the container"
  text_color "      -sp     : stop the container"
  text_color
  text_color "Boostrap script for tmux before_script calls. Used to start or stop containters."
  text_color "For more help, please see the README.md or wiki."
  GL_TEXT_COLOR=$FG_DEFAULT
  exit_success
fi

# //////////////////////////////////////////////////////////////////////////////
# @main entrypoint
# //////////////////////////////////////////////////////////////////////////////
# TODO: make nicer...i.e. without the arg index

# get index of start of arguments.
sidx=2
if chk_flag -sp $@ ; then
  if chk_flag -st $@ ; then
    sidx=$((sidx + 1))
  fi
fi

# stop the docker container
if chk_flag -sp $@ ; then
  for name in "${@:$sidx}"; do
    text "Stopping docker container: $name"
    docker stop "$name"
  done
fi

# start the docker container
if chk_flag -st $@ ; then
  for name in "${@:$sidx}"; do
    text "Starting docker container: $name"
    docker start "$name"
  done
fi

# cleanup & exit
exit_success
newline
