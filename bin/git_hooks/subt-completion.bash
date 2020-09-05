#!/usr/bin/env bash

# load header helper functions
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/git_hooks/.header.bash"

# import all the submodules

# globals
GL_GIT_HOOKS_DIR=$SUBT_PATH/operations/bin/git_hooks/

# @brief autocomplete usage message for subt command
__ac_subt() {
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
__ac_git() {
  local usage=(
    "info     : Show the general git info for every submodule (inter and lower)."
    "status   : Show the git status for every submodule (inter and lower)."
    "sync     : Fetchs & Syncs the local branches with the remote branches."
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

# @brief autocomplete usage message for 'subt deploy info' command
__ac_git_info() {
  local usage=(
    "-b       : Basestation intermediate -> ~/deploy_ws/src/basestation"
    "-c       : Common intermediate -> ~/deploy_ws/src/common"
    "-p       : Perception intermediate repo."
    "-s       : Simulation intermediate repo."
    "-ugv     : Ugv intermediate repo."
    "-uav     : Uav intermediate repo."
    "help     : View help usage message for each sub command."
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
    elif [[ $curr =~ ^(h|he|hel|help)$ ]] ; then
      COMPREPLY=("help")
    else
      __ac_subt
    fi

  # we have completed the first and second tokens. i.e. we have a subcommand
  elif [ $COMP_CWORD = 2 ]; then
    if [ $prev = "git" ]; then

      if [[ $curr =~ ^(i|in|inf|info)$ ]] ; then  # TODO: better regex match, leading characters (for example)
        COMPREPLY=("info")

      elif [[ $curr =~ ^(st|sta|stat|statu|status)$ ]] ; then
        COMPREPLY=("status")

      elif [[ $curr =~ ^(sy|syn|sync)$ ]] ; then
        COMPREPLY=("sync")

      elif [[ $curr =~ ^(ch|chec|check|checko|checkou|checkout)$ ]] ; then
        COMPREPLY=("checkout")

      elif [[ $curr =~ ^(cl|cle|clea|clean)$ ]] ; then
        COMPREPLY=("clean")

      elif [[ $curr =~ ^(r|re|res|rese|reset)$ ]] ; then
        COMPREPLY=("reset")

      elif [[ $curr =~ ^(p|pu|pus|push)$ ]] ; then
        COMPREPLY=("push")

      else  # nothing matched, display usage
        __ac_git
      fi
    elif [ $prev = "deploy" ]; then
      # todo: check current token, then apply completion. otherwise show help...
      __ac_deploy
    else
      __ac_subt
    fi

  # we were given a subcommand, show the usage message for subcommands
  elif [ $COMP_CWORD -ge 3 ]; then

    if [ $prev = "info" ]; then # cant be previous, must check a few previous until hit 'git'... to enable multiple params...
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

      elif [[ $curr =~ ^(-h|h|he|hel|help)$ ]] ; then
        COMPREPLY=("help")

      else
        __ac_git_info
      fi
    fi

  fi
}