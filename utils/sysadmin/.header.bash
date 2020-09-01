#!/usr/bin/env bash

# globals params
GL_SSH_CONFIG="$HOME/.ssh/config"

# silent push, pop
function pushd () {
  command pushd "$@" > /dev/null
}
function popd () {
  command popd "$@" > /dev/null
}

# exit on success
function exit_on_success() {
  popd
  exit_success
}

# exit on failure
function exit_on_error() {
  error $1
  popd
  exit_failure
}

# trap control-c
function ctrl_c() {
  exit_success
}

# get the current date as yyyy-mm-dd HH:MM
function get_current_date() {
  local date=$(date '+%YY-%mM-%dD-%HH-%MM')
  echo $date
}

# evaluate a given function for a ssh connections
function ssh_eval_func() {
  cfile=$1
  func=$2
  # case insensitive match
  shopt -s nocasematch
  matched=false
  for str in $(grep -i "^[^#\S]*Host\(name\)\?" $cfile | paste -s -); do
    # check for connection
    if [ "$matched" = true ]; then
        $func "$str"
      matched=false
    fi
    # ssh connection string is after the'Host' matched tag
    [ "$str" = "Host" ] && matched=true;
  done
}

# traverse all ssh configuration files
function sshtraverse() {
  cfile=$1
  func=$2
  text "$cfile \n"

  # base case, evaluate the function for this configuration
  ssh_eval_func $cfile $func

  # traverse all the included ssh configuration files
  matched=false
  for str in $(grep -i "^[^#\S]*Include\?" $cfile | paste -s -); do
    # traverse the include directory
    if [ "$matched" = true ]; then
      # get the ssh config file, directory path
      cdir="$(dirname $cfile)/$str"
      cdir=$(echo "$cdir" | sed 's/[*]\+//g')
      for next_cfile in $cdir/*; do
        newline
        sshtraverse $next_cfile $func
      done
      matched=false
    fi
    # included ssh configuration file is after 'Include' matched tag
    [ "$str" == "Include" ] && matched=true;
  done
}
