#!/usr/bin/env bash
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/hooks/.header.bash"
. "$SUBT_PATH/operations/bin/hooks/.help.bash"

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
  __clone_help
  exit_success
fi

# TODO: loop through all given repos....
__inrepo=""
chk_flag -b $@ || chk_flag basestation $@ ||  [ -z "$1" ] && __inrepo="basestation"
__reset $__inrepo

exit_success
