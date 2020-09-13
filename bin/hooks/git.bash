#!/usr/bin/env bash
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/hooks/.header.bash"
. "$SUBT_PATH/operations/bin/hooks/.help.bash"

if chk_flag --help $@ || chk_flag help $@ || chk_flag -h $@; then
  GL_TEXT_COLOR=$FG_LCYAN
  text
  text_color "Usage: <subcommand> [flag] [flag] ... "
  text
  text_color "Subcommand:"
  text_color "      status : shows the git status for all submodules."
  text_color "      clone : clone."
  text_color "      reset : Removes all snapshot logfiles in operations/field_testing/*.log"

  # show flags for specific subcommand
  if chk_flag status $@; then
    __status_help
  elif chk_flag sync $@; then
    __sync_help
  elif chk_flag clone $@; then
    __clone_help
  elif chk_flag reset $@; then
    __reset_help
  elif chk_flag clean $@; then
    __clean_help
  elif chk_flag rm $@; then
    __rm_help
  fi

  text_color "For more help, please see the README.md or wiki."
  GL_TEXT_COLOR=$FG_DEFAULT

  exit_success
fi

# globals
GL_STATUS_HASH=false
GL_STATUS_URL=false
GL_SYNC_DELETE_BRANCH=false
GL_SYNC_IGNORE_CURR=true

# //////////////////////////////////////////////////////////////////////////////
# @brief git status
# //////////////////////////////////////////////////////////////////////////////

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
  [[ "$_branch" != "HEAD" ]] && _branch="$_pfblue$_branch$_pfnormal" || _branch="$_pfnormal-$_pfnormal"

  # check if git submodule has any untracked files
  [[ "$_untrack" != "0" ]] && _status=" $_untrack _untrack"
  # check if git submodule status is dirty
  [[ "$_dirty" = "*" ]] && _status="$(git diff --shortstat), $_untrack untrack"

  # display submodule information as a column table print style
  printf "%-50s | %-50s | %-75s " "$_submodule" "$_branch" "$_pfred$_status$_pfnormal"
  [[ $GL_STATUS_HASH == true ]] && printf " | %-30s" "$_hash"
  [[ $GL_STATUS_URL == true ]]  && printf " | %-30s" "$_url"
  printf "\n"
}

# @brief traverse through all the submodules in the given intermediate repo(s)
_status_traverse() {
  # go through all given intermediate repo arguments
  for _inter in "$@"; do
    # ignore the non-interrepo flags
    chk_flag -hash $_inter || chk_flag -url $_inter && continue

    # display submodule information as a column table print style
    text "\n$FG_LCYAN|--$_inter--|"
    printf "%-50s | %-38s | %-64s " "--submodule--" "--branch--" "--status--"
    [[ $GL_STATUS_HASH == true ]] && printf " | %-40s" "--git hash--"
    [[ $GL_STATUS_URL == true ]]  && printf " | %-30s" "--git url--"
    printf "\n"

    # traverse over the intermeidate submodules & show status
    pushd $_inter
    _status # status intermediate repo level

    # git the _dirty of inter-repo, pass that as an array to info fun
    # - if name matches _submodule repo, then mark as _uncommit _submodule (or 'new commits')
    # tab complete the argument options...
    # TODO: not _submodule cloned...

    # status  all recursive submodule repos
    _traverse_submodules _status
    popd
  done
}

# //////////////////////////////////////////////////////////////////////////////
# @brief git sync
# //////////////////////////////////////////////////////////////////////////////

