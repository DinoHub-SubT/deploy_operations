#!/usr/bin/env bash

# load header helper functions
. "$SUBT_PATH/operations/bin/.header.bash"
. "$SUBT_PATH/operations/bin/hooks/.header.bash"
. "$SUBT_PATH/operations/bin/hooks/.help.bash"

# globals
GL_GIT_HOOKS_DIR=$SUBT_PATH/operations/bin/hooks/

# @brief find the the current auto-complete token matches
__matcher() {
  local _matcher_t=$1 _curr=$2
  [[ "$_curr" == "" ]] && return 1  # if not given a current token, then show the help usage message
  # evaluate the matcher
  local _result=$(perl $GL_GIT_HOOKS_DIR/dmatch.pl "$_matcher_t" "$_curr")
  [ ! -z "$_result" ] && COMPREPLY=( $( compgen -W "$_result" -- "$_str" ) ) && return 0
  return 1
}

# TEMPORARY!!, VERY ugly, really bad, hard-coded, autocompete for deployer commands. will fix later. will fix.
__ac_deploy() {
  local _curr=$1
  local _prev=$2

  ### azure ###
  if contains "$_curr" "azure.ugv.ugv1.docker"; then
    ! __regex_eval $_curr __ac_deploy_azure_ugv1_docker_flags && __ac_deploy_general_help

  elif contains "$_curr" "azure.ugv.ugv2.docker"; then
    ! __regex_eval $_curr __ac_deploy_azure_ugv2_docker_flags && __ac_deploy_general_help

  elif contains "$_curr" "azure.ugv.ugv3.docker"; then
    ! __regex_eval $_curr __ac_deploy_azure_ugv3_docker_flags && __ac_deploy_general_help

  elif contains "$_curr" "azure.ugv.ugv1.catkin"; then
    ! __regex_eval $_curr __ac_deploy_azure_ugv1_catkin_flags && __ac_deploy_general_help

  elif contains "$_curr" "azure.ugv.ugv2.catkin"; then
    ! __regex_eval $_curr __ac_deploy_azure_ugv2_catkin_flags && __ac_deploy_general_help

  elif contains "$_curr" "azure.ugv.ugv3.catkin"; then
    ! __regex_eval $_curr __ac_deploy_azure_ugv3_catkin_flags && __ac_deploy_general_help

  elif contains "$_curr" "azure.ugv.ugv1"; then
    ! __regex_eval $_curr __ac_deploy_azure_ugv1_flags && __ac_deploy_general_help

  elif contains "$_curr" "azure.ugv.ugv2"; then
    ! __regex_eval $_curr __ac_deploy_azure_ugv2_flags && __ac_deploy_general_help

  elif contains "$_curr" "azure.ugv.ugv3"; then
    ! __regex_eval $_curr __ac_deploy_azure_ugv3_flags && __ac_deploy_general_help

  elif contains "$_curr" "azure.ugv"; then
    ! __regex_eval $_curr __ac_deploy_azure_ugv_flags && __ac_deploy_general_help

  elif contains "$_curr" "azure.uav"; then
    ! __regex_eval $_curr __ac_deploy_azure_uav_flags && __ac_deploy_general_help

  elif contains "$_curr" "azure"; then
    ! __regex_eval $_curr __ac_deploy_azure_ugv_uav_flags && __ac_deploy_general_help

  ### robots ###

  # UGV1
  elif contains "$_curr" "robots.ugv.ugv1.ppc.docker"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv1_ppc_docker_flags && __ac_deploy_general_help

  elif contains "$_curr" "robots.ugv.ugv1.ppc.catkin"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv1_ppc_catkin_flags && __ac_deploy_general_help

  elif contains "$_curr" "robots.ugv.ugv1.ppc"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv1_ppc_flags && __ac_deploy_general_help

  elif contains "$_curr" "robots.ugv.ugv1.nuc"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv1_nuc_flags && __ac_deploy_general_help

  elif contains "$_curr" "robots.ugv.ugv1.xavier"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv1_xavier_flags && __ac_deploy_general_help

  elif contains "$_curr" "robots.ugv.ugv1"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv1_flags && __ac_deploy_general_help

  # UGV2
  elif contains "$_curr" "robots.ugv.ugv2.ppc.docker"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv2_ppc_docker_flags && __ac_deploy_general_help

  elif contains "$_curr" "robots.ugv.ugv2.ppc.catkin"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv2_ppc_catkin_flags && __ac_deploy_general_help

  elif contains "$_curr" "robots.ugv.ugv2.ppc"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv2_ppc_flags && __ac_deploy_general_help

  elif contains "$_curr" "robots.ugv.ugv2.nuc"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv2_nuc_flags && __ac_deploy_general_help

  elif contains "$_curr" "robots.ugv.ugv2.xavier"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv2_xavier_flags && __ac_deploy_general_help

  elif contains "$_curr" "robots.ugv.ugv2"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv2_flags && __ac_deploy_general_help

  # UGV3
  elif contains "$_curr" "robots.ugv.ugv3.ppc.docker"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv3_ppc_docker_flags && __ac_deploy_general_help

  elif contains "$_curr" "robots.ugv.ugv3.ppc.catkin"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv3_ppc_catkin_flags && __ac_deploy_general_help

  elif contains "$_curr" "robots.ugv.ugv3.ppc"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv3_ppc_flags && __ac_deploy_general_help

  elif contains "$_curr" "robots.ugv.ugv3.nuc"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv3_nuc_flags && __ac_deploy_general_help

  elif contains "$_curr" "robots.ugv.ugv3.xavier"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv3_xavier_flags && __ac_deploy_general_help

  elif contains "$_curr" "robots.ugv.ugv3"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv3_flags && __ac_deploy_general_help

  elif contains "$_curr" "robots.ugv.ugv3"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv3_flags && __ac_deploy_general_help

  elif contains "$_curr" "robots.ugv"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv_flags && __ac_deploy_robots_ugv_help

  elif contains "$_curr" "robots"; then
    ! __regex_eval $_curr __ac_deploy_robots_ugv_uav_flags && __ac_deploy_robots_ugv_uav_help

  else
    # show help messages
    if contains "$_prev" "docker" && ! contains "$_prev" "docker." ; then
      if contains "$_prev" "robots"; then
        __ac_deploy_robots_ugv_docker_help
      else
        __ac_deploy_azure_ugv_docker_help
      fi

    elif contains "$_prev" "catkin" && ! contains "$_prev" "catkin." ; then
      __ac_deploy_robots_ugv_catkin_help

    elif contains "$_prev" "ugv1.ppc" && ! contains "$_prev" "ugv1.ppc." \
      || contains "$_prev" "ugv2.ppc" && ! contains "$_prev" "ugv2.ppc." \
      || contains "$_prev" "ugv3.ppc" && ! contains "$_prev" "ugv3.ppc." \
      || contains "$_prev" "ugv1.nuc" && ! contains "$_prev" "ugv1.nuc." \
      || contains "$_prev" "ugv2.nuc" && ! contains "$_prev" "ugv2.nuc." \
      || contains "$_prev" "ugv3.nuc" && ! contains "$_prev" "ugv3.nuc." \
      || contains "$_prev" "ugv1.xavier" && ! contains "$_prev" "ugv1.xavier." \
      || contains "$_prev" "ugv2.xavier" && ! contains "$_prev" "ugv2.xavier." \
      || contains "$_prev" "ugv3.xavier" && ! contains "$_prev" "ugv3.xavier."; then

      __ac_deploy_robots_ugv_cmd_help

    elif contains "$_prev" "azure.ugv.ugv1" && ! contains "$_prev" "azure.ugv.ugv1." \
      || contains "$_prev" "azure.ugv.ugv2" && ! contains "$_prev" "azure.ugv.ugv2." \
      || contains "$_prev" "azure.ugv.ugv3" && ! contains "$_prev" "azure.ugv.ugv3."; then
      __ac_deploy_robots_ugv_cmd_help

    elif contains "$_prev" "robots.ugv.ugv1" && ! contains "$_prev" "robots.ugv.ugv1." \
      || contains "$_prev" "robots.ugv.ugv2" && ! contains "$_prev" "robots.ugv.ugv2." \
      || contains "$_prev" "robots.ugv.ugv3" && ! contains "$_prev" "robots.ugv.ugv3."; then
      __ac_deploy_robots_ugv_computer_help

    elif contains "$_prev" "ugv" && ! contains "$_prev" "ugv." ; then
      if contains "$_prev" "robots"; then
        __ac_deploy_robots_ugv_help
      else
        __ac_deploy_azure_ugv_help
      fi

    elif contains "$_prev" "robots" && ! contains "$_prev" "robots." ; then
      __ac_deploy_robots_ugv_uav_help

    elif contains "$_prev" "azure" && ! contains "$_prev" "azure." ; then
      __ac_deploy_azure_ugv_uav_help

    else
      ! __regex_eval $_curr __ac_deploy_flags && __ac_deploy_general_help
    fi
  fi
}

