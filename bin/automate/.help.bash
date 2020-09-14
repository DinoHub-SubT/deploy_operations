#!/usr/bin/env bash

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt'
# //////////////////////////////////////////////////////////////////////////////
__ac_subt_help() {
  local usage=(
    "About: 1... main menu: operations tools"
    "About: 2... tab complete each subcommand to see what tools are available for each group."
    "About: 3... == You Options Are =="
    "deployer   : deployer, your access point to 'deploy' subt to the localhost, azure or robots systems."
    "git        : git helper scripts, for maintaining subt deploy three level repo."
    "cloud      : cloud tools for creating & managing azure cloud setups."
    "tools      : general helper tools."
    "update     : update the deployer operations scripts."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt git'
# //////////////////////////////////////////////////////////////////////////////
__ac_git_help() {
  local usage=(
    "About: 1... git helper scripts, for automating git commands over the 3-level deploy repo structure."
    "About: 2... example, 'status' runs a 'git fetch -all' for all the submodules, for a given intermediate meta repo."
    "About: 3... tab complete each subcommand to see what arguments are available."
    "About: 4... == You Options Are =="
    "status   : show the general git info for every submodule (all three levels)."
    "sync     : fetch & syncs the local branches with the remote branches (all three levels)."
    "add      : adds the uncommitted changes for intermediate repos."
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
  text_color "add      : adds the uncommitted changes for intermediate repos."
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

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt cloud'
# //////////////////////////////////////////////////////////////////////////////
__ac_cloud_help() {
  local usage=(
    "About: 1... cloud scripts for automating Azure cloud system setup."
    "About: 2... tab complete each subcommand to see what arguments are available."
    "About: 3... == You Options Are =="
    "ansible      : ansible scripts, for installing base system packages on the Azure VMs."
    "terraform    : terraform scripts, for creating & starting the Azure VMs and other Azure resources."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt tools'
# //////////////////////////////////////////////////////////////////////////////
__ac_tools_help() {
  local usage=(
    "About: 1... general helper scripts, can be used for robots or azure setups."
    "About: 2... tab complete each subcommand to see what arguments are available."
    "About: 3... Please add 'help' for each command to see more details on usage information."
    "About: 3... == You Options Are =="
    "shh          : shows which configured ssh connections are are available to connect."
    "teamviewer   : shows which teamviewer connections are are available to connect."
    "rdp          : establish a rdp (rdesktop) session with an Azure VM."
    "snapshot     : creates a snapshot logfile of deploy repo submodules."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt git status'
# //////////////////////////////////////////////////////////////////////////////
__ac_git_status_help() {
  local usage=(
    "About: 1... shows a short summary of its git status for all submodules."
    "About: 2... shows a short summary of 'dirty' submodules for any given meta repos."
    "About: 3... == You Options Are =="
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
__status_help() {
  GL_TEXT_COLOR=$FG_LCYAN
  text
  text_color "Usage: "
  text_color "      status [<flag>] [<flag>]"
  text_color
  text_color "flags:"
  text_color "basestation : basestation intermediate level repo -> ~/deploy_ws/src/basestation"
  text_color "common      : common intermediate level repo -> ~/deploy_ws/src/common"
  text_color "perception  : perception intermediate level repo -> ~/deploy_ws/src/perception"
  text_color "simuation   : simulation intermediate level repo -> ~/deploy_ws/src/simulation"
  text_color "ugv       : ugv intermediate level repo -> ~/deploy_ws/src/ugv"
  text_color "uav       : uav intermediate level repo -> ~/deploy_ws/src/uav"
  text_color "help            : view help usage message"
  text_color
  text_color "About:"
  text_color "      show the general git info for every submodule (all three levels)."
  text_color
  GL_TEXT_COLOR=$FG_DEFAULT
}

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt git sync'
# //////////////////////////////////////////////////////////////////////////////
__ac_git_sync_help() {
  local usage=(
    "About: 1... fetch all & resets all local branches to its respective origin remote branch commit, for all submodules."
    "About: 2... == You Options Are =="
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
__sync_help() {
  GL_TEXT_COLOR=$FG_LCYAN
  text
  text_color "usage: sync [<flag>] [<flag>] "
  text_color
  text_color "flags:"
  text_color "deploy      : top level repo -> ~/deploy_ws/src/"
  text_color "basestation : basestation intermediate level repo -> ~/deploy_ws/src/basestation"
  text_color "common      : common intermediate level repo -> ~/deploy_ws/src/common"
  text_color "perception  : perception intermediate level repo -> ~/deploy_ws/src/perception"
  text_color "simuation   : simulation intermediate level repo -> ~/deploy_ws/src/simulation"
  text_color "launch      : central intermediate level repo -> ~/deploy_ws/src/subt_launch"
  text_color "ugv       : ugv intermediate level repo -> ~/deploy_ws/src/ugv"
  text_color "uav       : uav intermediate level repo -> ~/deploy_ws/src/uav"
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


# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt add sync'
# //////////////////////////////////////////////////////////////////////////////
__ac_git_add_help() {
  local usage=(
    "About: 1... fetch all & resets all local branches to its respective origin remote branch commit, for all submodules."
    "About: 2... == You Options Are =="
    "deploy       : top level repo -> ~/deploy_ws/src/"
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
__add_help() {
  GL_TEXT_COLOR=$FG_LCYAN
  text
  text_color "usage: add [<flag>] [<flag>] "
  text_color
  text_color "flags:"
  text_color "deploy      : top level repo -> ~/deploy_ws/src/"
  text_color "basestation : basestation intermediate level repo -> ~/deploy_ws/src/basestation"
  text_color "common      : common intermediate level repo -> ~/deploy_ws/src/common"
  text_color "perception  : perception intermediate level repo -> ~/deploy_ws/src/perception"
  text_color "simuation   : simulation intermediate level repo -> ~/deploy_ws/src/simulation"
  text_color "ugv       : ugv intermediate level repo -> ~/deploy_ws/src/ugv"
  text_color "uav       : uav intermediate level repo -> ~/deploy_ws/src/uav"
  text_color "help            : view help usage message."
  text_color
  text_color "About:"
  text_color
  text_color "automated adds, commits, pushes the intermediate repos."
  text_color
  text_color "For more help, please see the README.md or wiki."
  GL_TEXT_COLOR=$FG_DEFAULT
}

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt git clone'
# //////////////////////////////////////////////////////////////////////////////
__ac_git_clone_help() {
  local usage=(
    "About: 1... clones all the submodules inside the intermediate level repo."
    "About: 2... == You Options Are =="
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
    "help               : view help usage message."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}
__clone_help() {
  GL_TEXT_COLOR=$FG_LCYAN
  text
  text_color "usage: clone [<subcommand>] [<flag>] [<flag>] ... "
  text_color
  text_color "flags:"
  text_color "basestation     : basestation intermediate level repo -> ~/deploy_ws/src/basestation"
  text_color "common          : common intermediate level repo -> ~/deploy_ws/src/common"
  text_color "perception      : perception intermediate level repo -> ~/deploy_ws/src/perception"
  text_color "simulation      : simulation intermediate level repo -> ~/deploy_ws/src/simulation"
  text_color "ugv             : ugv intermediate level repo -> ~/deploy_ws/src/ugv"
  text_color "ugv.slam        : ugv intermediate level repo -> ~/deploy_ws/src/ugv/slam"
  text_color "ugv.hardware    : ugv intermediate level repo -> ~/deploy_ws/src/ugv/hardware"
  text_color "uav             : uav intermediate level repo -> ~/deploy_ws/src/uav/"
  text_color "uav.slam        : uav intermediate level repo -> ~/deploy_ws/src/uav/slam"
  text_color "uav.hardware    : uav intermediate level repo -> ~/deploy_ws/src/uav/hardware"
  text_color "help            : view help usage message."
  text_color
  text_color "For more help, please see the README.md or wiki."
  GL_TEXT_COLOR=$FG_DEFAULT
}

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt git reset'
# //////////////////////////////////////////////////////////////////////////////
__ac_git_reset_help() {
  local usage=(
    "About: 1... resets all the submodules inside the intermediate level repo to their DETACHED HEAD."
    "About: 2... == You Options Are =="
    "basestation        : basestation intermediate level repo -> ~/deploy_ws/src/basestation"
    "common             : common intermediate level repo -> ~/deploy_ws/src/common"
    "perception         : perception intermediate level repo -> ~/deploy_ws/src/perception"
    "simulation         : simulation intermediate level repo -> ~/deploy_ws/src/simulation"
    "subt_launch        : central launch intermediate level repo -> ~/deploy_ws/src/subt_launch"
    "ugv                : all of ugv -> ~/deploy_ws/src/ugv"
    "ugv.base           : ugv base only intermediate level repo -> ~/deploy_ws/src/ugv/ppc & ~/deploy_ws/src/ugv/nuc"
    "ugv.slam           : ugv slam only intermediate level repo -> ~/deploy_ws/src/ugv/slam"
    "ugv.hardware       : ugv hardware intermediate level repo  -> ~/deploy_ws/src/ugv/hardware"
    "uav                : all of ugv -> ~/deploy_ws/src/ugv"
    "uav.core           : uav base only intermediate level repo -> ~/deploy_ws/src/uav/core"
    "uav.slam           : uav slam only intermediate level repo -> ~/deploy_ws/src/uav/slam"
    "uav.hardware       : uav hardware intermediate level repo  -> ~/deploy_ws/src/uav/hardware"
    "help               : view help usage message."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}
__reset_help() {
  GL_TEXT_COLOR=$FG_LCYAN
  text
  text_color "usage: reset [<subcommand>] [<flag>] [<flag>] ... "
  text_color
  text_color "flags:"
  text_color "basestation     : basestation intermediate level repo -> ~/deploy_ws/src/basestation"
  text_color "common          : common intermediate level repo -> ~/deploy_ws/src/common"
  text_color "perception      : perception intermediate level repo -> ~/deploy_ws/src/perception"
  text_color "simulation      : simulation intermediate level repo -> ~/deploy_ws/src/simulation"
  text_color "subt_launch     : central launch intermediate level repo -> ~/deploy_ws/src/subt_launch"
  text_color "ugv             : ugv intermediate level repo -> ~/deploy_ws/src/ugv"
  text_color "ugv.slam        : ugv intermediate level repo -> ~/deploy_ws/src/ugv/slam"
  text_color "ugv.hardware    : ugv intermediate level repo -> ~/deploy_ws/src/ugv/hardware"
  text_color "uav             : uav intermediate level repo -> ~/deploy_ws/src/uav/"
  text_color "uav.slam        : uav intermediate level repo -> ~/deploy_ws/src/uav/slam"
  text_color "uav.hardware    : uav intermediate level repo -> ~/deploy_ws/src/uav/hardware"
  text_color "help            : view help usage message."
  text_color
  text_color "For more help, please see the README.md or wiki."
  GL_TEXT_COLOR=$FG_DEFAULT
}

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt git clean'
# //////////////////////////////////////////////////////////////////////////////
__ac_git_clean_help() {
  local usage=(
    "About: 1... cleans all the submodules inside the intermediate level repo to their DETACHED HEAD."
    "About: 2... == You Options Are =="
    "basestation        : basestation intermediate level repo -> ~/deploy_ws/src/basestation"
    "common             : common intermediate level repo -> ~/deploy_ws/src/common"
    "perception         : perception intermediate level repo -> ~/deploy_ws/src/perception"
    "simulation         : simulation intermediate level repo -> ~/deploy_ws/src/simulation"
    "subt_launch        : central launch intermediate level repo -> ~/deploy_ws/src/subt_launch"
    "ugv                : all of ugv -> ~/deploy_ws/src/ugv"
    "uav                : all of ugv -> ~/deploy_ws/src/ugv"
    "help               : view help usage message."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}
__clean_help() {
  GL_TEXT_COLOR=$FG_LCYAN
  text
  text_color "usage: clean [<subcommand>] [<flag>] [<flag>] ... "
  text_color
  text_color "flags:"
  text_color "basestation     : basestation intermediate level repo -> ~/deploy_ws/src/basestation"
  text_color "common          : common intermediate level repo -> ~/deploy_ws/src/common"
  text_color "perception      : perception intermediate level repo -> ~/deploy_ws/src/perception"
  text_color "simulation      : simulation intermediate level repo -> ~/deploy_ws/src/simulation"
  text_color "subt_launch     : central launch intermediate level repo -> ~/deploy_ws/src/subt_launch"
  text_color "ugv             : ugv intermediate level repo -> ~/deploy_ws/src/ugv"
  text_color "uav             : uav intermediate level repo -> ~/deploy_ws/src/uav/"
  text_color "-h, help        : View help usage message for each sub command."
  text_color
  text_color "For more help, please see the README.md or wiki."
  GL_TEXT_COLOR=$FG_DEFAULT
}

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt git rm'
# //////////////////////////////////////////////////////////////////////////////
__ac_git_rm_help() {
  local usage=(
    "About: 1... removes all the submodules inside the intermediate level repo to their DETACHED HEAD."
    "About: 2... == You Options Are =="
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
    "help               : view help usage message."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}
__rm_help() {
  GL_TEXT_COLOR=$FG_LCYAN
  text
  text_color "usage: rm [<subcommand>] [<flag>] [<flag>] ... "
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

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt cloud ansible'
# //////////////////////////////////////////////////////////////////////////////
__ac_cloud_ansible_flags() {
  echo "-az -r -l -b -p"
}
__ac_cloud_ansible_help() {
  local usage=(
    "About: 1... Usage: < system_name > < playbook > [ optional flags ] "
    "About: 2... if running on your laptop, use the options:  localhost install-localhost.yaml"
    "About: 3... if running on basestation, use the options:  basestation install-localhost.yaml"
    "About: 4... if you wish to not run anything, but want to view information about the different ansible installs, just use the 'optional flags'"
    "About: 5... == Optional Flags =="
    "-az  : Show the available azure ansible system names."
    "-r   : Show the available robot ansible system names."
    "-l   : Show the available localhost system names."
    "-b   : Show the available playbooks."
    "-p   : Provide system password, to allow sudo installs."
    "help : view help usage message for subcommand."
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
    "About: 1... Please add 'help' for each command to see more details on usage information."
    "About: 2... == You Options Are =="
    "init   : initializes subt's terraform setup with the correct tfstate file"
    "cert   : creates the vpn ca and user certifcations for creating an Azure VPN connection"
    "plan   : terraform plan (dry run) args are passed to terraform."
    "apply  : terraform apply in the azurebooks/subt directory, args are passed to terraform."
    "mkvpn  : creates the vpn needed to access azure (both through terraform and with network manager"
    "rmvpn  : removes the vpn needed to access azure (both through terraform and with network manager."
    "start  : starts any or all VMs on Azure"
    "stop   : stops any or all VMs on Azure"
    "help   : view help usage message for subcommand."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt deployer'
# //////////////////////////////////////////////////////////////////////////////
__ac_deploy_help() {
  local usage=(
    "About: 1... deploys subt to a remote or local system."
    "About: 2... deployment operations include: "
    "About: 3...    - pulling docker images from azure registries or local basestation registries"
    "About: 4...    - building docker images"
    "About: 5...    - starting, stopping, removing docker containers"
    "About: 6...    - transferring code to remote system (azure or robots)"
    "About: 7...    - catkin build & clean the different (already pre-configured) catkin profile workspaces."
    "About: 8... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)"
    "About: 9... == You Options Are =="
    "azure      : deploys subt on azure cloud."
    "robots     : deploys subt on harware ugv & uav robots."
    "local      : deploys subt on your localhost."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

__ac_deploy_submenu_help() {
  local _prev=$1
  local _result=$(perl $GL_GIT_AUTOMATE_DIR/acmatcher.pl "deployer_help" "$_prev")
  # split resulting string based on newlines
  SAVEIFS=$IFS        # save current IFS, so we can revert back to it
  IFS=$'\n'           # change IFS to split on new lines
  _result=($_result)
  IFS=$SAVEIFS        # revert to old IFS

  local IFS=$'\n' # split output of compgen below by lines, not spaces
  _result[0]="$(printf '%*s' "-$COLUMNS"  "${_result[0]}")"
  COMPREPLY=("${_result[@]}")
}

