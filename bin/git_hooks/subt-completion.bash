#!/usr/bin/env bash

# load header helper functions
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/git_hooks/.header.bash"

# import all the submodules

# globals
GL_GIT_HOOKS_DIR=$SUBT_PATH/operations/bin/git_hooks/

# @brief autocomplete usage message for subt command
__ac_subt_flags(){
  echo "deploy git help"
}
__ac_subt() {
  local usage=(
    "deploy : Deployer tool to setup localhost, azure or robots system."
    "git    : Helper subcommands for maintaining deploy 3 level repo."
    "help   : View help usage message."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

# @brief autocomplete usage message for 'subt deploy' command
__ac_deploy() {
  local usage=(
    "robots     : deploy robots."
    "help, -h : View help usage message for each sub command."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

# @brief autocomplete usage message for 'subt git' command
__ac_git_flags(){
  echo "status sync reset clean pr help"
}
__ac_git() {
  local usage=(
    "status   : Show the general git info for every submodule (inter and lower)."
    "sync     : Fetchs & Syncs the local branches with the remote branches."
    "reset    : Resets intermediate repo or submodule to detached HEAD."
    "clean    : Cleans an intermediate repo or submodule."
    "pr       : Create a pull request for top & intermeidate repo branches."
    "help, -h : View help usage message for each sub command."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

# @brief autocomplete usage message for 'subt deploy info' command
__ac_git_status_flags(){
  echo "basestation common perception simulation ugv uav help"
}
__ac_git_status() {
  local usage=(
    "basestation  : basestation intermediate level repo -> ~/deploy_ws/src/basestation"
    "common       : common intermediate level repo -> ~/deploy_ws/src/common"
    "perception   : perception intermediate level repo -> ~/deploy_ws/src/perception"
    "simuation    : simulation intermediate level repo -> ~/deploy_ws/src/simulation"
    "ugv          : ugv intermediate level repo -> ~/deploy_ws/src/ugv"
    "uav          : uav intermediate level repo -> ~/deploy_ws/src/uav"
    "help         : View help usage message for each sub command."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

# @brief autocomplete usage message for 'subt deploy info' command
__ac_git_sync_flags(){
  echo "basestation common perception simulation ugv uav help"
}
__ac_git_sync() {
  local usage=(
    "-b       : basestation intermediate level repo -> ~/deploy_ws/src/basestation"
    "-c       : common intermediate level repo -> ~/deploy_ws/src/common"
    "-p       : perception intermediate level repo -> ~/deploy_ws/src/perception"
    "-s       : simulation intermediate level repo -> ~/deploy_ws/src/simulation"
    "-ugv     : ugv intermediate level repo -> ~/deploy_ws/src/ugv"
    "-uav     : uav intermediate level repo -> ~/deploy_ws/src/uav"
    "-del     : delete any local branches not found on the origin remote."
    "-hard    : sync the currently checkout branch."
    "help     : View help usage message for each sub command."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

__ac_git_clone() {
  "basestation        : basestation intermediate level repo -> ~/deploy_ws/src/basestation"
  "ugv                : all of ugv -> ~/deploy_ws/src/ugv"
  "ugv.base           : ugv base only intermediate level repo -> ~/deploy_ws/src/ugv/ppc & ~/deploy_ws/src/ugv/nuc"
  "ugv.slam           : ugv slam only intermediate level repo -> ~/deploy_ws/src/ugv/slam"
  "ugv.hardware       : ugv hardware intermediate level repo -> ~/deploy_ws/src/ugv/hardware"
}

# match a set of arguments (i.e subcommand flags) to the input token
__regex_expand() {
  local _flags=($2)           # given subcommand flags to match
  local _regex="^.*$1.*$"  # match from start -> end, match any char unlimited times
  local _match=""

  for _flag in "${_flags[@]}"; do
    if [[ $_flag =~ $_regex ]] ; then
      _match="$_flag $_match"
    fi
  done
  echo $_match
}

# //////////////////////////////////////////////////////////////////////////////
# tab autocompletion for subt subcommands
# TODO: make a proper regex matcher everywhere!
# //////////////////////////////////////////////////////////////////////////////
_subt_completion() {

  COMPREPLY=() # initialize completion result array.

  # Retrieve the current command-line token, i.e., the one on which completion is being invoked.
  local curr=${COMP_WORDS[COMP_CWORD]}
  local prev=${COMP_WORDS[COMP_CWORD-1]}

  # given only one completion token, it is, by default the 'subt' token -- since 'complete' main call from subt.bash already signals it
  if [ $COMP_CWORD = 1 ]; then

    local _result=$(__regex_expand $curr "$(__ac_subt_flags)" )
      if [ ! -z "$_result" ]; then
        COMPREPLY=( $( compgen -W "$_result" -- "${curr}" ) )
      else
        __ac_subt
      fi

  # we have completed the first and second tokens. i.e. we have a subcommand
  elif [ $COMP_CWORD = 2 ]; then

    # show the 'subt git' subcommands
    if [ $prev = "git" ]; then
      local _result=$(__regex_expand $curr "$(__ac_git_flags)" )
      if [ ! -z "$_result" ]; then
        COMPREPLY=( $( compgen -W "$_result" -- "${curr}" ) )
      else
        __ac_git
      fi

    elif [ $prev = "deploy" ]; then
      # todo: check current token, then apply completion. otherwise show help...
      __ac_deploy

    # not given a correct subcommand, show 'subt' help usage
    else
      __ac_subt
    fi

  # we were given a subcommand, show the usage message for subcommands
  elif [ $COMP_CWORD -ge 3 ]; then

    # show the 'subt git status' subcommands
    if [ $prev = "status" ]; then
      local _result=$(__regex_expand $curr "$(__ac_git_status_flags)" )
      if [ ! -z "$_result" ]; then
        COMPREPLY=( $( compgen -W "$_result" -- "${curr}" ) )
      else
        __ac_git_status
      fi

    # show the 'subt git sync' subcommands
    elif [ $prev = "sync" ]; then
      local _result=$(__regex_expand $curr "$(__ac_git_sync_flags)" )
      if [ ! -z "$_result" ]; then
        COMPREPLY=( $( compgen -W "$_result" -- "${curr}" ) )
      else
        __ac_git_sync
      fi

    # not given a correct subcommand, show 'subt git' help usage
    else
      __ac_git
    fi

  fi


}