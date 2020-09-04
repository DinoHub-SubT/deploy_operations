#!/usr/bin/env bash

# load header helper functions
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/git_hooks/.header.bash"

# globals
GL_GIT_HOOKS_DIR=$SUBT_PATH/operations/bin/git_hooks/

# example:
# list all submodules
# git subt list -- lists all modules

# show the git subt status, no recursive?
# git subt status -ug -ua -c -l -s -d -b
# git subt status -ugv -uav -cmn -launch -sim -docker -basestation
# git subt status -r -ug # recursive
# git subt status -m base_node

# git subt fetch -r -ug -ua -c -l -s -d -b
# git subt fetch -r -ug -ua -c -l -s -d -b

# syncs all local branches with remote. i.e. does a hard reset
# git subt sync -r -ugv

# ??
# git subt pull -ugv
# git subt push -ugv

# git subt add /path/to/submodule

# git subt checkout -b branch name

# //////////////////////////////////////////////////////////////////////////////
# @brief evaluate which subcommand to switch and execute
# //////////////////////////////////////////////////////////////////////////////
subcommand_switch() {
  GL_TEXT_COLOR=$FG_LCYAN
  text_color "== Deployer Git Hooks =="

  # git status
  if chk_flag info $@; then
    shift # shift the 'info' subcommand
    ($GL_GIT_HOOKS_DIR/info.bash $@)

  # git fetch
  elif chk_flag fetch $@; then
    . $GL_GIT_HOOKS_DIR/fetch.bash
  fi

  GL_TEXT_COLOR=$FG_DEFAULT
}

# //////////////////////////////////////////////////////////////////////////////
# @brief 'git subt' wrapper entrypoint
# //////////////////////////////////////////////////////////////////////////////
git() {

  # execute actual git command (filter any 'git subt' subcommands)
  # if ! chk_flag info $@; then
  if ! check_nth_flag 1 "subt" "$@"; then

    # TODO: make this installed by everyone via ansible
    # git sync  -- add this to git config using ansible?
    # make sure to only do a git sync, when doing git status, not other commands?
    # have a docker image pull check too...

    command git "$@"

  # execute 'git subt' subcommand
  elif check_nth_flag 1 "subt" "$@"; then
    shift # shift the subt flag

    if chk_flag --help $@ || chk_flag help $@ || chk_flag -h $@; then
      GL_TEXT_COLOR=$FG_LCYAN
      text
      title "Usage: $(basename $0) subt [command] [<arg>] "
      text_color "Commands:"
      text_color "      status: show the working tree status for all level git repos."
      text_color "      fetch:  download objects and refs for all level git repos."
      text_color "      checkout: TODO"
      text_color "      sync: TODO"
      text_color "      pull: TODO"
      text_color "      push: TODO"
      text_color "      -h, --help, help  : shows usage help for 'git subt'"
      text_color "For more help, please see the README.md or wiki."
      GL_TEXT_COLOR=$FG_DEFAULT
      return 0
    fi

    # execute git subt main entrypoint
    subcommand_switch $@

    # shift the subt arguments (they are standard for all 'git subt' subcommands)
    # for arg do
    #   shift
    #   chk_eq $arg "-a" || chk_eq $arg "-bs" || chk_eq $arg "-cm" || \
    #     chk_eq $arg "-sim" || chk_eq $arg "-uav" || chk_eq $arg "-ugv" \
    #     && continue
    #   set -- "$@" "$arg"
    # done
  fi

}
