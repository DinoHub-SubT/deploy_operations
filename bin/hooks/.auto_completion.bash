#!/usr/bin/env bash

# load header helper functions
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/hooks/.header.bash"
. "$SUBT_PATH/operations/bin/hooks/.help.bash"

# import all the submodules

# globals
GL_GIT_HOOKS_DIR=$SUBT_PATH/operations/bin/hooks/

# @brief match a set of arguments (i.e subcommand flags) to the input token
__regex_expand() {
  local _regex="^.*$1.*$"  # match from start -> end, match any char unlimited times
  local _flags=($2)        # given subcommand flags to match
  local _match=""
  # regex match with all flags
  for _flag in "${_flags[@]}"; do
    [[ $_flag =~ $_regex ]] && _match="$_flag $_match"
  done
  echo $_match
}

# @brief evaluate the regex match as an autocomplete
__regex_eval() {
  local _str=$1 _funptr=$2
  local _result=$(__regex_expand $_str "$(${_funptr})" )
  [ ! -z "$_result" ] && COMPREPLY=( $( compgen -W "$_result" -- "$_str" ) ) && return 0
  return 1
}

# temporary, hard-coded, autocompete for deployer commands
__ac_deploy() {
  local _curr=$1
  # UGV1.ppc.docker
  if contains "$_curr" "robots.ugv.ugv1.ppc.docker"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv1_ppc_docker_flags && __ac_deploy_robots_ugv_comp_help

  # UGV1.ppc.catkin
  elif contains "$_curr" "robots.ugv.ugv1.ppc.catkin"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv1_ppc_catkin_flags && __ac_deploy_robots_ugv_comp_help

  # UGV1.ppc, UGV1.nuc, UGV1.xavier,
  elif contains "$_curr" "robots.ugv.ugv1.ppc"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv1_ppc_flags && __ac_deploy_robots_ugv_comp_help

  elif contains "$_curr" "robots.ugv.ugv1.nuc"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv1_nuc_flags && __ac_deploy_robots_ugv_comp_help

  elif contains "$_curr" "robots.ugv.ugv1.xavier"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv1_xavier_flags && __ac_deploy_robots_ugv_comp_help

  elif contains "$_curr" "robots.ugv.ugv1"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv1_flags && __ac_deploy_robots_ugv_comp_help

  # UGV2
  elif contains "$_curr" "robots.ugv.ugv2.ppc"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv2_ppc_flags && __ac_deploy_robots_ugv_comp_help

  elif contains "$_curr" "robots.ugv.ugv2.nuc"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv1_nuc_flags && __ac_deploy_robots_ugv_comp_help

  elif contains "$_curr" "robots.ugv.ugv2.xavier"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv2_xavier_flags && __ac_deploy_robots_ugv_comp_help

  elif contains "$_curr" "robots.ugv.ugv2"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv2_flags && __ac_deploy_robots_ugv_comp_help


  elif contains "$_curr" "robots.ugv.ugv3"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv3_flags && __ac_deploy_robots_ugv_comp_help

  elif contains "$_curr" "robots.ugv"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv_flags && __ac_deploy_robots_ugv_help

  elif contains "$_curr" "robots"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv_uav_flags && __ac_deploy_robots_ugv_uav_help

  else
    # check previous, then call the correct help...
    ! __regex_eval $_curr __ac_deploy_flags && __ac_deploy_help
  fi
}

