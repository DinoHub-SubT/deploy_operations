#!/usr/bin/env bash

# load header helper functions
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/hooks/.header.bash"
. "$SUBT_PATH/operations/bin/hooks/.help.bash"

# import all the submodules

# globals
GL_GIT_HOOKS_DIR=$SUBT_PATH/operations/bin/hooks/

# @brief match a set of arguments (i.e subcommand flags) to the input token
__regex_expand() {
  local _regex="^.*$1.*$"  # match from start -> end, match any char unlimited times
  local _flags=($2)        # given subcommand flags to match
  local _match=""
  # regex match with all flags
  for _flag in "${_flags[@]}"; do
    [[ $_flag =~ $_regex ]] && _match="$_flag $_match"
  done
  echo $_match
}

# @brief evaluate the regex match as an autocomplete
__regex_eval() {
  local _str=$1 _funptr=$2
  local _result=$(__regex_expand $_str "$(${_funptr})" )
  # evaluate the tab completion if regex had any matches
  [ ! -z "$_result" ] && COMPREPLY=( $( compgen -W "$_result" -- "$_str" ) ) && return 0
  return 1
}

# //////////////////////////////////////////////////////////////////////////////
# @brief tab autocompletion for subt subcommands
# //////////////////////////////////////////////////////////////////////////////
_ac_subt_completion() {

  COMPREPLY=() # initialize completion result array.

  # Retrieve the current command-line token, i.e., the one on which completion is being invoked.
  local _curr=${COMP_WORDS[COMP_CWORD]}
  local _prev=${COMP_WORDS[COMP_CWORD-1]}

  ## given one autocomplete token -> 'subt'
  if [ $COMP_CWORD = 1 ]; then
    # evaluate the matcher for 'subt'
    ! __regex_eval $_curr __ac_subt_flags && __ac_subt_help

  ## given two autocomplete tokens -> 'subt git', ...
  elif [ $COMP_CWORD = 2 ]; then

    # evaluate the matcher -> 'subt git'
    if chk_flag git "${COMP_WORDS[@]}"; then
      ! __regex_eval $_curr __ac_git_flags && __ac_git_help

    # evaluate the matcher -> 'subt deployer'
    elif chk_flag deployer "${COMP_WORDS[@]}"; then
      __ac_deploy_help

    # evaluate the matcher -> 'subt cloud'
    elif chk_flag cloud "${COMP_WORDS[@]}"; then
      ! __regex_eval $_curr __ac_cloud_flags && __ac_cloud_help

    # evaluate the matcher -> 'subt tools'
    elif chk_flag tools "${COMP_WORDS[@]}"; then
      ! __regex_eval $_curr __ac_tools_flags && __ac_tools_help

    else  # 'subt <subcommand>' match failed, then show display usage help.
      __ac_subt_help
    fi

  ## given three autocomplete tokens -> 'subt git status', ...
  elif [ $COMP_CWORD -ge 3 ]; then

    # TODO: cleanup -- check_ONLY not with ! check

    # autocomplete subcommand -> 'git'
    if chk_flag git "${COMP_WORDS[@]}"          \
      && ! chk_flag deployer "${COMP_WORDS[@]}" \
      && ! chk_flag cloud "${COMP_WORDS[@]}" \
      && ! chk_flag tools "${COMP_WORDS[@]}" ; then

      # evaluate the matcher -> 'subt git status'
      if chk_flag status "${COMP_WORDS[@]}"; then
        ! __regex_eval $_curr __ac_git_status_flags && __ac_git_status_help

      # evaluate the matcher -> 'subt git sync'
      elif chk_flag sync "${COMP_WORDS[@]}"; then
        ! __regex_eval $_curr __ac_git_sync_flags && __ac_git_sync_help

      else  # 'subt <subcommand>' match failed, then show display usage help.
        __ac_git_help
      fi

    # autocomplete subcommand -> 'deployer'
    elif chk_flag deployer "${COMP_WORDS[@]}" \
      && ! chk_flag git "${COMP_WORDS[@]}"    \
      && ! chk_flag cloud "${COMP_WORDS[@]}" \
      && ! chk_flag tools "${COMP_WORDS[@]}" ; then

      echo "deploy not yet implemented."

    # autocomplete subcommand -> 'cloud'
    elif chk_flag cloud "${COMP_WORDS[@]}" \
      && ! chk_flag git "${COMP_WORDS[@]}" \
      && ! chk_flag deployer "${COMP_WORDS[@]}" \
      && ! chk_flag tools "${COMP_WORDS[@]}" ; then

      # evaluate the matcher -> 'subt cloud ansible'
      if chk_flag ansible "${COMP_WORDS[@]}"; then
        ! __regex_eval $_curr __ac_cloud_ansible_flags && __ac_cloud_ansible_help

      # evaluate the matcher -> 'subt cloud ansible'
      elif chk_flag terraform "${COMP_WORDS[@]}"; then
        ! __regex_eval $_curr __ac_cloud_terra_flags && __ac_cloud_terra_help
      fi


    else
      echo "cannot parse both git & deploy. please just give one subcommand."
    fi
  fi
}
