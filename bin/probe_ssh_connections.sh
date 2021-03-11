#!/usr/bin/env bash

# load header helper functions
. "$SUBT_PATH/operations/deploy/azurebooks/scripts/header.sh"
. "$(dirname $0)/.header.bash"

if chk_flag --help $@ || chk_flag help $@ || chk_flag -h $@; then
  GL_TEXT_COLOR=$FG_LCYAN
  text
  title "Usage: $(basename $0) [flag] "
  text_color  "Flags:"
  text_color "      -help : shows usage message."
  text_color "Shows which configured ssh connections are are available to connect."
  text_color "For more help, please see the README.md or wiki."
  GL_TEXT_COLOR=$FG_DEFAULT
  exit_success
fi

# globals params
_GL_ssh_config="$HOME/.ssh/config"
_GL_pwd="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

##
# Display open ssh conections
##
display() {
  local connection=$1
  if ssh -q -o BatchMode=yes -o ConnectTimeout=1 $connection exit 2>/dev/null; then
    printf "${FG_LCYAN} %30s %13s ${FG_DEFAULT} \n" "$connection" "OK."
  else
    printf "${FG_RED} %30s %13s ${FG_DEFAULT} \n" "$connection" "FAIL."
  fi
}

##
# Evaluate a given function for a ssh connections
##
evaluate() {
  local cfile=$1 func=$2

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
# Traverse all ssh configuration files
##
traverse_ssh_cfgs() {
  local cfile=$1 func=$2

  # exit early if cfg file does not exist
  if ! file_exists $cfile; then
    echo "ssh configuration file '$cfile' does not exist."
    return 0;
  fi
  text "...config: $cfile \n"

  # base case, evaluate the function for this configuration
  evaluate $cfile $func

  # traverse all the included ssh configuration files
  local matched=false
  for read_cfg in $(grep -i "^[^#\S]*Include\?" $cfile | paste -s -); do

    # found the include value, traverse the configuration
    if [ "$matched" = true ]; then

      # include configuration is a directory, traverse all files in cfg dir.
      if [[ -d $read_cfg ]]; then
        # get the ssh config file, directory path
        cdir="$(dirname $cfile)/$read_cfg"
        cdir=$(echo "$cdir" | sed 's/[*]\+//g')
        for next_cfile in $cdir/*; do
          newline
          traverse_ssh_cfgs $next_cfile $func
        done

      # include configuration is a file, traverse the given cfg file
      else
        read_cfg=$(eval "echo $read_cfg")
        newline
        traverse_ssh_cfgs $read_cfg $func
      fi

      matched=false
    fi
    # included ssh configuration file is after 'Include' matched tag
    [ "$read_cfg" == "Include" ] && matched=true;
  done
}

# //////////////////////////////////////////////////////////////////////////////
# @brief: script main entrypoint
# //////////////////////////////////////////////////////////////////////////////
main Probe Available SSH Connections

# push script path
pushd $HOME/.ssh/

# check every connection in the user's ssh config
traverse_ssh_cfgs $_GL_ssh_config display

# cleanup & exit
exit_on_success
