#!/usr/bin/env bash
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/git_hooks/.header.bash"

# //////////////////////////////////////////////////////////////////////////////
# @brief: script main entrypoint
# //////////////////////////////////////////////////////////////////////////////
larger_text "== SubT Git Status =="

##
# displays the 'git status' of a submodule
##
function list() {
  local submodule=$(realpath --relative-to="$SUBT_PATH" "$(pwd)")
  local commit_hash=$(git rev-parse --verify HEAD)
  local branch=$(git rev-parse --abbrev-ref HEAD)
  local url=$(git config --get remote.origin.url)
  # print the output column value
  printf "%-50s | %-30s | %-30s | %-30s \n"  "$submodule" "$branch" "$commit_hash" "$url"
}

# function tree_traverse() {}

function flat_traverse() {
  local interrepo=$1
  pushd "$SUBT_PATH/$interrepo"
  text "\n$FG_LCYAN|--$interrepo--|"
  traverse_submodules list
  popd
}

# check all the specific inter-repo flags
if chk_flag -bs $@ || chk_flag -a $@; then
  flat_traverse "basestation"
fi

if chk_flag -cm $@ || chk_flag -a $@; then
  flat_traverse "common"
fi

if chk_flag -sim $@ || chk_flag -a $@; then
  flat_traverse "simulation"
fi

if chk_flag -ugv $@ || chk_flag -a $@; then
  flat_traverse "ugv"
fi

if chk_flag -uav $@ || chk_flag -a $@; then
  flat_traverse "uav"
fi