# //////////////////////////////////////////////////////////////////////////////
# @brief tab autocompletion for subt 'command center'
#   - three level menu of subcommands
# //////////////////////////////////////////////////////////////////////////////
_ac_subt_completion() {

  COMPREPLY=() # initialize completion result array.

  # Retrieve the current command-line token, i.e., the one on which completion is being invoked.
  local _curr=${COMP_WORDS[COMP_CWORD]}
  local _prev=${COMP_WORDS[COMP_CWORD-1]}

  # first level menu: 'subt'
  if [ $COMP_CWORD = 1 ]; then
    ! __matcher "subt" $_curr && __ac_subt_help

  # second level menu: 'subt <subcommand> '
  elif [ $COMP_CWORD = 2 ]; then
    if chk_flag git "${COMP_WORDS[@]}"; then
      ! __matcher "git" "$_curr" && __ac_git_help

    # cloud menu
    elif chk_flag cloud "${COMP_WORDS[@]}"; then
      ! __matcher "cloud" $_curr && __ac_cloud_help

    # tools menu
    elif chk_flag tools "${COMP_WORDS[@]}"; then
      ! __matcher "tools" $_curr && __ac_tools_help

    # deployer menu
    elif chk_flag deployer "${COMP_WORDS[@]}"; then
      ! __matcher "deployer" $_curr && __ac_git_help

    # 'subt <subcommand>' match failed -- show display usage help menu
    else
      __ac_subt_help
    fi

  # third level menu: 'subt <subcommand> <subcommand> '
  else

    if chk_flag git "${COMP_WORDS[@]}"; then

      if chk_flag status "${COMP_WORDS[@]}"; then
        ! __matcher "git_status" "$_curr" && __ac_git_status_help
      fi

    fi


# 
#     # autocomplete subcommand -> 'git'
#     if chk_flag git "${COMP_WORDS[@]}" then
# 
#       # evaluate the matcher -> 'subt git status'
#       if chk_flag status "${COMP_WORDS[@]}"; then
#         ! __regex_eval $_curr __ac_git_status_flags && __ac_git_status_help
# 
#       # evaluate the matcher -> 'subt git sync'
#       elif chk_flag sync "${COMP_WORDS[@]}"; then
#         ! __regex_eval $_curr __ac_git_sync_flags && __ac_git_sync_help
# 
#       # evaluate the matcher -> 'subt git clone'
#       elif chk_flag clone "${COMP_WORDS[@]}"; then
#         ! __regex_eval $_curr __ac_git_clone_flags && __ac_git_clone_help
# 
#       # evaluate the matcher -> 'subt git reset'
#       elif chk_flag reset "${COMP_WORDS[@]}"; then
#         ! __regex_eval $_curr __ac_git_clone_flags && __ac_git_clone_help
# 
#       # evaluate the matcher -> 'subt git clean'
#       elif chk_flag clean "${COMP_WORDS[@]}"; then
#         ! __regex_eval $_curr __ac_git_clone_flags && __ac_git_clone_help
# 
#       # evaluate the matcher -> 'subt git rm'
#       elif chk_flag rm "${COMP_WORDS[@]}"; then
#         ! __regex_eval $_curr __ac_git_clone_flags && __ac_git_clone_help
# 
#       else  # 'subt <subcommand>' match failed, then show display usage help.
#         __ac_git_help
#       fi
# 
#     # autocomplete subcommand -> 'deployer'
#     elif chk_flag deployer "${COMP_WORDS[@]}"; then
#       __ac_matcher $_curr "deployer" && __ac_git_help
# 
#     # autocomplete subcommand -> 'cloud'
#     elif chk_flag cloud "${COMP_WORDS[@]}"  ; then
# 
#       # evaluate the matcher -> 'subt cloud ansible'
#       if chk_flag ansible "${COMP_WORDS[@]}"; then
#         ! __regex_eval $_curr __ac_cloud_ansible_flags && __ac_cloud_ansible_help
# 
#       # evaluate the matcher -> 'subt cloud ansible'
#       elif chk_flag terraform "${COMP_WORDS[@]}"; then
#         ! __regex_eval $_curr __ac_cloud_terra_flags && __ac_cloud_terra_help
#       fi
# 
#     fi
  fi
}
