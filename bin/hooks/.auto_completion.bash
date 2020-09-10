#!/usr/bin/env bash

# load header helper functions
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/hooks/.header.bash"
. "$SUBT_PATH/operations/bin/hooks/.help.bash"

# globals
GL_GIT_HOOKS_DIR=$SUBT_PATH/operations/bin/hooks/

# @brief find the the current auto-complete token matches
__matcher() {
  local _matcher_t=$1 _curr=$2
  [[ "$_curr" == "" ]] && return 1  # if not given a current token, then show the help usage message
  # evaluate the matcher
  local _result=$(perl $GL_GIT_HOOKS_DIR/dmatch.pl "$_matcher_t" "$_curr")
  [ ! -z "$_result" ] && COMPREPLY=( $( compgen -W "$_result" -- "$_str" ) ) && return 0
  return 1
}

# //////////////////////////////////////////////////////////////////////////////
# @brief tab autocompletion for subt 'command center'
#   - three level menu of subcommands
# //////////////////////////////////////////////////////////////////////////////
_ac_subt_completion() {

  COMPREPLY=() # initialize completion result array.

  # Retrieve the current command-line token, i.e., the one on which completion is being invoked.
  local _curr=${COMP_WORDS[COMP_CWORD]}
  local _prev=${COMP_WORDS[COMP_CWORD-1]}

  # first level menu: 'subt'
  if [ $COMP_CWORD = 1 ]; then
    ! __matcher "subt" $_curr && __ac_subt_help

  # second level menu: 'subt <subcommand> '
  elif [ $COMP_CWORD = 2 ]; then
    if chk_flag git "${COMP_WORDS[@]}"; then
      ! __matcher "git" "$_curr" && __ac_git_help

    # cloud menu
    elif chk_flag cloud "${COMP_WORDS[@]}"; then
      ! __matcher "cloud" $_curr && __ac_cloud_help

    # tools menu
    elif chk_flag tools "${COMP_WORDS[@]}"; then
      ! __matcher "tools" $_curr && __ac_tools_help

    # deployer menu
    elif chk_flag deployer "${COMP_WORDS[@]}"; then
      ! __matcher "deployer" $_curr && __ac_deploy_help

    # 'subt <subcommand>' match failed -- show display usage help menu
    else
      __ac_subt_help
    fi

  # third level menu: 'subt <subcommand> <subcommand> '
  else

    # second level 'subt git'
    if chk_flag git "${COMP_WORDS[@]}"; then

      if chk_flag status "${COMP_WORDS[@]}"; then
        ! __matcher "git_status" "$_curr" && __ac_git_status_help
      elif chk_flag sync "${COMP_WORDS[@]}"; then
        ! __matcher "git_sync" "$_curr" && __ac_git_sync_help
      elif chk_flag clone "${COMP_WORDS[@]}"; then
        ! __matcher "git_clone" "$_curr" && __ac_git_clone_help
      fi

    # second level 'subt cloud'
    elif chk_flag cloud "${COMP_WORDS[@]}"; then

      if chk_flag terraform "${COMP_WORDS[@]}"; then
        ! __matcher "cloud_terra" "$_curr" && __ac_cloud_terra_help
      elif chk_flag ansible "${COMP_WORDS[@]}"; then
        ! __matcher "cloud_ani" "$_curr" && __ac_cloud_ansible_help
      fi

    elif chk_flag deployer "${COMP_WORDS[@]}"; then
      # TODO: need to match the deployer help...
      ! __matcher "deployer" $_curr && __ac_deploy_submenu_help $_prev

    fi


  fi
}
