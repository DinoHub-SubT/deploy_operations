#!/usr/bin/env bash
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/hooks/.header.bash"

# @brief display help usage message
__sync_help() {
  GL_TEXT_COLOR=$FG_LCYAN
  text
  text_color "usage: sync [<flag>] [<flag>] "
  text_color
  text_color "flags:"
  text_color "-b     : basestation intermediate level repo -> ~/deploy_ws/src/basestation"
  text_color "-c     : common intermediate level repo -> ~/deploy_ws/src/common"
  text_color "-p     : perception intermediate level repo -> ~/deploy_ws/src/perception"
  text_color "-s     : simulation intermediate level repo -> ~/deploy_ws/src/simulation"
  text_color "-ugv   : ugv intermediate level repo -> ~/deploy_ws/src/ugv"
  text_color "-uav   : uav intermediate level repo -> ~/deploy_ws/src/uav"
  text_color "-del   : delete any local branches not found on the origin remote."
  text_color "-hard  : sync the currently checkout branch."
  text_color "help   : View help usage message for each sub command."
  text_color
  text_color "For more help, please see the README.md or wiki."
  GL_TEXT_COLOR=$FG_DEFAULT
}

# globals
_GL_DELETE_BRANCH=false
_GL_IGNORE_CURR=true

# @brief syncs local repository to match remote
# - resets hard all local branches to match remote branches
# - removes all deleted branches
__sync_reset_hard() {

  # collect the local & remote branches
  local _heads=($(_git_branches heads))
  local _remotes=($(_git_branches remotes))

  # get the current checked out branch
  local _co=$(git symbolic-ref -q HEAD)
  # ignore current branch (if given as user argument)
  $_GL_IGNORE_CURR && _heads=( "${_heads[@]/$_co}" )

  # find the short branch name
  _co=${_co#"refs/heads/"}
  # echo "what is this? ${_heads[@]} "
  # go through all local branches and reset hard local branch to origin/remote
  for branch in "${_heads[@]}"; do
    branch=$( echo "$branch" | tr -d "\'")  # remove the single quotes from the branch string
    short=${branch#"refs/heads/"}           # find the short branch name

    # match the local & remote branches
    if val_in_arr "'refs/remotes/origin/$short'" "${_remotes[@]}"; then
      # reset the local branch to the remote
      # git checkout -q -f $short
      # git reset -q "origin/$short"
      git update-ref "$branch" "refs/remotes/origin/$short"
    else
      [ $_GL_DELETE_BRANCH = true ] && git branch -d $short
    fi
  done

  # go back to original commit hash
  if ! $_GL_IGNORE_CURR; then
    [ -z $_co ] && _co=$(git rev-parse --verify HEAD)  # co as hash commit, if co as detached head
    git checkout -q -f $_co
  fi

}

# @brief displays the 'git status' of a submodule
_sync() {
  # printf colors
  local _pfred=$(tput setaf 1)
  local _pfblue=$(tput setaf 4)
  local _pfnormal=$(tput sgr0)

  # collect git submodule status information
  local _submodule=$(realpath --relative-to="$SUBT_PATH" "$(pwd)")
  local _hash=$(git rev-parse --verify HEAD)  # get the current hash commit
  local _co=$(git symbolic-ref -q HEAD)       # get the current branch
  _co=${_co#"refs/heads/"}           # find the short branch name
  [ -z $_co ] && _co="-"                      # reset to detached head display symbol '-'

  # git fetch

  printf "%-10s | %-30s | %-50s | %-50s \n" "...sync" "$_co" "$_hash" "$_submodule"
  git fetch -q -a
  __sync_reset_hard
}

# @brief traverse over all submodules in the intermediate repos, apply the given function on _submodule
__traverse() {
  local _inrepo=$1
  pushd "$SUBT_PATH/$_inrepo"
  text "\n$FG_LCYAN|--$_inrepo--|$FG_DEFAULT"
  _sync                       # sync intermedite repo only
  _traverse_submodules _sync  # sync all recursive submodule repos
  # text "$FG_LCYAN...git status $FG_DEFAULT"
  printf "%-10s \n" "...git status"
  git status                  # perform a git status, to speed up top level deploy indexing
  popd
}

# //////////////////////////////////////////////////////////////////////////////
# @brief: display submodule git syncrmation
# - given a intermediate repo flag for submodule repo group selection
# - displays submodule sync recursively
# - allow selection for multiple intermediate repo submodules
# //////////////////////////////////////////////////////////////////////////////
if chk_flag --help $@ || chk_flag help $@ || chk_flag -h $@; then
  __sync_help
  exit
fi

_larger_text "== SubT git sync =="

if chk_flag -del $@; then
  _GL_DELETE_BRANCH=true
fi

if chk_flag -hard $@; then
  _GL_IGNORE_CURR=false
fi

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

if chk_flag -d $@ || [ -z "$1" ]; then
  # sync every branch except the current branch....
  text "\n$FG_LCYAN|--deploy--|$FG_DEFAULT"
  _sync # sync top level deploy repo only
fi

# TODO: sync the top level branch...
#       - have it remove all intermediate level branches too...

exit_success
