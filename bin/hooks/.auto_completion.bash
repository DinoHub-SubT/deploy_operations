#!/usr/bin/env bash

# load header helper functions
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/hooks/.header.bash"
. "$SUBT_PATH/operations/bin/hooks/.help.bash"

# import all the submodules

# globals
GL_GIT_HOOKS_DIR=$SUBT_PATH/operations/bin/hooks/

# match a set of arguments (i.e subcommand flags) to the input token
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

# evaluate the regex match as an autocomplete
__regex_eval() {
  local _str=$1 _funptr=$2
  local _result=$(__regex_expand $_str "$(${_funptr})" )
  # evaluate the tab completion if regex had any matches
  [ ! -z "$_result" ] && COMPREPLY=( $( compgen -W "$_result" -- "$_str" ) ) && return 0
  return 1
}

# //////////////////////////////////////////////////////////////////////////////
# tab autocompletion for subt subcommands
# //////////////////////////////////////////////////////////////////////////////
_ac_subt_completion() {

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
