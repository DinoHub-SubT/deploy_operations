#!/usr/bin/env bash

# load header helper functions
. "$SUBT_PATH/operations/scripts/header.sh"
. "$SUBT_PATH/operations/scripts/automate/header.sh"
. "$SUBT_PATH/operations/scripts/automate/cmpl/help.bash"

##
# @brief find the auto-complete help results (expanded from deployer sections)
##
ac_matcher_help() {
  local _subcommand=$1
  local _prev=$2
  local _result=$(perl $GL_CMPL_DIR/cmpl.pl "${_subcommand}_help" "$_prev")
  # split resulting string based on newlines
  SAVEIFS=$IFS        # save current IFS, so we can revert back to it
  IFS=$'\n'           # change IFS to split on new lines
  _result=($_result)
  IFS=$SAVEIFS        # revert to old IFS

  local IFS=$'\n' # split output of compgen below by lines, not spaces
  _result[0]="$(printf '%*s' "-$COLUMNS"  "${_result[0]}")"
  COMPREPLY=("${_result[@]}")
}

##
# @brief find the the current auto-complete token matches
##
ac_matcher() {
  local _matcher_t=$1 _curr=$2
  [[ "$_curr" == "" ]] && return 1  # if not given a current token, then show the help usage message
  # evaluate the matcher
  local _result=$(perl $GL_CMPL_DIR/cmpl.pl "$_matcher_t" "$_curr")
  # local _term_t=$(ps -p$$ -ocmd=)
  if [ ! -z "$_result" ]; then
    # [ "$_term_t" = "bash" ] && COMPREPLY=( $( compgen -W "$_result" -- "$_str" ) ) && compopt -o nospace && return 0
    # [ "$_term_t" = "zsh" ]  && COMPREPLY=( $( compgen -W "$_result" -- "$_str" ) ) && return 0
    COMPREPLY=( $( compgen -W "$_result" -- "$_str" ) ) && return 0
  fi
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

  # a finished subcommand argument does not have a trailing '.'
  #   - if so, then reset prev to the subcommand name.
  if [ $COMP_CWORD -gt 1 ]; then
    if [ ! ${_prev: -1} == "." ]; then
      local _prev=${COMP_WORDS[2]}
    fi
  fi

  # first level menu: 'subt'
  if [ $COMP_CWORD = 1 ]; then
    ! ac_matcher "subt" $_curr && __ac_subt_help

  # second level menu: 'subt <subcommand> '
  elif [ $COMP_CWORD = 2 ]; then
    if chk_flag git "${COMP_WORDS[@]}"; then
      ! ac_matcher "git" "$_curr" && __ac_git_help

    # cloud menu
    elif chk_flag cloud "${COMP_WORDS[@]}"; then
      ! ac_matcher "cloud" $_curr && __ac_cloud_help

    # ansible menu
    elif chk_flag ansible "${COMP_WORDS[@]}"; then
      ! ac_matcher "ansible" $_curr && __ac_ansible_help

    # tools menu
    elif chk_flag tools "${COMP_WORDS[@]}"; then
      ! ac_matcher "tools" $_curr && __ac_tools_help

    # deployer menu
    elif chk_flag deployer "${COMP_WORDS[@]}"; then
      ! ac_matcher "deployer" $_curr        && ac_matcher_help "deployer" "deployer"

    # 'subt <subcommand>' match failed -- show display usage help menu
    else
      __ac_subt_help
    fi

  # third level menu: 'subt <subcommand> <subcommand> '
  else

    # second level is: 'subt git'
    if chk_flag status "${COMP_WORDS[@]}"; then
      ! ac_matcher "git_status" "$_curr"     && ac_matcher_help "git_status" $_prev
    elif chk_flag sync "${COMP_WORDS[@]}"; then
      ! ac_matcher "git_sync" "$_curr"       && ac_matcher_help "git_sync" $_prev
    elif chk_flag add "${COMP_WORDS[@]}"; then
      ! ac_matcher "git_add" "$_curr"        && ac_matcher_help "git_add" $_prev
    elif chk_flag git "${COMP_WORDS[@]}"; then
      local _subcmd=${COMP_WORDS[2]} # get the git subcommand
      ! ac_matcher "git_$_subcmd" "$_curr"   && __ac_git_help

    # third level 'mmpug ansible'
    elif chk_flag ansible "${COMP_WORDS[@]}"; then
      ! ac_matcher "ansible" "$_curr"        && ac_matcher_help "ansible" $_prev

    # second level is: 'subt cloud'
    elif chk_flag cloud "${COMP_WORDS[@]}"; then

      if chk_flag terraform "${COMP_WORDS[@]}"; then
        ! ac_matcher "cloud_terra" "$_curr"  && ac_matcher_help "cloud_terra" $_prev
      elif chk_flag ansible "${COMP_WORDS[@]}"; then
        ! ac_matcher "cloud_ani" "$_curr"    && ac_matcher_help "cloud_ani" $_prev
      fi

    # second level is: 'subt deployer'
    elif chk_flag deployer "${COMP_WORDS[@]}"; then
      ! ac_matcher "deployer" $_curr        && ac_matcher_help "deployer" $_prev
    fi
  fi
}
