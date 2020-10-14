# globals

# @source: operations/deploy/azurebooks/scripts/header.sh
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

GL_TEXT_COLOR=${FG_DEFAULT}

# globals
GL_BIN_AUTOMATE_DIR=$SUBT_PATH/operations/bin/automate/
GL_CMPL_DIR=$SUBT_PATH/operations/bin/automate/cmpl

# @source: operations/deploy/azurebooks/scripts/header.sh
# @brief Checks arguments to make sure they exist and are equal
# @params $1  flag to check for arguments to contain
# @params $>1 arguments to check against
# @return 0 if $1 matches anything $>1, returns 1 if no matches, 2 if $1 is empty
#
# @usage: "if chk_flag -y $@; then ..."
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

# @brief Writes out colored text
function text() {
  echo -e "${FG_COLOR_TEXT}${@}${FG_DEFAULT}"
}

# @brief Writes out a set colored message
function text_color() {
    echo -e "${GL_TEXT_COLOR}${@}${FG_DEFAULT}"
}

# @brief Writes out a colored title
_larger_text() {
    echo -e "${FG_COLOR_TITLE}${@}${FG_DEFAULT}"
}

# @brief check for equality: two values are equal as strings
_chk_eq() {
  if [ "$1" = "$2" ]; then
    return 0
  fi
  return 1
}

# @brief get all the submodules in the current directory
__get_all_submodules() {
  echo $(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')
}

# @brief traverse through all the submodules in the given source directory
_traverse_submodules() {
  # find all the submodules in the current path level
  local _sub=$(__get_all_submodules)
  local _funptr=$1

  # recursive traverse for found submodules
  for _sub in $_sub; do
    # if exists, traverse submodule for any nested submodules & execute _funptr
    if [ -d "$_sub" ]; then
      pushd $_sub  # cd to the submodule directory
      ($_funptr)      # execute function
      _traverse_submodules $2 # recursively traverse the submodules, for any nested submodules
      popd  # return to the previous current directory (before recursive traversal)
    fi
  done
}

# @brief returns "*" if the current git branch is dirty.
_git_is_dirty() {
  [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]] && echo "*"
}

# @brief returns number of untracked files
_git_nuntrack() {
  expr `git status --porcelain 2>/dev/null| grep "^??" | wc -l`
}

# @brief returns number of uncommitted files
_git_nuncommit() {
  expr $(git status --porcelain 2>/dev/null| egrep "^(M| M)" | wc -l)
}

_git_branches(){
  echo "$(git for-each-ref --shell --format="%(refname)" refs/$1/)"
}

chk_eq() {
  [ "$1" = "$2" ] && return 0 || return 1
}