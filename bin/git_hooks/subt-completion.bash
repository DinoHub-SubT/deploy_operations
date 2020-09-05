#!/usr/bin/env bash

# load header helper functions
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/git_hooks/.header.bash"

# globals
GL_GIT_HOOKS_DIR=$SUBT_PATH/operations/bin/git_hooks/

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
    # since given only 'subt' token, show the usage message
    if [[ $curr =~ ^(d|de|dep|depl|deplo|deploy)$ ]] ; then
      COMPREPLY=("deploy")
    elif [[ $curr =~ ^(g|gi|git)$ ]] ; then
      COMPREPLY=("git")
    else
      _subt_help
    fi

  # we have completed the first and second tokens. i.e. we have a subcommand
  elif [ $COMP_CWORD = 2 ]; then
    if [ $prev = "git" ]; then

      if [[ $curr =~ ^(i|in|inf|info)$ ]] ; then  # TODO: better regex match, leading characters (for example)
        COMPREPLY=("info")

      elif [[ $curr =~ ^(s|st|sta|stat|statu|status)$ ]] ; then
        COMPREPLY=("status")

      elif [[ $curr =~ ^(ch|chec|check|checko|checkou|checkout)$ ]] ; then
        COMPREPLY=("checkout")

      elif [[ $curr =~ ^(cl|cle|clea|clean)$ ]] ; then
        COMPREPLY=("clean")

      elif [[ $curr =~ ^(r|re|res|rese|reset)$ ]] ; then
        COMPREPLY=("reset")

      elif [[ $curr =~ ^(p|pu|pus|push)$ ]] ; then
        COMPREPLY=("push")

      else  # nothing matched, display usage
        _git_help
      fi
    elif [ $prev = "deploy" ]; then
      # todo: check current token, then apply completion. otherwise show help...
      _deploy_help
    else
      _subt_help
    fi

  # we were given a subcommand, show the usage message for subcommands
  elif [ $COMP_CWORD = 3 ]; then

    if [ $prev = "info" ]; then
      if [[ $curr =~ ^(-b)$ ]] ; then
        COMPREPLY=("-b")

      elif [[ $curr =~ ^(-c)$ ]] ; then
        COMPREPLY=("-c")

      elif [[ $curr =~ ^(-p)$ ]] ; then
        COMPREPLY=("-p")

      elif [[ $curr =~ ^(-s)$ ]] ; then
        COMPREPLY=("-s")

      elif [[ $curr =~ ^(-ug|-ugv)$ ]] ; then
        COMPREPLY=("-ugv")

      elif [[ $curr =~ ^(-ua|-uav)$ ]] ; then
        COMPREPLY=("-uav")

      else
        _git_info_help
      fi
    fi

  fi
}