#!/usr/bin/env bash
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/automate/.header.bash"
. "$SUBT_PATH/operations/bin/automate/.help.bash"
. "$SUBT_PATH/operations/deploy/azurebooks/scripts/header.sh"

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

# @brief push to remote origin, the intermediate repos.
__push_origin_intermediate_repos() {
  echo "TODO"
}

# //////////////////////////////////////////////////////////////////////////////
# @brief: main entrypoint
# //////////////////////////////////////////////////////////////////////////////

# first argument to the script is the repo directory path
_rdir=$1
shift

if chk_flag check-detached-head $@ ; then
  __detached_head
fi
