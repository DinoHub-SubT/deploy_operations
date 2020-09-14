#!/usr/bin/env bash
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/automate/.header.bash"
. "$SUBT_PATH/operations/bin/automate/.help.bash"
. "$SUBT_PATH/operations/deploy/azurebooks/scripts/header.sh"

# globals
_GL_INTER=("basestation" "common" "perception" "ugv" "uav" "simulation" "subt_launch")

# @brief checks if currently on any branch
__detached_head() {
  local _regex=".*\*.*HEAD detached"
  local _br="$(git symbolic-ref HEAD 2>/dev/null)"
  local _repo=$(realpath --relative-to="$SUBT_PATH" "$(pwd)")

  if [[ -z $branch_name ]]; then
    newline
    warning "Your repo '$_repo' is checked out as DETACHED HEAD:"
    git status
    newline

    echo -n -e "${FG_COLOR_WARNING}Do you want to FORCE the commit? [y/n] ${FG_DEFAULT}"
    read -n1 -p "" yn < /dev/tty
    if [ $yn = "y" ] || [ $yn = "Y" ] || [ $yn = "yes" ] || [ $yn = "YES" ] ; then
      text "\n...ok, allowing commit."
      exit_success
    else
      text "\n...ok, blocking commit."
      exit_failure
    fi
  fi
}

# @brief add commits to all the intermediate repos
__intermediate_commit() {
  echo "we are here??"

  # get the list of intermediate repos
  local _changes=$(git diff --cached --name-status)
  for _change in $_changes; do
    echo "the change is: $_change"
  done

  pushd $SUBT_PATH
  for _repo in ${_GL_INTER[@]}; do
    echo "intermediate repo is: $_repo"
  done
  popd
}

# //////////////////////////////////////////////////////////////////////////////
# @brief: main entrypoint
# //////////////////////////////////////////////////////////////////////////////

# first argument to the script is the repo directory path
_rdir=$1
shift

if chk_flag check-detached-head $@ ; then
  __detached_head
elif chk_flag intermediate-commit $@ ; then
  __intermediate_commit
  exit 1
fi
