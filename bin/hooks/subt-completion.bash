#!/usr/bin/env bash

# load header helper functions
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/hooks/.header.bash"

# import all the submodules

# globals
GL_GIT_HOOKS_DIR=$SUBT_PATH/operations/bin/hooks/

# @brief autocomplete usage message for subt command
__ac_subt_flags(){
  echo "deploy git help"
}
__ac_subt_help() {
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
__ac_deploy_help() {
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
__ac_git_help() {
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
__ac_git_status_help() {
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
__ac_git_sync_help() {
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

# evaluate the regex match as an autocomplete
__regex_eval() {
  local _str=$1 _funptr=$2
  local _result=$(__regex_expand $_str "$(${_funptr})" )
  if [ ! -z "$_result" ]; then
    COMPREPLY=( $( compgen -W "$_result" -- "$_str" ) )
    return 0
  fi
  return 1
}

# //////////////////////////////////////////////////////////////////////////////
# tab autocompletion for subt subcommands
# //////////////////////////////////////////////////////////////////////////////
_subt_completion() {

  COMPREPLY=() # initialize completion result array.

  # Retrieve the current command-line token, i.e., the one on which completion is being invoked.
  local _curr=${COMP_WORDS[COMP_CWORD]}
  local _prev=${COMP_WORDS[COMP_CWORD-1]}

  # given one autocomplete tokens, i.e. 'subt'
  if [ $COMP_CWORD = 1 ]; then
    # evaluate the matcher for 'subt'
    if ! __regex_eval $_curr __ac_subt_flags; then
      __ac_subt_help
    fi

  # given two autocomplete tokens, i.e. 'subt git' or 'subt deploy'
  elif [ $COMP_CWORD = 2 ]; then

    # evaluate the matcher for 'subt git' & show its usage message
    if chk_flag git "${COMP_WORDS[@]}"; then
      if ! __regex_eval $_curr __ac_git_flags; then
        __ac_git_help
      fi

    # evaluate the matcher for 'subt deploy' & show its usage message
    elif chk_flag deploy "${COMP_WORDS[@]}"; then
      __ac_deploy_help

    # 'subt <subcommand>' match failed, then show display usage help.
    else
      __ac_subt_help
    fi

  # given three autocomplete tokens
  elif [ $COMP_CWORD -ge 3 ]; then

    # autocomplete tokens only contain 'git' as subcommand
    if chk_flag git "${COMP_WORDS[@]}" && ! chk_flag deploy "${COMP_WORDS[@]}" ; then

      # evaluate the matcher for 'subt git status' & show its usage message
      if chk_flag status "${COMP_WORDS[@]}"; then
        if ! __regex_eval $_curr __ac_git_status_flags; then
          __ac_git_status_help
        fi

      # evaluate the matcher for 'subt git sync' & show its usage message
      elif chk_flag sync "${COMP_WORDS[@]}"; then
        if ! __regex_eval $_curr __ac_git_sync_flags; then
          __ac_git_sync_help
        fi

      # 'subt <subcommand>' match failed, then show display usage help.
      else
        __ac_git_help
      fi
    elif ! chk_flag git "${COMP_WORDS[@]}" && chk_flag deploy "${COMP_WORDS[@]}" ; then
      echo "deploy not yet implemented."
    else
      echo "cannot parse both git & deploy. please just give one subcommand."
    fi

  fi

}