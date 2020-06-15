#!/usr/bin/env bash

# //////////////////////////////////////////////////////////////////////////////
# print nicely

# colors
DEFCOL="\e[39m"
GREEN="\e[32m"
BLUE="\e[34m"
RED="\e[31m"
YELLOW="\e[33m"
CYAN="\e[36m"

# formatters
_(){ sed "s/^/\t/" <($*); }
line() { printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -; }
divider() { echo -e "$GREEN" `line` "$DEFCOL\n"; }
divider_large() { printf "=======================================================================================================\n"; }

script_title() {
  printf "${CYAN}"
  echo -e "\n\n//////////////////////////////////////////////////////////////////////////////"
  echo -e "\t\t\t == $1 ==  ";
  echo -e "//////////////////////////////////////////////////////////////////////////////\n\n"
  printf "${DEFCOL}"
}
title() { echo -e "\t\t\t\t\t $GREEN == $1 == $DEFCOL \n\n"; }
text() { echo -e "$CYAN $1 $GREEN $2 $DEFCOL"; }
display_text() { echo -e "$GREEN $1 $DEFCOL\n"; }
minor_text() { echo -e "$GREEN $1 $GREEN $2 $DEFCOL"; }
warning() { echo -e "$YELLOW$1 $DEFCOL\n"; }
print_error() { echo -e "$RED$1 $DEFCOL\n"; }
exit_success() { exit 0; }
exit_failure() { exit 1; }
newline() { echo -e "\n"; }
validate() { if [ $? -ne 0 ]; then print_error "$1"; exit_failure; fi; }

# //////////////////////////////////////////////////////////////////////////////
# validate file exists or error exit
validate_file_exists() {
  if [ ! -f $1 ]; then print_error "Error: File '$1' not found!"; display_usage "$usage_msg"; exit_failure; fi; }

# silent push, pop
pushd () {
  command pushd "$@" > /dev/null
}
popd () {
  command popd "$@" > /dev/null
}
# misc.
display_usage() { echo -e "$YELLOW$1$DEFCOL\n"; }
is_display_usage() {
  # if [ $help ]; then
  if [ "$help" = true ] ; then
    display_usage "$1"
    exit_failure
  fi
}
# check if an argument is set
verify_arg() {
  # variable is not set
  [[ -z "${1+x}" ]] && { display_usage "$usage_msg"; print_error "$2"; exit_failure; }
  # variable is empty
  [[ -z "${1}" ]] && { display_usage "$usage_msg"; print_error "$2"; exit_failure; }
}

