#!/usr/bin/env bash
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/git_hooks/.header.bash"

# @brief display help usage message
__status_help() {
  GL_TEXT_COLOR=$FG_LCYAN
  text
  text_color "usage: status [<flag>] [<flag>] "
  text_color
  text_color "flags:"
  text_color "-b     : basestation intermediate level repo -> ~/deploy_ws/src/basestation"
  text_color "-c     : common intermediate level repo -> ~/deploy_ws/src/common"
  text_color "-p     : perception intermediate level repo -> ~/deploy_ws/src/perception"
  text_color "-s     : simulation intermediate level repo -> ~/deploy_ws/src/simulation"
  text_color "-ugv   : ugv intermediate level repo -> ~/deploy_ws/src/ugv"
  text_color "-uav   : uav intermediate level repo -> ~/deploy_ws/src/uav"
  text_color "help   : View help usage message for each sub command."
  text_color
  text_color "For more help, please see the README.md or wiki."
  GL_TEXT_COLOR=$FG_DEFAULT
}

# @brief displays the 'git status' of a submodule
_status() {
  # printf colors
  local _pfred=$(tput setaf 1)
  local _pfblue=$(tput setaf 4)
  local _pfnormal=$(tput sgr0)

  # collect git submodule status information
  local _submodule=$(realpath --relative-to="$SUBT_PATH" "$(pwd)")
  local _hash=$(git rev-parse --verify HEAD)
  local _branch=$(git rev-parse --abbrev-ref HEAD)
  local _url=$(git config --get remote.origin.url)
  local _dirty=$(_git_is_dirty)
  local _untrack=$(_git_nuntrack)
  local _uncommit=$(_git_nuncommit)
  local _status=""

  # determine the type of output display format for detached or non-detached head
  if [[ "$_branch" != "HEAD" ]]; then
    _branch="$_pfblue$_branch$_pfnormal"
  else
    _branch="$_pfnormal-$_pfnormal"
  fi

  # check if git submodule has any untracked files
  [[ "$_untrack" != "0" ]] && _status=" $_untrack _untrack"
  # check if git submodule status is dirty
  [[ "$_dirty" = "*" ]] && _status="$(git diff --shortstat), $_untrack _untrack"

  # display submodule information as a column table print style
  printf "%-50s | %-30s | %-75s | %-30s | %-30s \n"  \
    "$_submodule" \
    "$_branch" \
    "$_pfred$_status$_pfnormal" \
    "$_hash" \
    "$_url"
}

# @brief traverse over all submodules in the intermediate repos, apply the given function on _submodule
__traverse() {
  local _inter_repo=$1
  pushd "$SUBT_PATH/$_inter_repo"
  text "\n$FG_LCYAN|--$_inter_repo--|"
  # status intermedite repo only
  _status

  # git the _dirty of inter-repo, pass that as an array to info fun
  # - if name matches _submodule repo, then mark as _uncommit _submodule (or 'new commits')
  # tab complete the argument options...
  # TODO: not _submodule cloned...

  # status  all recursive submodule repos
  _traverse_submodules _status
  popd
}

# //////////////////////////////////////////////////////////////////////////////
# @brief: display submodule git status information
# - given a intermediate repo flag for submodule repo group selection
# - displays submodule status recursively
# - allow selection for multiple intermediate repo submodules
# //////////////////////////////////////////////////////////////////////////////
if chk_flag --help $@ || chk_flag help $@ || chk_flag -h $@; then
  __status_help
  exit
fi

# add --table param, to show as table
# add -v to show actual status info

_larger_text "== SubT Git Status =="

if chk_flag -b $@ || [ -z "$1" ]; then
  __traverse "basestation"
fi

if chk_flag -c $@ || [ -z "$1" ]; then
  __traverse "common"
fi

if chk_flag -p $@ || [ -z "$1" ]; then
  __traverse "perception"
fi

if chk_flag -s $@ || [ -z "$1" ]; then
  __traverse "simulation"
fi

if chk_flag -ugv $@ || [ -z "$1" ]; then
  __traverse "ugv"
fi

if chk_flag -uav $@ || [ -z "$1" ]; then
  __traverse "uav"
fi

exit_success
