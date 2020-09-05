#!/usr/bin/env bash

# load header helper functions
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/git_hooks/.header.bash"

# globals
GL_GIT_HOOKS_DIR=$SUBT_PATH/operations/bin/git_hooks/

declare -a arr=(
  'help'
  "info"
  "status"
  "commit"
  "docker"
  "fetch"
  "pr"
  "push"
  "sync"
  "tag"
  )

# function _subt_tab_completions() {
#   # if [ "${#COMP_WORDS[@]}" -lt "2" ]; then
#   #   COMPREPLY=( $(compgen -o default -- "${COMP_WORDS[COMP_CWORD]}") )
#   # COMPREPLY=($(compgen -W "$(get_all_files)" -- "${COMP_WORDS[1]}"))
#   #   return
#   # fi
#   # COMPREPLY=($(compgen -W "now tomorrow never" "${COMP_WORDS[1]}"))
#   local cur prev
#   cur=${COMP_WORDS[COMP_CWORD]}
#   prev=${COMP_WORDS[COMP_CWORD-1]}
# 
#   case ${COMP_CWORD} in
#     1)
#       # COMPREPLY=($(compgen -W "now tomorrow never" "${COMP_WORDS[1]}"))
#       # COMPREPLY+=($(compgen -W "hello tomorrow never" "${COMP_WORDS[1]}"))
#       # COMPREPLY=($(compgen -W "$(__help)" "${COMP_WORDS[1]}"))
# 
#       # for i in "${arr[@]}"; do
#       #   COMPREPLY+=($(compgen -W "$i" "${COMP_WORDS[1]}"))
#       # done
# 
#       printf "hello????????"
#       echo -e "hello?
#         hello again?
#       "
#       ;;
#     2)
#       case ${prev} in
#         configure)
#           COMPREPLY=($(compgen -W "CM DSP NPU" -- ${cur}))
#           ;;
#         subt)
#           COMPREPLY=($(compgen -W "some other args" -- ${cur}))
#           ;;
#       esac
#       ;;
#     *)
#       COMPREPLY=()
#       ;;
#   esac
# }

_telnet() {
  COMPREPLY=()
  local cur
  cur=${COMP_WORDS[COMP_CWORD]}
  local completions="
10.10.10.10 - routerA
10.10.10.11 - routerB
10.20.1.3 - routerC"

  local OLDIFS="$IFS"
  local IFS=$'\n'
  COMPREPLY=( $( compgen -W "$completions" -- "$cur" ) )
  IFS="$OLDIFS"
  if [[ ${#COMPREPLY[*]} -eq 1 ]]; then #Only one completion
    COMPREPLY=( ${COMPREPLY[0]%% - *} ) #Remove ' - ' and everything after
  fi
  return 0
}

_dothis_completions()
{
  # if [ "${#COMP_WORDS[@]}" != "2" ]; then
  #   return
  # fi

  # echo "start?"
  local commands_number=10
  local IFS=$'\n'
  # local suggestions=($(compgen -W "$(ls | sed 's/\t//')" -- "${COMP_WORDS[1]}"))
  local suggestions=(
    "help: see help usage message"
    "info: show git submodule information"
    "tag: create a git tag for intermediate repos"
    "checkout: checkout a new or existing branch"
  )
  suggestions[0]="$(printf '%*s' "-$COLUMNS"  "${suggestions[0]}")"

  if [ "${#suggestions[@]}" == "1" ]; then
    echo "are we in first?"
    local number="${suggestions[0]/%\ */}"
    COMPREPLY=("$number")
  else
    # for i in "${suggestions[@]}"; do
    #   echo "what is $i"
    #   suggestions[$i]="$(printf '%*s' "-$COLUMNS"  "${suggestions[$i]}")"
    # done

    # echo "what is result? ${suggestions[@]}"
    # echo "${suggestions[@]}"
    COMPREPLY=("${suggestions[@]}")
  fi
}

# complete -F _subt_tab_completions subt
# complete -F _telnet subt
# complete -F _dothis_completions subt

# subt

