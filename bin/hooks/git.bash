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
  fi

  text_color "For more help, please see the README.md or wiki."
  GL_TEXT_COLOR=$FG_DEFAULT

  exit_success
fi

# globals
GL_STATUS_HASH=false
GL_STATUS_URL=false

# @brief reset all the submodules to their DETACHED HEAD -- using deployer yamls (please see yamls for more info)
_reset() {
  pushd "$SUBT_PATH/"
  ./deployer -s git.rm.$@
  ./deployer -s git.init.$@
  ./deployer -s git.clone.$@
  popd
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
# @brief: main entrypoint
# //////////////////////////////////////////////////////////////////////////////
pushd $SUBT_PATH

if chk_flag status $@ ; then
  shift
  # append the display options
  chk_flag -hash $@ && GL_STATUS_HASH=true
  chk_flag -url $@ && GL_STATUS_URL=true

  # top level deploy repo
  # display submodule information as a column table print style
  text "\n$FG_LCYAN|--deploy--|"
  printf "%-50s | %-38s | %-64s " "--submodule--" "--branch--" "--status--"
  [[ $GL_STATUS_HASH == true ]] && printf " | %-40s" "--git hash--"
  [[ $GL_STATUS_URL == true ]]  && printf " | %-30s" "--git url--"
  printf "\n"
  _status # show the status

  # intermediate level repos
  [ $# -eq 0 ] && _status_traverse basestation common perception ugv uav simulation || _status_traverse $@
fi

# cleanup & exit
exit_on_success
