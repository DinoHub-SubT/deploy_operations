#!/usr/bin/env bash
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/git_hooks/.header.bash"

# @brief display help usage message
__reset_help() {
  GL_TEXT_COLOR=$FG_LCYAN
  text
  text_color "usage: clone [<subcommand>] [<flag>] [<flag>] ... "
  text_color
  text_color "subcommands:"
  text_color "          : no subcommand will default to clone all submodules."
  text_color "reset     : resets the submodules to their detached HEAD as with intial clone,"
  text_color "rm        : removes all the submodules and intermediate level repos."
  text_color "clean     : cleans all the submodules from any uncommitted changes."
  text_color "branch    : creates a new branch or checks out an existing branch."
  text_color
  text_color "flags:"
  text_color "-b              : basestation intermediate level repo -> ~/deploy_ws/src/basestation"
  text_color "-c              : common intermediate level repo -> ~/deploy_ws/src/common"
  text_color "-p              : perception intermediate level repo -> ~/deploy_ws/src/perception"
  text_color "-s              : simulation intermediate level repo -> ~/deploy_ws/src/simulation"
  text_color "-ugv            : ugv intermediate level repo -> ~/deploy_ws/src/ugv"
  text_color "-ugv.slam       : ugv intermediate level repo -> ~/deploy_ws/src/ugv/slam"
  text_color "-ugv.hardware   : ugv intermediate level repo -> ~/deploy_ws/src/ugv/hardware"
  text_color "-uav            : uav intermediate level repo -> ~/deploy_ws/src/uav/"
  text_color "-uav.slam       : uav intermediate level repo -> ~/deploy_ws/src/uav/slam"
  text_color "-uav.hardware   : uav intermediate level repo -> ~/deploy_ws/src/uav/hardware"
  text_color "-h, help        : View help usage message for each sub command."
  text_color
  text_color "For more help, please see the README.md or wiki."
  GL_TEXT_COLOR=$FG_DEFAULT
}

__clean() {
  pushd "$SUBT_PATH/"
  ./deployer -s git.clean.$1
  popd
}

__clone() {
  pushd "$SUBT_PATH/"
  ./deployer -s git.clone.$1
  popd
}

__rm() {
  pushd "$SUBT_PATH/"
  ./deployer -s git.rm.$1
  popd
}

__reset() {
  pushd "$SUBT_PATH/"
  ./deployer -s git.rm.$1
  ./deployer -s git.init.$1
  ./deployer -s git.clone.$1
  popd
}


# //////////////////////////////////////////////////////////////////////////////
#
# //////////////////////////////////////////////////////////////////////////////

##
if chk_flag --help $@ || chk_flag help $@ || chk_flag -h $@ || chk_flag -help $@; then
  __reset_help
  exit_success
fi

result=$(__regex_expand "ug" "basestation ugv uav")
echo "matchers are: $result"


# declare the intermediate repo variable
__inrepo=""

# chk_flag -b $@ || [ -z "$1" ] && __inrepo="basestation"

# check the type of subcommand
# if chk_flag rm $@; then
#   __rm $__inrepo
# elif chk_flag reset $@; then
#   __reset $__inrepo
# elif chk_flag clean $@; then
#   __clean $__inrepo
# else
#   __clone $__inrepo
# fi

# 
# if chk_flag -c $@ || [ -z "$1" ]; then
#   __traverse "common"
# fi
# 
# if chk_flag -p $@ || [ -z "$1" ]; then
#   __traverse "perception"
# fi
# 
# if chk_flag -s $@ || [ -z "$1" ]; then
#   __traverse "simulation"
# fi
# 
# if chk_flag -ugv $@ || [ -z "$1" ]; then
#   __traverse "ugv"
# fi
# 
# if chk_flag -uav $@ || [ -z "$1" ]; then
#   __traverse "uav"
# fi
# 
# if chk_flag -slam $@ || [ -z "$1" ]; then
#   __traverse "uav"
# fi

# TODO: sync the top level branch...
#       - have it remove all intermediate level branches too...

exit_success
