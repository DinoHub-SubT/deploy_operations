#!/usr/bin/env bash
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/automate/.header.bash"
. "$SUBT_PATH/operations/bin/automate/.help.bash"
. "$SUBT_PATH/operations/deploy/azurebooks/scripts/header.sh"

# globals
_GL_INTER=("basestation" "common" "perception" "ugv" "uav" "simulation" "subt_launch")
_GL_USER=$(git config --get user.name)
_GL_EMAIL=$(git config --get user.email)
_HOME=$HOME

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

__create_commit_msg() {
  local _deploy_commit_message=$1
  local _deploy_commit_hash=$2
  local _deploy_commit_branch=$3
  local _commit_url="https://bitbucket.org/cmusubt/deploy/commits/$_deploy_commit_hash"
  echo -e "\
== AUTOMATICALLY GENERATED == \n\
\n\
Creating an automated git commit message. \n\
\n\
This commit was triggered by top level deploy commit '$_deploy_commit_hash' at branch '$_deploy_commit_branch' \n\
\n\
deploy commit that triggered: $_commit_url \n\
\n\
-- deploy commit message -- \n\
\n\
$_deploy_commit_message \n\
"
}

# @brief add commits to all the intermediate repos
__intermediate_commit() {
  echo "we are here??"

  local _deploy_commit_message=$(git show --stat --oneline HEAD)
  local _hash=$(git rev-parse --verify HEAD)
  local _branch=$(git rev-parse --abbrev-ref HEAD)
  local _orig_git_index_file=$GIT_INDEX_FILE

  # eval echo -e "what is the final commit message? \n $_GL_COMMITMSG"

  # get the list of intermediate repos
  local _changes=$(git diff --cached --name-status | cut -f2)
  for _ch in $_changes; do

    if chk_eq $_ch basestation || chk_eq $_ch common || chk_eq $_ch perception \
      || chk_eq $_ch simulation || chk_eq $_ch ugv || chk_eq $_ch uav; then

      # create the intermediate repo commit
      local _msg=$(__create_commit_msg "$_deploy_commit_message" "$_hash" "$_branch")

      # perform the commit in the intermediate repo
      # pushd $SUBT_PATH/$_ch
      cd $SUBT_PATH/$_ch

      # pwd
      echo "repo commit: $_ch"
      echo -e "$_msg"

      # checkout the same branch name as deploy repo
      # reset branch to remote
      echo "what is the username $_GL_EMAIL"

      env -i git add -A               # stage all changes
      export GIT_INDEX_FILE=$SUBT_PATH/.git/modules/basestation/index
      env git commit -m "$_msg"   # commit the changes
      # push all changes
      # popd

    fi
  done

  export $GIT_INDEX_FILE=$_orig_git_index_file

  # pushd $SUBT_PATH
  # for _repo in ${_GL_INTER[@]}; do
  #   echo "intermediate repo is: $_repo"
  # done
  # popd
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
