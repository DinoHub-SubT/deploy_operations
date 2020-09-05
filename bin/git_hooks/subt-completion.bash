#!/usr/bin/env bash

# load header helper functions
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/git_hooks/.header.bash"

# globals
GL_GIT_HOOKS_DIR=$SUBT_PATH/operations/bin/git_hooks/


# //////////////////////////////////////////////////////////////////////////////
# tab autocompletion for subt subcommands
# //////////////////////////////////////////////////////////////////////////////
__subt_completion() {

  local cur prev
  cur=${COMP_WORDS[COMP_CWORD]}
  prev=${COMP_WORDS[COMP_CWORD-1]}

  # echo "hello?"
  case ${COMP_CWORD} in
    (1)
      # echo "prev is: ${prev}"
      # echo "curr is: ${curr}"
      local main_help=(
        "deploy : Deployer tool to setup localhost, azure or robots system."
        "git    : Helper subcommands for maintaining deploy 3 level repo."
        "help   : View help usage message."
      )
      main_help[0]="$(printf '%*s' "-$COLUMNS"  "${main_help[0]}")"
      COMPREPLY=("${main_help[@]}")
      # echo $main_help
      ;;
    (2)
      case ${prev} in
        git)
          # COMPREPLY=($(compgen -W "some git args" -- ${cur}))
          local git_help=(
            "info     : Show the general git info for every submodule (inter and lower)."
            "status   : Show the git status for every submodule (inter and lower)."
            "help, -h : View help usage message for each sub command."
          )
          git_help[0]="$(printf '%*s' "-$COLUMNS"  "${git_help[0]}")"
          COMPREPLY=("${git_help[@]}")
          COMPREPLY=("hello")
          ;;
        deploy)
          echo "we here??"
          local deploy_help=(
            "robots     : deploy robots."
          )
          deploy_help[0]="$(printf '%*s' "-$COLUMNS"  "${deploy_help[0]}")"
          COMPREPLY=("${deploy_help[@]}")
          ;;
      esac
      ;;
    (*)
      COMPREPLY=()
      ;;
  esac
}

_subt_help() {
  local usage=(
    "deploy : Deployer tool to setup localhost, azure or robots system."
    "git    : Helper subcommands for maintaining deploy 3 level repo."
    "help   : View help usage message."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  # set the completion result
  COMPREPLY=("${usage[@]}")
}

_git_help() {
  local usage=(
    "info     : Show the general git info for every submodule (inter and lower)."
    "status   : Show the git status for every submodule (inter and lower)."
    "checkout : Checks out a given branch for an intermediate repo or submodule."
    "clean    : Cleans an intermediate repo or submodule."
    "reset    : Resets intermediate repo or submodule to detached HEAD."
    "push     : Pushes local branch to origin, for intermediate repo or submodule repos."
    "help, -h : View help usage message for each sub command."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

_git_info_help() {
  local usage=(
    "-b     : Basestation intermediate -> ~/deploy_ws/src/basestation"
    "-c     : Common intermediate -> ~/deploy_ws/src/common"
    "-p     : Perception intermediate repo."
    "-s     : Simulation intermediate repo."
    "-ugv   : Ugv intermediate repo."
    "-uav   : Uav intermediate repo."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

_deploy_help() {
  local usage=(
    "robots     : deploy robots."
    "help, -h : View help usage message for each sub command."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

# //////////////////////////////////////////////////////////////////////////////
# 
# //////////////////////////////////////////////////////////////////////////////
_subt_completion_v2() {

  COMPREPLY=() # Initialize the array variable through which completions must be passed out.

  # Retrieve the current command-line token, i.e., the one on which completion is being invoked.
  local curToken=${COMP_WORDS[COMP_CWORD]}
  local prevToken=${COMP_WORDS[COMP_CWORD-1]}

  # local cur prev
  # cur=${COMP_WORDS[COMP_CWORD]}
  # prev=${COMP_WORDS[COMP_CWORD-1]}
  # echo "curr Tok: $curToken?"
  # curToken=${curToken//'\'}

  # given only one completion token, it is, by default the 'subt' token -- since 'complete' main call from subt.bash already signals it
  if [ $COMP_CWORD = 1 ]; then
    # since given only 'subt' token, show the usage message
  
  # given another token, parse te kind of token to match
  # elif [ $COMP_CWORD = 2 ]; then
  # regex match current token, to match close to 'deploy' works
  # if [[ $curToken =~ ^[0-9]+/? ]]; then
  # if [[ $curToken == "d" ]] || ; then
  
    # TODO: make a proper regex matcher
    if [[ $curToken =~ ^(d|de|dep|depl|deplo|deploy)$ ]] ; then
      COMPREPLY=("deploy")
    elif [[ $curToken =~ ^(g|gi|git)$ ]] ; then
      COMPREPLY=("git")
    else
      _subt_help
    fi
  # we have completed the first and second tokens. i.e. we have a subcommand
  elif [ $COMP_CWORD = 2 ]; then
    if [ $prevToken = "git" ]; then

      if [[ $curToken =~ ^(i|in|inf|info)$ ]] ; then  # TODO: better regex match, leading characters (for example)
        COMPREPLY=("info")

      elif [[ $curToken =~ ^(s|st|sta|stat|statu|status)$ ]] ; then
        COMPREPLY=("status")

      elif [[ $curToken =~ ^(ch|chec|check|checko|checkou|checkout)$ ]] ; then
        COMPREPLY=("checkout")

      elif [[ $curToken =~ ^(cl|cle|clea|clean)$ ]] ; then
        COMPREPLY=("clean")

      elif [[ $curToken =~ ^(r|re|res|rese|reset)$ ]] ; then
        COMPREPLY=("reset")

      elif [[ $curToken =~ ^(p|pu|pus|push)$ ]] ; then
        COMPREPLY=("push")

      else  # nothing matched, display usage
        _git_help
      fi
    elif [ $prevToken = "deploy" ]; then
      # todo: check current token, then apply completion. otherwise show help...
      _deploy_help
    else
      _subt_help
    fi

  # we were given a subcommand, show the usage message for subcommands
  elif [ $COMP_CWORD = 3 ]; then

    if [ $prevToken = "info" ]; then
      if [[ $curToken =~ ^(-b)$ ]] ; then
        COMPREPLY=("-b")

      elif [[ $curToken =~ ^(-c)$ ]] ; then
        COMPREPLY=("-c")

      elif [[ $curToken =~ ^(-p)$ ]] ; then
        COMPREPLY=("-p")

      elif [[ $curToken =~ ^(-s)$ ]] ; then
        COMPREPLY=("-s")

      elif [[ $curToken =~ ^(-ug|-ugv)$ ]] ; then
        COMPREPLY=("-ugv")

      elif [[ $curToken =~ ^(-ua|-uav)$ ]] ; then
        COMPREPLY=("-uav")

      else
        _git_info_help
      fi
    fi

  fi
  # fi
  # case ${COMP_CWORD} in
  #   # given only 1 completion word. meaning only the 'subt' has been given.
  #   (1)
  #     _subt_help
  #     ;;
  #   (*)
  #     COMPREPLY=()
  #     ;;
  # esac
}