# @brief syncs local repository to match remote
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

  printf "%-10s | %-30s | %-50s | %-50s \n" "...sync" "$_co" "$_hash" "$_submodule"
  git fetch -q -a

  # - resets hard all local branches to match remote branches
  # - removes all deleted branches

  # collect the local & remote branches
  local _heads=($(_git_branches heads))
  local _remotes=($(_git_branches remotes))

  # get the current checked out branch
  local _co=$(git symbolic-ref -q HEAD)
  # ignore current branch (if given as user argument)
  $GL_SYNC_IGNORE_CURR && _heads=( "${_heads[@]/$_co}" )

  # find the short branch name
  _co=${_co#"refs/heads/"}
  # go through all local branches and reset hard local branch to origin/remote
  for branch in "${_heads[@]}"; do
    branch=$( echo "$branch" | tr -d "\'")  # remove the single quotes from the branch string
    short=${branch#"refs/heads/"}           # find the short branch name

    # match the local & remote branches
    if val_in_arr "'refs/remotes/origin/$short'" "${_remotes[@]}"; then
      # reset the local branch to the remote
      git update-ref "$branch" "refs/remotes/origin/$short"
    else
      [ $GL_SYNC_DELETE_BRANCH = true ] && git branch -d $short
    fi
  done

  # go back to original commit hash
  if ! $GL_SYNC_IGNORE_CURR; then
    [ -z $_co ] && _co=$(git rev-parse --verify HEAD)  # co as hash commit, if co as detached head
    git checkout -q -f $_co
  fi
}

# @brief traverse over all submodules in the intermediate repos, apply the given function on _submodule
_sync_traverse() {
  # go through all given intermediate repo arguments
  for _inter in "$@"; do
    # ignore the non-interrepo flags
    chk_flag -hard $_inter || chk_flag -del $_inter && continue

    # display submodule information as a column table print style
    text "\n$FG_LCYAN|--$_inter--|$FG_DEFAULT"
    printf "%-10s | %-30s | %-50s | %-64s " "" "--branch--" "--status--" "--submodule--"
    printf "\n"

    # traverse over the intermeidate submodules & sync
    pushd "$_inter"
    _sync                       # sync intermedite repo only
    _traverse_submodules _sync  # sync all recursive submodule repos

    # display the intermediate repo git status
    printf "%-10s \n" "...git status"
    git status                  # perform a git status, to speed up top level deploy indexing
    popd
  done
}

# //////////////////////////////////////////////////////////////////////////////
# @brief git subcommands using deployer
# //////////////////////////////////////////////////////////////////////////////

# @brief cleans all the submodules & intermediate repos
_clean_traverse() {
  for _inter in "$@"; do
    ./deployer -s git.clean.$_inter
  done
}

# @brief reset all the submodules to their DETACHED HEAD -- using deployer yamls (please see yamls for more info)
_reset_traverse() {
  # go through all given intermediate repo arguments
  for _inter in "$@"; do
    ./deployer -s git.rm.$_inter
    ./deployer -s git.init.$_inter
    ./deployer -s git.clone.$_inter
  done
}

# @brief removes all git submodules in the intermediate repo
_rm_traverse() {
  for _inter in "$@"; do
    ./deployer -s git.rm.$_inter
  done
}

# @brief clones all git submodules in the intermediate repo
_clone_traverse() {
  for _inter in "$@"; do
    ./deployer -s git.clone.$_inter
  done
}

# //////////////////////////////////////////////////////////////////////////////
# @brief: main entrypoint
# //////////////////////////////////////////////////////////////////////////////
pushd $SUBT_PATH

if chk_flag status $@ ; then
  shift
  _nargs=$#

  # append the display options
  chk_flag -hash $@ && GL_STATUS_HASH=true
  chk_flag -url $@ && GL_STATUS_URL=true

  # top level deploy repo
  # display submodule information as a column table print style
  text "\n$FG_LCYAN|--deploy--|"
  printf "%-50s | %-38s | %-64s " "--submodule--" "--branch--" "--status--"
  [[ $GL_STATUS_HASH == true ]] && printf " | %-40s" "--git hash--" && ((_nargs--))
  [[ $GL_STATUS_URL == true ]]  && printf " | %-30s" "--git url--"  && ((_nargs--))
  printf "\n"
  _status # show the status

  # show git status for all the given intermediate level repos
  [ $_nargs -eq 0 ] && _status_traverse basestation common perception ugv uav simulation subt_launch || _status_traverse $@

elif chk_flag sync $@ ; then
  shift
  _nargs=$#

  # append the display options
  chk_flag -del $@ && GL_SYNC_DELETE_BRANCH=true && ((_nargs--))
  chk_flag -hard $@ && GL_SYNC_IGNORE_CURR=false && ((_nargs--))

  # show git status for all the given intermediate level repos
  [ $_nargs -eq 0 ] && _sync_traverse basestation common perception ugv uav simulation subt_launch || _sync_traverse $@

elif chk_flag clone $@ ; then
  shift
  _nargs=$#
  # reset the submodules for all the given intermediate level repos
  [ $_nargs -eq 0 ] && _clone_traverse basestation common perception ugv uav simulation subt_launch || _clone_traverse $@

elif chk_flag reset $@ ; then
  shift
  _nargs=$#
  # reset the submodules for all the given intermediate level repos
  [ $_nargs -eq 0 ] && _reset_traverse basestation common perception ugv uav simulation subt_launch || _reset_traverse $@

elif chk_flag clean $@ ; then
  shift
  _nargs=$#
  # reset the submodules for all the given intermediate level repos
  [ $_nargs -eq 0 ] && _clean_traverse basestation common perception ugv uav simulation subt_launch || _clean_traverse $@

elif chk_flag rm $@ ; then
  shift
  _nargs=$#
  # reset the submodules for all the given intermediate level repos
  [ $_nargs -eq 0 ] && _rm_traverse basestation common perception ugv uav simulation subt_launch || _rm_traverse $@

fi

# cleanup & exit
exit_on_success
