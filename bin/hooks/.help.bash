#!/usr/bin/env bash

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt'
# //////////////////////////////////////////////////////////////////////////////
__ac_subt_flags() {
  echo "cloud deployer git tools update help"
}
__subt_help() {
  GL_TEXT_COLOR=$FG_LCYAN
  text
  text_color "usage: subt [command] [sub-command] [<arg>] "
  text_color
  text_color "commands:"
  text_color "deployer   : Deployer tool to setup localhost, azure or robots systems."
  text_color "git        : Helper git tools for maintaining subt deploy three level repo."
  text_color "cloud      : Cloud tools for creating & managing azure cloud setups."
  text_color "operations : Update the deployer operations scripts."
  text_color "help       : view help usage message."
  text_color "deploy [subcommand] [<arg>] "
  text_color "      -h, --help, help  : shows usage help for 'git subt'"
  text_color
  text_color "For more help, please see the README.md or wiki."
  GL_TEXT_COLOR=$FG_DEFAULT
}
__ac_subt_help() {
  local usage=(
    "deployer   : Deployer tool to setup localhost, azure or robots systems."
    "git        : Helper git tools for maintaining subt deploy three level repo."
    "cloud      : Cloud tools for creating & managing azure cloud setups."
    "tools      : Helpful general tools."
    "update     : Update the deployer operations scripts."
    "help       : view help usage message."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}


# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt git'
# //////////////////////////////////////////////////////////////////////////////
__ac_git_flags(){
  echo "status sync clone rm reset clean pr help"
}
__git_help() {
  GL_TEXT_COLOR=$FG_LCYAN
  text
  text_color "usage: subt git [subcommand] "
  text_color
  text_color "flags:"
  text_color "status   : show the general git info for every submodule (all three levels)."
  text_color "sync     : fetch & syncs the local branches with the remote branches (all three levels)."
  text_color "clone    : clones or resets intermediate repo or submodules."
  text_color "clean    : clean an intermediate or submodule repo."
  # text_color "pr       : create a pull request for top & intermeidate repo branches."
  text_color "help     : view help usage message."
  text_color
  text_color "About:"
  text_color
  text_color "git helper functions for maintaining the three level deploy repo:"
  text_color
  text_color "  deploy [submodule]"
  text_color "    intermediate-dir [submodule]  (example: common) "
  text_color "        module-dir  [submodule]   (example: base_main_class)"
  text_color
  text_color "For more help, please see the README.md or wiki."
  GL_TEXT_COLOR=$FG_DEFAULT
}
__ac_git_help() {
  local usage=(
    "status   : show the general git info for every submodule (all three levels)."
    "sync     : fetch & syncs the local branches with the remote branches (all three levels)."
    "clone    : clones intermediate repo or submodules."
    "rm       : removes intermediate repo or submodules."
    "reset    : resets intermediate repo or submodules to their DETACHED HEAD state."
    "clean    : clean an intermediate or submodule repo ."
    # "pr       : Create a pull request for top & intermeidate repo branches."
    "help, -h : view help usage message."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt cloud'
# //////////////////////////////////////////////////////////////////////////////
__ac_cloud_flags() { # TODO: help
  echo "terraform ansible help"
}
__ac_cloud_help() {
  local usage=(
    "ansible      : ansible install base packages on the cloud vms."
    "terraform    : access terraform control tools, for creating VM cloud structure"
    "help, -h : View help usage message for each sub command."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt tools'
# //////////////////////////////////////////////////////////////////////////////
__ac_tools_flags(){ # TODO: help
  echo "ssh teamviewer rdp snapshot"
}
__ac_tools_help() {
  local usage=(
    "shh          : Shows which configured ssh connections are are available to connect."
    "teamviewer   : Shows which teamviewer connections are are available to connect."
    "rdp          : helper script to establish a rdp (rdesktop) session with an Azure VM."
    "snapshot     : creates a snapshot logfile of deploy repo submodules."
    "help, -h : View help usage message for each sub command."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt git status'
# //////////////////////////////////////////////////////////////////////////////
__ac_git_status_flags(){
  echo "basestation common perception simulation ugv uav help"
}
__status_help() {
  GL_TEXT_COLOR=$FG_LCYAN
  text
  text_color "usage: status [<flag>] [<flag>] "
  text_color
  text_color "flags:"
  text_color "-b, basestation : basestation intermediate level repo -> ~/deploy_ws/src/basestation"
  text_color "-c, common      : common intermediate level repo -> ~/deploy_ws/src/common"
  text_color "-p, perception  : perception intermediate level repo -> ~/deploy_ws/src/perception"
  text_color "-s, simuation   : simulation intermediate level repo -> ~/deploy_ws/src/simulation"
  text_color "-ugv, ugv       : ugv intermediate level repo -> ~/deploy_ws/src/ugv"
  text_color "-uav, uav       : uav intermediate level repo -> ~/deploy_ws/src/uav"
  text_color "help            : view help usage message."
  text_color
  text_color "About:"
  text_color
  text_color "show the general git info for every submodule (all three levels)."
  text_color
  text_color "For more help, please see the README.md or wiki."
  GL_TEXT_COLOR=$FG_DEFAULT
}
__ac_git_status_help() {
  local usage=(
    "basestation  : basestation intermediate level repo -> ~/deploy_ws/src/basestation"
    "common       : common intermediate level repo -> ~/deploy_ws/src/common"
    "perception   : perception intermediate level repo -> ~/deploy_ws/src/perception"
    "simuation    : simulation intermediate level repo -> ~/deploy_ws/src/simulation"
    "ugv          : ugv intermediate level repo -> ~/deploy_ws/src/ugv"
    "uav          : uav intermediate level repo -> ~/deploy_ws/src/uav"
    "help         : view help usage message."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt git sync'
# //////////////////////////////////////////////////////////////////////////////
__ac_git_sync_flags(){
  echo "deploy basestation common perception simulation ugv uav launch help"
}
__sync_help() {
  GL_TEXT_COLOR=$FG_LCYAN
  text
  text_color "usage: sync [<flag>] [<flag>] "
  text_color
  text_color "flags:"
  text_color "-d, deploy      : top level repo -> ~/deploy_ws/src/"
  text_color "-b, basestation : basestation intermediate level repo -> ~/deploy_ws/src/basestation"
  text_color "-c, common      : common intermediate level repo -> ~/deploy_ws/src/common"
  text_color "-p, perception  : perception intermediate level repo -> ~/deploy_ws/src/perception"
  text_color "-s, simuation   : simulation intermediate level repo -> ~/deploy_ws/src/simulation"
  text_color "-l, launch      : central intermediate level repo -> ~/deploy_ws/src/subt_launch"
  text_color "-ugv, ugv       : ugv intermediate level repo -> ~/deploy_ws/src/ugv"
  text_color "-uav, uav       : uav intermediate level repo -> ~/deploy_ws/src/uav"
  text_color "-del            : delete any local branches not found on the origin remote."
  text_color "-hard           : sync the currently checkout branch."
  text_color "help            : view help usage message."
  text_color
  text_color "About:"
  text_color
  text_color "fetch & syncs the local branches with the remote branches (all three levels)."
  text_color
  text_color "For more help, please see the README.md or wiki."
  GL_TEXT_COLOR=$FG_DEFAULT
}
__ac_git_sync_help() {
  local usage=(
    "deploy       : top level repo -> ~/deploy_ws/src/"
    "basestation  : basestation intermediate level repo -> ~/deploy_ws/src/basestation"
    "common       : common intermediate level repo -> ~/deploy_ws/src/common"
    "perception   : perception intermediate level repo -> ~/deploy_ws/src/perception"
    "simuation    : simulation intermediate level repo -> ~/deploy_ws/src/simulation"
    "launch       : central launch intermediate level repo -> ~/deploy_ws/src/subt_launch"
    "ugv          : ugv intermediate level repo -> ~/deploy_ws/src/ugv"
    "uav          : uav intermediate level repo -> ~/deploy_ws/src/uav"
    "-del         : delete any local branches not found on the origin remote."
    "-hard        : sync the currently checkout branch."
    "help         : view help usage message."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt git clone'
# //////////////////////////////////////////////////////////////////////////////
__ac_git_clone_flags(){
  echo "basestation common perception simulation ugv ugv.base ugv.hardware ugv.slam uav uav.core uav.slam uav.hardware help"
}
__clone_help() {
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
  text_color "-b, basestation : basestation intermediate level repo -> ~/deploy_ws/src/basestation"
  text_color "-c, common      : common intermediate level repo -> ~/deploy_ws/src/common"
  text_color "-p, perception  : perception intermediate level repo -> ~/deploy_ws/src/perception"
  text_color "-s, simulation  : simulation intermediate level repo -> ~/deploy_ws/src/simulation"
  text_color "-ugv, ugv       : ugv intermediate level repo -> ~/deploy_ws/src/ugv"
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
__ac_git_clone_help() {
  local usage=(
    "basestation        : basestation intermediate level repo -> ~/deploy_ws/src/basestation"
    "common             : common intermediate level repo -> ~/deploy_ws/src/common"
    "perception         : perception intermediate level repo -> ~/deploy_ws/src/perception"
    "simulation         : simulation intermediate level repo -> ~/deploy_ws/src/simulation"
    "ugv                : all of ugv -> ~/deploy_ws/src/ugv"
    "ugv.base           : ugv base only intermediate level repo -> ~/deploy_ws/src/ugv/ppc & ~/deploy_ws/src/ugv/nuc"
    "ugv.slam           : ugv slam only intermediate level repo -> ~/deploy_ws/src/ugv/slam"
    "ugv.hardware       : ugv hardware intermediate level repo  -> ~/deploy_ws/src/ugv/hardware"
    "uav                : all of ugv -> ~/deploy_ws/src/ugv"
    "uav.core           : uav base only intermediate level repo -> ~/deploy_ws/src/uav/core"
    "uav.slam           : uav slam only intermediate level repo -> ~/deploy_ws/src/uav/slam"
    "uav.hardware       : uav hardware intermediate level repo  -> ~/deploy_ws/src/uav/hardware"
    "help         : view help usage message."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt cloud ansible'
# //////////////////////////////////////////////////////////////////////////////
__ac_cloud_ansible_flags() {
  echo "-az -r -l -b -p"
}
__ac_cloud_ansible_help() {
  local usage=(
    "-az : Show the available azure ansible system names."
    "-r  : Show the available robot ansible system names."
    "-l  : Show the available localhost system names."
    "-b  : Show the available playbooks."
    "-p  : Provide system password, to allow sudo installs."
    "help, -h : View help usage message for each sub command."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt cloud terraform'
# //////////////////////////////////////////////////////////////////////////////
__ac_cloud_terra_flags(){
  echo "init cert plan apply mkvpn rmvpn start stop"
}
__ac_cloud_terra_help() {
  local usage=(
    "init   : initializes subt's terraform setup with the correct tfstate file"
    "cert   : creates the vpn ca and user certifcations for creating an Azure VPN connection"
    "plan   : terraform plan (dry run) args are passed to terraform."
    "apply  : terraform apply in the azurebooks/subt directory, args are passed to terraform."
    "mkvpn  : creates the vpn needed to access azure (both through terraform and with network manager"
    "rmvpn  : removes the vpn needed to access azure (both through terraform and with network manager."
    "start  : starts any or all VMs on Azure"
    "stop   : stops any or all VMs on Azure"
    "--help : View help usage message for each sub command."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt deployer'
# //////////////////////////////////////////////////////////////////////////////
__ac_deploy_flags() {
  echo "robots. robots azure help"
}
__deploy_help() {
  GL_TEXT_COLOR=$FG_LCYAN
  text
  text_color "usage: subt deploy [sub-command] [<arg>] "
  text_color
  text_color "subcommands:"
  text_color "azure     : deployment subt on azure VMs."
  text_color "local     : deployment subt on localhost system."
  text_color "robots    : deployment subt on robots (ugv, uav, basestation)."
  text_color "help      : view help usage message."
  text_color
  text_color "For more help, please see the README.md or wiki."
  GL_TEXT_COLOR=$FG_DEFAULT
}

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt deployer robots'
# //////////////////////////////////////////////////////////////////////////////
# below is going to be ugly. for now is what is done. need to cleanup...

# robots.*
__ac_deploy_robots_ugv_uav_flags() {
  echo "robots.ugv. robots.uav. help"
}

# azure.*
__ac_deploy_azure_ugv_uav_flags() {
  echo "azure.ugv. azure.uav. azure.basestation azure.perception help"
}

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt deployer azure.*'
# //////////////////////////////////////////////////////////////////////////////
__ac_deploy_azure_ugv_flags() {
  echo "azure.ugv.ugv1. azure.ugv.ugv2. azure.ugv.ugv3. help"
}
__ac_deploy_azure_uav_flags() {
  echo "azure.uav.uav1. azure.uav.uav2. azure.uav.uav3. azure.uav.uav4. help"
}
__ac_deploy_azure_ugv1_flags() {
  echo "azure.ugv.ugv1.transfer.to azure.ugv.ugv1.skel_t.to azure.ugv.ugv1.docker. azure.ugv.ugv1.catkin."
}
__ac_deploy_azure_ugv2_flags() {
  echo "azure.ugv.ugv2.transfer.to azure.ugv.ugv2.skel_t.to azure.ugv.ugv2.docker. azure.ugv.ugv2.catkin."
}
__ac_deploy_azure_ugv3_flags() {
  echo "azure.ugv.ugv3.transfer.to azure.ugv.ugv3.skel_t.to azure.ugv.ugv3.docker. azure.ugv.ugv3.catkin."
}

# subt deployer azure.ugv1.*
__ac_deploy_azure_ugv1_docker_flags() {
  echo "azure.ugv.ugv1.docker.shell \
        azure.ugv.ugv1.docker.stop \
        azure.ugv.ugv1.docker.rm \
        azure.ugv.ugv1.docker.registry.pull"
}
__ac_deploy_azure_ugv1_catkin_flags() {
  echo "azure.ugv.ugv1.catkin.build azure.ugv.ugv1.catkin.clean "
}

# subt deployer azure.ugv2.*
__ac_deploy_azure_ugv2_docker_flags() {
  echo "azure.ugv.ugv2.docker.shell \
        azure.ugv.ugv2.docker.stop \
        azure.ugv.ugv2.docker.rm \
        azure.ugv.ugv2.docker.registry.pull"
}
__ac_deploy_azure_ugv2_catkin_flags() {
  echo "azure.ugv.ugv2.catkin.build azure.ugv.ugv2.catkin.clean "
}

# subt deployer azure.ugv3.*
__ac_deploy_azure_ugv3_docker_flags() {
  echo "azure.ugv.ugv3.docker.shell \
        azure.ugv.ugv3.docker.stop \
        azure.ugv.ugv3.docker.rm \
        azure.ugv.ugv3.docker.registry.pull"
}
__ac_deploy_azure_ugv3_catkin_flags() {
  echo "azure.ugv.ugv3.catkin.build azure.ugv.ugv3.catkin.clean "
}

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt deployer robots.ugv*'
# //////////////////////////////////////////////////////////////////////////////

# robot.ugv*
__ac_deploy_robots_ugv_flags() {
  echo "robots.ugv.ugv1. robots.ugv.ugv2. robots.ugv.ugv3. help"
}

# robot.*.ppc , robot.*.nuc , robot.*.xavier
__ac_deploy_robots_ugv1_flags() {
  echo "robots.ugv.ugv1.ppc. robots.ugv.ugv1.nuc. robots.ugv.ugv1.xavier. help"
}
__ac_deploy_robots_ugv2_flags() {
  echo "robots.ugv.ugv2.ppc. robots.ugv.ugv2.nuc. robots.ugv.ugv2.xavier. help"
}
__ac_deploy_robots_ugv3_flags() {
  echo "robots.ugv.ugv3.ppc. robots.ugv.ugv3.nuc. robots.ugv.ugv3.xavier. help"
}

# robot.ugv1.ppc commands
__ac_deploy_robots_ugv1_ppc_flags() {
  echo "robots.ugv.ugv1.ppc.transfer.to robots.ugv.ugv1.ppc.skel_t.to robots.ugv.ugv1.ppc.docker. robots.ugv.ugv1.ppc.catkin."
}
__ac_deploy_robots_ugv1_ppc_docker_flags() {
  echo "robots.ugv.ugv1.ppc.docker.shell \
        robots.ugv.ugv1.ppc.docker.stop \
        robots.ugv.ugv1.ppc.docker.rm \
        robots.ugv.ugv1.ppc.docker.registry.azure.pull \
        robots.ugv.ugv1.ppc.docker.registry.basestation.pull"
}
__ac_deploy_robots_ugv1_ppc_catkin_flags() {
  echo "robots.ugv.ugv1.ppc.catkin.build robots.ugv.ugv1.ppc.catkin.clean "
}

# robot.ugv1.nuc commands
__ac_deploy_robots_ugv1_nuc_flags() {
  echo "robots.ugv.ugv1.nuc.transfer.to robots.ugv.ugv1.nuc.skel_t.to robots.ugv.ugv1.nuc.docker. robots.ugv.ugv1.nuc.catkin."
}
__ac_deploy_robots_ugv1_nuc_docker_flags() {
  echo "robots.ugv.ugv1.nuc.docker.shell \
        robots.ugv.ugv1.nuc.docker.stop \
        robots.ugv.ugv1.nuc.docker.rm \
        robots.ugv.ugv1.nuc.docker.registry.azure.pull \
        robots.ugv.ugv1.nuc.docker.registry.basestation.pull"
}
__ac_deploy_robots_ugv1_nuc_catkin_flags() {
  echo "robots.ugv.ugv1.nuc.catkin.build robots.ugv.ugv1.nuc.catkin.clean "
}

# robot.ugv1.xavier commands
__ac_deploy_robots_ugv1_xavier_flags() {
  echo "robots.ugv.ugv1.xavier.transfer.to robots.ugv.ugv1.xavier.skel_t.to robots.ugv.ugv1.xavier.docker. robots.ugv.ugv1.xavier.catkin."
}
__ac_deploy_robots_ugv1_xavier_docker_flags() {
  echo "robots.ugv.ugv1.xavier.docker.shell \
        robots.ugv.ugv1.xavier.docker.stop \
        robots.ugv.ugv1.xavier.docker.rm \
        robots.ugv.ugv1.xavier.docker.registry.azure.pull \
        robots.ugv.ugv1.xavier.docker.registry.basestation.pull"
}
__ac_deploy_robots_ugv1_xavier_catkin_flags() {
  echo "robots.ugv.ugv1.xavier.catkin.build robots.ugv.ugv1.xavier.catkin.clean "
}

### robots.ugv2 ###

# robot.ugv2.ppc commands
__ac_deploy_robots_ugv2_ppc_flags() {
  echo "robots.ugv.ugv2.ppc.transfer.to robots.ugv.ugv2.ppc.skel_t.to robots.ugv.ugv2.ppc.docker. robots.ugv.ugv2.ppc.catkin."
}
__ac_deploy_robots_ugv2_ppc_docker_flags() {
  echo "robots.ugv.ugv2.ppc.docker.shell \
        robots.ugv.ugv2.ppc.docker.stop \
        robots.ugv.ugv2.ppc.docker.rm \
        robots.ugv.ugv2.ppc.docker.registry.azure.pull \
        robots.ugv.ugv2.ppc.docker.registry.basestation.pull"
}
__ac_deploy_robots_ugv2_ppc_catkin_flags() {
  echo "robots.ugv.ugv2.ppc.catkin.build robots.ugv.ugv2.ppc.catkin.clean "
}

# robot.ugv2.nuc commands
__ac_deploy_robots_ugv2_nuc_flags() {
  echo "robots.ugv.ugv2.nuc.transfer.to robots.ugv.ugv2.nuc.skel_t.to robots.ugv.ugv2.nuc.docker. robots.ugv.ugv2.nuc.catkin."
}
__ac_deploy_robots_ugv2_nuc_docker_flags() {
  echo "robots.ugv.ugv2.nuc.docker.shell \
        robots.ugv.ugv2.nuc.docker.stop \
        robots.ugv.ugv2.nuc.docker.rm \
        robots.ugv.ugv2.nuc.docker.registry.azure.pull \
        robots.ugv.ugv2.nuc.docker.registry.basestation.pull"
}
__ac_deploy_robots_ugv2_nuc_catkin_flags() {
  echo "robots.ugv.ugv2.nuc.catkin.build robots.ugv.ugv2.nuc.catkin.clean "
}

# robot.ugv2.xavier commands
__ac_deploy_robots_ugv2_xavier_flags() {
  echo "robots.ugv.ugv2.xavier.transfer.to robots.ugv.ugv2.xavier.skel_t.to robots.ugv.ugv2.xavier.docker. robots.ugv.ugv2.xavier.catkin."
}
__ac_deploy_robots_ugv2_xavier_docker_flags() {
  echo "robots.ugv.ugv2.xavier.docker.shell \
        robots.ugv.ugv2.xavier.docker.stop \
        robots.ugv.ugv2.xavier.docker.rm \
        robots.ugv.ugv2.xavier.docker.registry.azure.pull \
        robots.ugv.ugv2.xavier.docker.registry.basestation.pull"
}
__ac_deploy_robots_ugv2_xavier_catkin_flags() {
  echo "robots.ugv.ugv2.xavier.catkin.build robots.ugv.ugv2.xavier.catkin.clean "
}

### robots.ugv3 ###

# robot.ugv3.ppc commands
__ac_deploy_robots_ugv3_ppc_flags() {
  echo "robots.ugv.ugv3.ppc.transfer.to robots.ugv.ugv3.ppc.skel_t.to robots.ugv.ugv3.ppc.docker. robots.ugv.ugv3.ppc.catkin."
}
__ac_deploy_robots_ugv3_ppc_docker_flags() {
  echo "robots.ugv.ugv3.ppc.docker.shell \
        robots.ugv.ugv3.ppc.docker.stop \
        robots.ugv.ugv3.ppc.docker.rm \
        robots.ugv.ugv3.ppc.docker.registry.azure.pull \
        robots.ugv.ugv3.ppc.docker.registry.basestation.pull"
}
__ac_deploy_robots_ugv3_ppc_catkin_flags() {
  echo "robots.ugv.ugv3.ppc.catkin.build robots.ugv.ugv3.ppc.catkin.clean "
}

# robot.ugv3.nuc commands
__ac_deploy_robots_ugv3_nuc_flags() {
  echo "robots.ugv.ugv3.nuc.transfer.to robots.ugv.ugv3.nuc.skel_t.to robots.ugv.ugv3.nuc.docker. robots.ugv.ugv3.nuc.catkin."
}
__ac_deploy_robots_ugv3_nuc_docker_flags() {
  echo "robots.ugv.ugv3.nuc.docker.shell \
        robots.ugv.ugv3.nuc.docker.stop \
        robots.ugv.ugv3.nuc.docker.rm \
        robots.ugv.ugv3.nuc.docker.registry.azure.pull \
        robots.ugv.ugv3.nuc.docker.registry.basestation.pull"
}
__ac_deploy_robots_ugv3_nuc_catkin_flags() {
  echo "robots.ugv.ugv3.nuc.catkin.build robots.ugv.ugv3.nuc.catkin.clean "
}

# robot.ugv3.xavier commands
__ac_deploy_robots_ugv3_xavier_flags() {
  echo "robots.ugv.ugv3.xavier.transfer.to robots.ugv.ugv3.xavier.skel_t.to robots.ugv.ugv3.xavier.docker. robots.ugv.ugv3.xavier.catkin."
}
__ac_deploy_robots_ugv3_xavier_docker_flags() {
  echo "robots.ugv.ugv3.xavier.docker.shell \
        robots.ugv.ugv3.xavier.docker.stop \
        robots.ugv.ugv3.xavier.docker.rm \
        robots.ugv.ugv3.xavier.docker.registry.azure.pull \
        robots.ugv.ugv3.xavier.docker.registry.basestation.pull"
}
__ac_deploy_robots_ugv3_xavier_catkin_flags() {
  echo "robots.ugv.ugv3.xavier.catkin.build robots.ugv.ugv3.xavier.catkin.clean "
}

# //////////////////////////////////////////////////////////////////////////////
# deployer ugv help
# //////////////////////////////////////////////////////////////////////////////
__ac_deploy_general_help() {
  local usage=(
    "azure    : deployment subt on azure VMs."
    "local    : deployment subt on localhost system."
    "robots   : deployment subt on robots (ugv, uav, basestation)."
    # "-p       : preview (dry-run) the deployer commands to be run on the system."
    # "-v       : show the verbose deployer command exact steps to be run on the system"
    "help, -h : View help usage message for each sub command."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}") 
}

__ac_deploy_robots_ugv_uav_help() {
  local usage=(
    "basestation  : deployment subt on basestation (expand to see details)."
    "ugv          : deployment subt on ugv hardware robots (expand to see details)."
    "uav          : deployment subt on uav hardware robots (expand to see details)."
    "help         : view help usage message."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}
__ac_deploy_robots_ugv_help() {
  local usage=(
    "ugv1       : deployment subt on ugv1 robot (expand to see details)."
    "ugv2       : deployment subt on ugv2 robot (expand to see details)."
    "ugv3       : deployment subt on ugv3 robot (expand to see details)."
    "help       : view help usage message."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}
__ac_deploy_robots_ugv_computer_help() {
  local usage=(
    "ppc       : ppc robot computer commands (expand to see details)."
    "nuc       : nuc robot computer commands (expand to see details)."
    "xavier    : xavier robot computer commands (expand to see details)."
    "help      : view help usage message."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}
__ac_deploy_robots_ugv_cmd_help() {
  local usage=(
    "transfer.to  : transfers code from localhost to ugv system."
    "skel_t.to    : transfers code (slim & faster -- no .git) from localhost to ugv system."
    "docker       : automated docker setup for robot (expand to see details)"
    "catkin       : automated catkin builder for all workspaces (expand to see details)."
    "help         : view help usage message."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}
__ac_deploy_robots_ugv_docker_help() {
  local usage=(
    "docker.shell                     : starts the docker container on the remote ugv robot computer."
    "docker.rm                        : removes the docker container on the remote ugv robot computer."
    "docker.stop                      : stops the docker container on the remote ugv robot computer."
    "docker.registry.azure.pull       : pulls docker images from the azure registry to the robot computer (needs internet)."
    "docker.registry.basestation.pull : pulls docker images from the basestation registry to the robot computer."
    "help                             : view help usage message."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}
__ac_deploy_robots_ugv_catkin_help() {
  local usage=(
    "catkin.build                     : catkin build (catkin profile workspace already setup)."
    "catkin.clean                     : catkin clean (catkin profile workspace already setup)."
    "help                             : view help usage message."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

__ac_deploy_azure_ugv_docker_help() {
  local usage=(
    "docker.shell                     : starts the docker container on the remote ugv VM computer."
    "docker.rm                        : removes the docker container on the remote ugv VM computer."
    "docker.stop                      : stops the docker container on the remote ugv VM computer."
    "docker.registry.pull             : pulls docker images from the azure registry to the VM computer (needs internet)."
    "help                             : view help usage message."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

__ac_deploy_azure_ugv_help() {
  local usage=(
    "ugv1       : deployment subt on ugv1 Azure VM (expand to see details)."
    "ugv2       : deployment subt on ugv2 Azure VM (expand to see details)."
    "ugv3       : deployment subt on ugv3 Azure VM (expand to see details)."
    "help       : view help usage message."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}
__ac_deploy_azure_ugv_uav_help() {
  local usage=(
    "ugv          : deployment subt ugv on azure VMs (expand to see details)."
    "uav          : deployment subt uav on azure VMs (expand to see details)."
    "basestation  : deployment subt basestation on azure VMs (expand to see details)."
    "perception   : deployment subt perception on azure VMs (expand to see details)."
    "help      : view help usage message."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

# //////////////////////////////////////////////////////////////////////////////
# deployer uav
# //////////////////////////////////////////////////////////////////////////////

# robot.UAVs
__ac_deploy_robots_uav_flags() {
  # echo "ugv ugv1 ugv1.ppc ugv1.nuc ugv1.xavier ugv2 ugv3 help"
  echo "robots.uav.ds1. robots.uav.ds2. robots.uav.ds3. robots.uav.ds4. help"
}
__ac_deploy_robots_uav_help() {
  local usage=(
    "ds1       : deployment subt on azure VMs."
    "ds2       : deployment subt on azure VMs."
    "ds3       : deployment subt on azure VMs."
    "ds4       : deployment subt on azure VMs."
    "help      : view help usage message."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}
