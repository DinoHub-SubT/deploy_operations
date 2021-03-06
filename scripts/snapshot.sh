#!/usr/bin/env bash

# load header helper functions
. "$SUBT_PATH/operations/scripts/header.sh"
. "$SUBT_PATH/operations/scripts/formatters.sh"

# checks if branch has something pending
function parse_git_dirty() {
  git diff --quiet --ignore-submodules HEAD 2>/dev/null; [ $? -eq 1 ] && echo "*"
}

# gets the current git branch
function parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

# get last commit hash prepended with @ (i.e. @8a323d0)
function parse_git_hash() {
  git rev-parse --short HEAD 2> /dev/null | sed "s/\(.*\)/@\1/"
}


if chk_flag --help $@ || chk_flag help $@ || chk_flag -h $@; then
  GL_TEXT_COLOR=$FG_LCYAN
  text
  title "Usage: $(basename $0) [flag] "
  text_color  "Flags:"
  text_color "      -help : shows usage message."
  text_color "      -c : Removes all snapshot logfiles in operations/field_testing/*.log"
  text_color "About: "
  text_color "Deploy Snapshot Log"
  text_color "Create a snapshot log of all deploy repo's submodules."
  text_color "  - logfile as operations/field_testing/snapshot-[current date].log"
  text_color "  - logfile contents of format: [submodule commit hash] [submodule deploy relative path]"
  text_color "For more help, please see the README.md or wiki."
  GL_TEXT_COLOR=$FG_DEFAULT
  exit_success
fi

# globals params
GL_SNAPSHOT_DIR="operations/field_testing/"

# @brief get all the submodules in the current directory
function get_all_submodules() {
  echo $(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')
}

# @brief traverse through all the submodules in the given source directory
function traverse_submodules() {
  # find all the submodules in the current path level
  local _sub=$(get_all_submodules)
  local _funptr=$1

  # recursive traverse for found submodules
  for _sub in $_sub; do
    # if exists, traverse submodule for any nested submodules & execute _funptr
    if [ -d "$_sub" ]; then
      pushd $_sub  # cd to the submodule directory
      ($_funptr)      # execute function
      traverse_submodules $2 # recursively traverse the submodules, for any nested submodules
      popd  # return to the previous current directory (before recursive traversal)
    fi
  done
}

# traverse through all the submodules in the given source directory
function traverse() {
  # find all the submodules in the current path level
  local submodules=$(get_all_submodules $1)
  local logfile=$2

  # recursive traverse for found submodules
  for submodule in $submodules
  do
    # print warning & ignore if directory does not exist
    if [ ! -d "$submodule" ]; then
      warning "Submodule $submodule does not exist.
      - Ignoring submodule in snapshot log.
      - Submodule is either not cloned or .gitmodules is incorrect.
      - Correct (if necessary) .gitmodules at '$(pwd)'\n"
    else
      # get submodule git information
      pushd $submodule
      local snapshot_submodule=$(realpath --relative-to="$SUBT_PATH" "$(pwd)")
      local snapshot_commit_hash=$(git rev-parse --verify HEAD)
      # recursive traverse, for any nested submodules
      traverse "$(pwd)" "$logfile"
      popd
      # write the `(commit hash) (submodule path)` to logfile
      echo "$snapshot_commit_hash $snapshot_submodule" >> $logfile
    fi
  done
}

# create snapshot log file
function snapshot() {
  # create log file
  local logfile="$SUBT_PATH/$GL_SNAPSHOT_DIR/snapshot-$(get_current_date).log"
  touch "${logfile}.tmp"
  text "Creating logfile: ${logfile}"

  # traverse submodules
  pushd $SUBT_PATH
  traverse "$SUBT_PATH" "${logfile}.tmp"

  # sort the snapshot logfile and remove the tmp logfile
  sort -k 2 "${logfile}.tmp" >> ${logfile}
  rm "${logfile}.tmp"
  popd
}

# clean all snapshot log files
function clean() {
  if [ "$(find $SUBT_PATH/$GL_SNAPSHOT_DIR/ -prune -empty  2>/dev/null)" ]; then
    text "Nothing to clean."
  else
    text "Clean logfiles in: $SUBT_PATH/$GL_SNAPSHOT_DIR/"
    rm $SUBT_PATH/$GL_SNAPSHOT_DIR/*
  fi
}

# //////////////////////////////////////////////////////////////////////////////
# @brief: script main entrypoint
# //////////////////////////////////////////////////////////////////////////////
title "Deploy Snapshot Log\n"

# push script path
__dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
pushd $__dir

# create snapshot log or clean all snapshot logs
if chk_flag -c $@; then
  clean
else
  snapshot
fi

# cleanup & exit
exit_pop_success
