#!/usr/bin/env bash

# load header helper functions
. "$SUBT_PATH/operations/scripts/header.sh"
. "$SUBT_PATH/operations/scripts/formatters.sh"

if chk_flag --help $@ || chk_flag help $@ ; then
  GL_TEXT_COLOR=$FG_LCYAN
  text
  title "Usage: $(basename $0) [flag] <arg> [flag] <arg> ..."
  text_color  "Flags:"
  text_color "      -t <arg> : Window title name"
  text_color "      -h <arg> : RDP remote host IP (or host alias found in local /etc/hosts)"
  text_color "      [-u <arg>] : RDP remote username"
  text_color "      [-p <arg>] :RDP remote user password"
  text_color "      [-r <arg>] : RDP desktop resolution"
  text_color "      -help : shows usage message."
  text_color "About: "
  text_color "Azure RPD Wrapper"
  text_color "    - Quick GoTo script, to establish a rdp session with an Azure VM."
  text_color "    - Hides rdp 'rdesktop' command line cli options & details."
  text_color "Example:"
  text_color "    -t azure-ugv1-window -h azure-ugv1 -u vm_username -p vm_password"
  text_color "For more help, please see the README.md or wiki."
  GL_TEXT_COLOR=$FG_DEFAULT
  exit_success
fi

# check for valid user inputs
if ! chk_flag -h $@ && ! chk_flag -t $@ ; then
  error "Missing host -h <arg> and window title -t <title> flags."
  exit_failure
fi

# globals params -- its okay these are exposed (relying on vpn ipsec for security ). These are the default username/password.
GL_USER="subt"
GL_PASS="Password1234!"
GL_RESOLUTION="1440x900!"

# display rdp connection settings
function display_settings() {
  GL_TEXT_COLOR=$FG_LCYAN
  text_color "RDP Settings:"
  text_color "    Window title is: $1"
  text_color "    Remote host is: $2"
  text_color "    Username is: $GL_USER"
  text_color "    Password is: $GL_PASS"
  text_color "    Resolution is: $GL_RESOLUTION"
  GL_TEXT_COLOR=$FG_DEFAULT
}

# //////////////////////////////////////////////////////////////////////////////
# @brief: script main entrypoint
# //////////////////////////////////////////////////////////////////////////////
title "Azure RDP Wrapper\n"

# push script path
__dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
pushd $__dir

# get the required arguments
title=$(get_arg -t $@)
host=$(get_arg -h $@)

# get the optional arguments
if chk_flag -u $@; then
  GL_USER=$(get_arg -u $@)
fi
if chk_flag -p $@; then
  GL_PASS=$(get_arg -p $@)
fi
if chk_flag -r $@; then
  GL_RESOLUTION=$(get_arg -r $@)
fi

# display & check connection
display_settings $title $host

# TODO: check connection

# create rdp connection
# -k : keyboard bindings
# -N : enable numlock syncronization
# -a : the colour depth for the connection: 16 bpp
# -z : enable compression of the RDP datastream.
# -r : enable clipboard redirection
rdesktop  -u $GL_USER -p $GL_PASS -g $GL_RESOLUTION -T $title \
          -k pt -N -a 16 -z -xl -r clipboard:CLIPBOARD \
          $host

# cleanup & exit
exit_pop_success