# //////////////////////////////////////////////////////////////////////////////
# @brief tab autocompletion for subt subcommands
# //////////////////////////////////////////////////////////////////////////////
_ac_subt_completion() {

  COMPREPLY=() # initialize completion result array.

  # Retrieve the current command-line token, i.e., the one on which completion is being invoked.
  local _curr=${COMP_WORDS[COMP_CWORD]}
  local _prev=${COMP_WORDS[COMP_CWORD-1]}

  ## given one autocomplete token -> 'subt'
  if [ $COMP_CWORD = 1 ]; then
    # evaluate the matcher for 'subt'
    ! __regex_eval $_curr __ac_subt_flags && __ac_subt_help

  ## given two autocomplete tokens -> 'subt git', ...
  elif [ $COMP_CWORD = 2 ]; then

    # evaluate the matcher -> 'subt git'
    if chk_flag git "${COMP_WORDS[@]}"; then
      ! __regex_eval $_curr __ac_git_flags && __ac_git_help

    # this is going to be so ugly... -- need to make a regex for partial prefix match...
    # evaluate the matcher -> 'subt deployer'
    elif chk_flag deployer "${COMP_WORDS[@]}"; then
      __ac_deploy $_curr

    # evaluate the matcher -> 'subt cloud'
    elif chk_flag cloud "${COMP_WORDS[@]}"; then
      ! __regex_eval $_curr __ac_cloud_flags && __ac_cloud_help

    # evaluate the matcher -> 'subt tools'
    elif chk_flag tools "${COMP_WORDS[@]}"; then
      ! __regex_eval $_curr __ac_tools_flags && __ac_tools_help

    else  # 'subt <subcommand>' match failed, then show display usage help.
      __ac_subt_help
    fi

  ## given three autocomplete tokens -> 'subt git status', ...
  elif [ $COMP_CWORD -ge 3 ]; then
    
    # TODO: cleanup -- check_ONLY not with ! check

    # autocomplete subcommand -> 'git'
    if chk_flag git "${COMP_WORDS[@]}"          \
      && ! chk_flag deployer "${COMP_WORDS[@]}" \
      && ! chk_flag cloud "${COMP_WORDS[@]}" \
      && ! chk_flag tools "${COMP_WORDS[@]}" ; then

      # evaluate the matcher -> 'subt git status'
      if chk_flag status "${COMP_WORDS[@]}"; then
        ! __regex_eval $_curr __ac_git_status_flags && __ac_git_status_help

      # evaluate the matcher -> 'subt git sync'
      elif chk_flag sync "${COMP_WORDS[@]}"; then
        ! __regex_eval $_curr __ac_git_sync_flags && __ac_git_sync_help

      # evaluate the matcher -> 'subt git clone'
      elif chk_flag clone "${COMP_WORDS[@]}"; then
        ! __regex_eval $_curr __ac_git_clone_flags && __ac_git_clone_help

      # evaluate the matcher -> 'subt git reset'
      elif chk_flag reset "${COMP_WORDS[@]}"; then
        ! __regex_eval $_curr __ac_git_clone_flags && __ac_git_clone_help

      # evaluate the matcher -> 'subt git clean'
      elif chk_flag clean "${COMP_WORDS[@]}"; then
        ! __regex_eval $_curr __ac_git_clone_flags && __ac_git_clone_help

      # evaluate the matcher -> 'subt git rm'
      elif chk_flag rm "${COMP_WORDS[@]}"; then
        ! __regex_eval $_curr __ac_git_clone_flags && __ac_git_clone_help

      else  # 'subt <subcommand>' match failed, then show display usage help.
        __ac_git_help
      fi

    # autocomplete subcommand -> 'deployer'
    elif chk_flag deployer "${COMP_WORDS[@]}" \
      && ! chk_flag git "${COMP_WORDS[@]}"    \
      && ! chk_flag cloud "${COMP_WORDS[@]}" \
      && ! chk_flag tools "${COMP_WORDS[@]}" ; then

      __ac_deploy $_curr

    # autocomplete subcommand -> 'cloud'
    elif chk_flag cloud "${COMP_WORDS[@]}" \
      && ! chk_flag git "${COMP_WORDS[@]}" \
      && ! chk_flag deployer "${COMP_WORDS[@]}" \
      && ! chk_flag tools "${COMP_WORDS[@]}" ; then

      # evaluate the matcher -> 'subt cloud ansible'
      if chk_flag ansible "${COMP_WORDS[@]}"; then
        ! __regex_eval $_curr __ac_cloud_ansible_flags && __ac_cloud_ansible_help

      # evaluate the matcher -> 'subt cloud ansible'
      elif chk_flag terraform "${COMP_WORDS[@]}"; then
        ! __regex_eval $_curr __ac_cloud_terra_flags && __ac_cloud_terra_help
      fi


    else

      if chk_flag deployer "${COMP_WORDS[@]}" \
        && ! chk_flag git "${COMP_WORDS[@]}"    \
        && ! chk_flag cloud "${COMP_WORDS[@]}" \
        && ! chk_flag tools "${COMP_WORDS[@]}" ; then
        __ac_deploy
      fi

    fi
  fi
}
