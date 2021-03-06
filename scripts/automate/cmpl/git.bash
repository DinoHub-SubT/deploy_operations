#!/usr/bin/env bash
. "$SUBT_PATH/operations/scripts/header.sh"
. "$SUBT_PATH/operations/scripts/formatters.sh"
. "$SUBT_PATH/operations/scripts/automate/header.sh"
. "$SUBT_PATH/operations/scripts/automate/cmpl/help.bash"

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
  # if chk_flag status $@; then
  #   __status_help
  # elif chk_flag sync $@; then
  #   __sync_help
  # elif chk_flag add $@; then
  #   __add_help
  # fi

  text_color "For more help, please see the README.md or wiki."
  GL_TEXT_COLOR=$FG_DEFAULT

  exit_success
fi

# globals
GL_STATUS_HASH=false
GL_STATUS_URL=false
GL_SYNC_DELETE_BRANCH=false
GL_SYNC_IGNORE_CURR=true
GL_OPTS=""

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
  local _dirty=$(git_is_dirty)
  local _untrack=$(git_ntracked)
  local _uncommit=$(git_ncommit)
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
_status_traverse_table() {
  # go through all given intermediate repo arguments
  for _inter in "$@"; do
    # ignore the non-interrepo flags
    chk_flag -table $_inter || chk_flag -hash $_inter || chk_flag -url $_inter && continue

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

    # display the intermediate repo git status
    printf "%-10s \n" "...git status"
    git status                  # perform a git status, to speed up top level deploy indexing

    popd
  done
}

_status_traverse_flat() {
  # go through all given intermediate repo arguments
  for _inter in "$@"; do
    # ignore the non-interrepo flags
    chk_flag -table $_inter || chk_flag -hash $_inter || chk_flag -url $_inter && continue

    # ignore the non-interrepo flags
    chk_flag -hash $_inter || chk_flag -url $_inter && continue
    text "\n$FG_LCYAN|--$_inter--|"
    pushd $_inter
    git status
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
  local _heads=($(git_branches heads))
  local _remotes=($(git_branches remotes))

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
    if get_value "'refs/remotes/origin/$short'" "${_remotes[@]}"; then
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
    [[ "$_inter" = "deploy" ]] && _inter="$SUBT_PATH"
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
# @brief git add
# //////////////////////////////////////////////////////////////////////////////
_add_commit_msg() {
  local _deploy_commit_message=$1
  local _deploy_commit_hash=$2
  local _deploy_commit_branch=$3
  local _commit_url="https://bitbucket.org/cmusubt/deploy/commits/$_deploy_commit_hash"
  echo -e "\
== AUTOMATICALLY GENERATED (deploy [COMMIT HASH NOT YET CREATED] ) == \n\
\n\
Creating an automated git commit message. \n\
\n\
This commit was triggered by top level deploy hash '[COMMIT HASH NOT YET CREATED]' at branch '$_deploy_commit_branch' \n\
\n\
deploy commit that triggered: $_commit_url \n\
\n\
-- deploy commit message -- \n\
\n\
$_deploy_commit_message \n\
"
}

# @brief add commits to all the intermediate repos
_add_traverse() {
  local _deploy_commit_message=$(git show --stat --oneline HEAD)
  local _hash=$(git rev-parse --verify HEAD)
  local _br=$(git symbolic-ref --short HEAD)
  local _brshort="autofeat/${_br#"heads/"}"
  local _heads=($(git_branches heads))
  local _remotes=($(git_branches remotes))

  # stage & commit all intermediate repo changes
  for _inter in "$@"; do

    # skip over the push flag
    chk_flag --push $_inter && continue

    echo -e "$FG_COLOR_WARNING...creating automated commit in: $_inter $FG_DEFAULT\n"
    pushd $SUBT_PATH/$_inter

    # checkout (or create) the same branch name as deploy repo branch
    git fetch -q -a
    # TODO: using branches arr, change if local br exists, then use 'checkout', otherwise use 'checkout -b'
    git checkout  -q -f -b $_brshort

    # sync local 'deploy named' branch to remote origin
    if get_value "'refs/remotes/origin/$_brshort'" "${_remotes[@]}"; then
      git update-ref "$branch" "refs/remotes/origin/$_brshort"
    fi

    # create the intermediate repo commit
    local _msg=$(_add_commit_msg "$_deploy_commit_message" "$_hash" "$_brshort")

    # perform the commit in the intermediate repo
    env -i git add -A               # stage all changes
    export GIT_INDEX_FILE="$SUBT_PATH/.git/modules/basestation/index"
    env git commit -m "$_msg"   # commit the changes

    # for now, always git push origin, then later push only when deploy top level pushes
    git push origin $_brshort

    # go back to top level deploy dir
    popd

    # then stage the intermediate repo
    env -i git add $_inter
  done

  newline
  echo -e "$FG_COLOR_WARNING -> Your intermediate repos are staged & ready to push to origin. $FG_DEFAULT\n"
}

# //////////////////////////////////////////////////////////////////////////////
# @brief: main entrypoint
# //////////////////////////////////////////////////////////////////////////////
pushd $SUBT_PATH

# enable
chk_flag -p $@ && GL_OPTS="$GL_OPTS -p"
chk_flag -v $@ && GL_OPTS="$GL_OPTS -v"

if chk_flag status $@ ; then
  shift
  _nargs=$#

  # append the display options
  chk_flag -hash $@ && GL_STATUS_HASH=true
  chk_flag -url $@ && GL_STATUS_URL=true

  if chk_flag -table $@; then
    # top level deploy repo
    # display submodule information as a column table print style
    text "\n$FG_LCYAN|--deploy--|"
    printf "%-50s | %-38s | %-64s " "--submodule--" "--branch--" "--status--"
    [[ $GL_STATUS_HASH == true ]] && printf " | %-40s" "--git hash--" && ((_nargs--))
    [[ $GL_STATUS_URL == true ]]  && printf " | %-30s" "--git url--"  && ((_nargs--))
    printf "\n"
    _status # show the status
    # display the intermediate repo git status
    printf "%-10s \n" "...git status"
    git status                  # perform a git status, to speed up top level deploy indexing

    # show git status for all the given intermediate level repos
    [ $_nargs -eq 0 ] && _status_traverse_table basestation common perception ugv uav simulation subt_launch || _status_traverse_table $@
  else
    [ $_nargs -eq 0 ] && _status_traverse_flat basestation common perception ugv uav simulation subt_launch || _status_traverse_flat $@
  fi

elif chk_flag sync $@ ; then
  shift
  _nargs=$#

  # append the display options
  chk_flag -del $@ && GL_SYNC_DELETE_BRANCH=true && ((_nargs--))
  chk_flag -hard $@ && GL_SYNC_IGNORE_CURR=false && ((_nargs--))

  # show git status for all the given intermediate level repos
  [ $_nargs -eq 0 ] && _sync_traverse basestation common perception ugv uav simulation subt_launch || _sync_traverse $@

elif chk_flag add $@ ; then
  shift
  _nargs=$#
  # reset the submodules for all the given intermediate level repos
  [ $_nargs -eq 0 ] && _add_traverse basestation common perception ugv uav simulation subt_launch || _add_traverse $@

fi

# cleanup & exit
exit_success
