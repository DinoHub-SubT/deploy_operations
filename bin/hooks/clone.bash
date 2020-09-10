#!/usr/bin/env bash
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/hooks/.header.bash"
. "$SUBT_PATH/operations/bin/hooks/.help.bash"

__clone() {
  pushd "$SUBT_PATH/"
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



arr=("subt" "foo" "somethingz")
contains2 "deploy foo" "${arr[@]}"