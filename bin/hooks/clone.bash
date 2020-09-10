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

# TODO: loop through all given repos....
# __inrepo=""
# chk_flag -b $@ || chk_flag basestation $@ ||  [ -z "$1" ] && __inrepo="basestation"
# __clone $__inrepo
# 
# exit_success

_str="robots.ugv.ugv1.docker.shell"
_target="robots"

# bash does not support pcre natively

# echo "str: $_str"
# echo "target: $target"

# get prefix
_suffix=$(echo "$_str" | grep -oP "(?<=$_target).*")
# echo "suffix is: $_suffix"
_nprefix=$(echo "$_suffix" | grep -oP "^([^\.]+)")
# echo "next prefix is: $_nprefix"
echo "----------------------"

function _test() {

  _target=""
  _match=""
  _regex="(?<=$_target).*"
  echo "target: $_target"

  for deploy in "${_GL_DEPLOYER_CMDS[@]}"; do
    echo "deploy: $deploy"

    # if [[ -z "$_target" ]]; then
    #   _regex="(?<=$_target).*"
    # else
    #   _regex="(?<=$_target\.).*"
    # fi

    # get the suffix match, i.e. find which full deployer command matches the given target token
    # _suffix=$(echo "$deploy" | grep -oP "$_regex")
    _suffix=$(echo "$deploy" | perl -pe "$_regex")
    # no match found, continue the iteration.
    [[ -z "$_suffix" ]] && continue

    # found matching deployer command, get the next prefix
    _prefix=$(echo "$_suffix" | grep -oP "^([^\.]+)")

    echo "suffix is: $_suffix"
    echo "prefix is: $_prefix"
    echo

    # if [[ -z "$_target" ]]; then
    #   _prefix="$_prefix"
    # else
    #   _prefix="$_target.$_prefix"
    # fi
    _match="$_match $_target$_prefix"
  done
  echo "match is: $_match"
}

_result=$(perl match.pl)
echo "result from perl: $_result"