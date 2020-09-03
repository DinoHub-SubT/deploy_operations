#!/usr/bin/env bash

# globals params
GL_SSH_CONFIG="$HOME/.ssh/config"

##
# silent push, pop
##
function pushd () {
  command pushd "$@" > /dev/null
}
function popd () {
  command popd "$@" > /dev/null
}

##
# exit on success
##
function exit_on_success() {
  popd
  exit_success
}

##
# exit on failure
##
function exit_on_error() {
  error $1
  popd
  exit_failure
}

##
# trap control-c
##
function ctrl_c() {
  exit_success
}

##
# get the current date as yyyy-mm-dd HH:MM
##
function get_current_date() {
  local date=$(date '+%YY-%mM-%dD-%HH-%MM')
  echo $date
}

##
# evaluate a given function for a ssh connections
##
function ssh_eval_func() {
  local cfile=$1
  local func=$2
  # case insensitive match
  shopt -s nocasematch
  local matched=false
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

##
# traverse all ssh configuration files
##
function sshtraverse() {
  local cfile=$1
  local func=$2
  text "$cfile \n"

  # base case, evaluate the function for this configuration
  ssh_eval_func $cfile $func

  # traverse all the included ssh configuration files
  local matched=false
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

##
# Checks that the nth positional argument is the given value
# $1: nth position of argument
# $2: value argument to check as
# $>2: given arguments to check against
# Returns 0 if check is valid, otherwise some error exit code
##
function check_nth_flag() {
  n=$1 value=$2
  shift 2
  check=${@:$n:1}
  # check if check input exists
  if [[ -z $value ]]; then
    return 5  # input/output error
  fi
  if [[ $value == $check ]]; then
    return 0
  else
    return 1
  fi
}

##
# Get all the submodules in the current directory
##
function get_all_submodules() {
  local result=$(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')
  echo $result
}

function hello() {
  echo "hello workd?"
}

# traverse through all the submodules in the given source directory
function traverse_submodules() {
  # find all the submodules in the current path level
  local submodules=$(get_all_submodules)
  local funcptr=$1

  # recursive traverse for found submodules
  for submodule in $submodules; do
    # print warning & ignore if directory does not exist
    if [ -d "$submodule" ]; then
      # get submodule git information
      pushd $submodule

      # execute function
      ($funcptr)

      # recursive traverse, for any nested submodules
      traverse_submodules $2
      popd

    fi
  done
}


