#!/usr/bin/env bash
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/git_hooks/.header.bash"

# globals (printf colors)
GL_RED=$(tput setaf 1)
GL_BLUE=$(tput setaf 4)
GL_NORMAL=$(tput sgr0)

# //////////////////////////////////////////////////////////////////////////////
# @brief displays the 'git status' of a submodule
# //////////////////////////////////////////////////////////////////////////////
function info() {
  # get the git info
  local submodule=$(realpath --relative-to="$SUBT_PATH" "$(pwd)")
  local commit_hash=$(git rev-parse --verify HEAD)
  local branch=$(git rev-parse --abbrev-ref HEAD)
  local url=$(git config --get remote.origin.url)
  local dirty=$(is_git_dirty)
  local untracked=$(num_git_untracked)
  local uncommitted=$(num_git_uncommited)
  local status=""

  # check if detached head
  if [[ "$branch" != "HEAD" ]]; then
    branch="$GL_BLUE$branch$GL_NORMAL"
  else
    branch="$GL_NORMAL-$GL_NORMAL"
  fi

  # check if git untracked
  [[ "$untracked" != "0" ]] && status=" $untracked untracked"
  # check if git status is dirty
  [[ "$dirty" = "*" ]] && status="$(git diff --shortstat), $untracked untracked"

  # column print git info
  printf "%-50s | %-30s | %-75s | %-30s | %-30s \n"  \
    "$submodule" \
    "$branch" \
    "$GL_RED$status$GL_NORMAL" \
    "$commit_hash" \
    "$url"
}

# //////////////////////////////////////////////////////////////////////////////
# @brief __traverse over all submodules in the intermediate repos
# //////////////////////////////////////////////////////////////////////////////
function __traverse() {
  local interrepo=$1
  pushd "$SUBT_PATH/$interrepo"
  # title
  text "\n$FG_LCYAN|--$interrepo--|"
  # info for intermediate repo
  info

  # git the dirty of inter-repo, pass that as an array to info fun
  # - if name matches submodule repo, then mark as uncommitted submodule (or 'new commits')
  # tab complete the argument options...
  # TODO: not submodule cloned...

  # info for module repo
  traverse_submodules info
  popd
}

# //////////////////////////////////////////////////////////////////////////////
# @brief: script main entrypoint
# //////////////////////////////////////////////////////////////////////////////
larger_text "== SubT Git Status =="

# check all the specific inter-repo flags
if chk_flag -bs $@ || [ -z "$1" ]; then
  __traverse "basestation"
fi

if chk_flag -cm $@ || [ -z "$1" ]; then
  __traverse "common"
fi

if chk_flag -per $@ || [ -z "$1" ]; then
  __traverse "perception"
fi

if chk_flag -sim $@ || [ -z "$1" ]; then
  __traverse "simulation"
fi

if chk_flag -ugv $@ || [ -z "$1" ]; then
  __traverse "ugv"
fi

if chk_flag -uav $@ || [ -z "$1" ]; then
  __traverse "uav"
fi

