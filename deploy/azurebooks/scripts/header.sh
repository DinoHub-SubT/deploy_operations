##
# A header containing misc. variables and sources for the terraform scripts
# Joshua Spisak <joshs333@live.com> July 14, 2020
##
# Some directory variabls
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file_path="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__file_name="$(basename "${BASH_SOURCE[0]}")"

__call_dir="$(pwd)"

# Change text colors
# Thanks: https://misc.flogisoft.com/bash/tip_colors_and_formatting
FG_DEFAULT="\e[39m"
FG_BLACK="\e[30m"
FG_RED="\e[31m"
FG_GREEN="\e[32m"
FG_YELLOW="\e[33m"
FG_BLUE="\e[34m"
FG_MAGENTA="\e[35m"
FG_CYAN="\e[36m"
FG_LGRAY="\e[37m"
FG_DGRAY="\e[90m"
FG_LRED="\e[91m"
FG_LGREEN="\e[92m"
FG_LYELLOW="\e[93m"
FG_LBLUE="\e[94m"
FG_LMAGENTA="\e[95m"
FG_LCYAN="\e[96m"
FG_LWHITE="\e[97m"

FG_COLOR_TITLE="${FG_BLUE}"
FG_COLOR_TEXT="${FG_DEFAULT}"
FG_COLOR_DEBUG="${FG_LGRAY}"
FG_COLOR_ERROR="${FG_RED}"
FG_COLOR_WARNING="${FG_YELLOW}"

DISABLE_TITLE=0
DISABLE_TEXT=0
DISABLE_DEBUG=0
DISABLE_ERROR=0
DISABLE_WARNING=0

# global text color
GL_TEXT_COLOR=${FG_DEFAULT}

##
# Checks arguments to make sure they exist and are equal
# $1: value the arg should be
# $2: value to check against (can be empty)
# Returns 0 if $1 == $2, otherwise 1 if != or 2 if -z $2
#
# Usage: "if chk_arg yes $1; then ..."
function chk_arg() {
    value=$1
    check=$2

    if [[ -z $check ]]; then
        return 2
    fi
    if [[ $value == $check ]]; then
        return 0
    else
        return 1
    fi
}

##
# Checks arguments to make sure they exist and are equal
# $1: flag to check for arguments to contain
# $>1: arguments to check against
# Returns 0 if $1 matches anything $>1, returns 1 if no matches, 2 if $1 is empty
#
# Usage: "if chk_flag -y $@; then ..."
function chk_flag() {
    value=$1

    if [[ -z $value ]]; then
        return 2
    fi
    for var in "${@:2}"; do
        if [[ $value == $var ]]; then
            return 0
        fi
    done
    return 1
}

##
# Writes out a colored title
function title() {
    if [[ $DISABLE_TITLE == 1 ]]; then
        return
    fi
    echo -e "${FG_COLOR_TITLE}${@}${FG_DEFAULT}"
}

##
# Writes out colored text
function text() {
    if [[ $DISABLE_TEXT == 1 ]]; then
        return
    fi
    echo -e "${FG_COLOR_TEXT}${@}${FG_DEFAULT}"
}

##
# Writes out colored debug messages
function debug() {
    if [[ $DISABLE_DEBUG == 1 ]]; then
        return
    fi
    echo -e "${FG_COLOR_DEBUG}${@}${FG_DEFAULT}"
}

##
# Writes out colored error messages
function error() {
    if [[ $DISABLE_ERROR == 1 ]]; then
        return
    fi
    echo -e "${FG_COLOR_ERROR}${@}${FG_DEFAULT}"
}

##
# Writes out colored warning messages
function warning() {
  if [[ $DISABLE_WARNING == 1 ]]; then
    return
  fi
  echo -e "${FG_COLOR_WARNING}${@}${FG_DEFAULT}"
}

# A function that returns the argument provided
function return_num() {
    if [[ -z $1 ]]; then
        return 0
    fi
    return $1
}

# Usage: if last_command_failed; then ...
function last_command_failed() {
    [[ $? == 0 ]] || return 0
    return 1
}

# Usage: if last_command_succeeded; then ...
function last_command_succeeded() {
    [[ $? == 0 ]] && return 0
    return 1
}

##
# Decodes a url
# urldecode <string>
# Thanks: https://gist.github.com/cdown/1163649
urldecode() {
    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}

##
# Creates a newline
#
function newline() {
    echo -e "\n";
}

##
# Exit with success code
#
function exit_success() {
    newline;
    exit 0;
}

##
# Exit with failure code
#
function exit_failure() {
    newline;
    exit 1;
}

##
# Writes out a set colored message
#
function text_color() {
    echo -e "${GL_TEXT_COLOR}${@}${FG_DEFAULT}"
}

##
# Saves the given directory at the top of the directory stack, then cd to directory
# - stack standard output silenced
#
function pushd () {
    command pushd "$@" > /dev/null;
}

##
# Removes the top directory from the stack, then cd to directory
# - stack standard output silenced
#
function popd () {
    command popd "$@" > /dev/null;
}

##
# Checks if given value is found in array
#   - reference: https://stackoverflow.com/a/8574392/3554704
#
function val_in_arr() {
  local iter value="$1"
  # shift the first argument, to only have the list-values as the arguments
  shift
  # for without in, iterates over the given arguements
  for iter; do [[ "$iter" == "$value" ]] && return 0; done
  return 1
}

##
# Check if given value is set
#
function is_empty() {
    local value=$1
    # non-empty value
    [[ -n "$value" ]] && return 1
    # empty value
    return 0
}

##
# Check if file exists
#
function file_exists() {
    local filename=$1
    [[ -f $filename ]] && return 0
    return 1
}

##
# Find the index of a value in an array
##
function arr_idx() {
    # defined iteration variables
    local count=0 iter value="$1"
    shift
    # for without in, iterates over the given arguements
    for iter; do
      ((count++))
      [[ "$iter" == "$value" ]] && echo $count && return 0;
    done
    echo -1
}

##
# trap control-c
##
function ctrl_c() {
  exit_success
}

function source_terra_env() {
    # source the terraform env
    if [ ! -e ~/.terraform_id.bashrc ]; then
        echo "WARNING: [~/.terraform_id.bashrc] does not exist..., this command might not work..."
    else
        source ~/.terraform_id.bashrc
    fi

    if [ ! -e ~/.terraform_flags.bashrc ]; then
        echo "WARNING: [~/.terraform_flags.bashrc] does not exist..., this command might not work..."
    else
        source ~/.terraform_flags.bashrc
    fi
}