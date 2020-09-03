# globals

##
# Source: operations/deploy/azurebooks/scripts/header.sh
# Change text colors
# Thanks: https://misc.flogisoft.com/bash/tip_colors_and_formatting
##
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

GL_TEXT_COLOR=${FG_DEFAULT}

##
# Source: operations/deploy/azurebooks/scripts/header.sh
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
# Writes out colored text
function text() {
  echo -e "${FG_COLOR_TEXT}${@}${FG_DEFAULT}"
}

##
# Writes out a set colored message
#
function text_color() {
    echo -e "${GL_TEXT_COLOR}${@}${FG_DEFAULT}"
}

##
# Writes out a colored title
function larger_text() {
    echo -e "${FG_COLOR_TITLE}${@}${FG_DEFAULT}"
}

function chk_eq() {
  if [ "$1" = "$2" ]; then
    return 0
  fi
  return 1
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

# Returns "*" if the current git branch is dirty.
function is_git_dirty() {
  [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]] && echo "*"
}

function num_git_untracked() {
  expr `git status --porcelain 2>/dev/null| grep "^??" | wc -l`
}

function num_git_uncommited() {
  expr $(git status --porcelain 2>/dev/null| egrep "^(M| M)" | wc -l)
}

