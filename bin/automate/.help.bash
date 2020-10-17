#!/usr/bin/env bash

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt'
# //////////////////////////////////////////////////////////////////////////////
__ac_subt_help() {
  local usage=(
    "About: 01... SubT Tab Autocompleter: one stop access to all the operations tools. "
    "About: 02... "
    "About: 03... Autocomplete gives you access to all the operation scripts, all accessible in one place."
    "About: 04... You should be able to navigate all the subcommands & arguments, at all levels, using [TAB] "
    "About: 05... [TAB] will reveal the help, autocomplete the subcommands and autocomplete the optional arguments."
    "About: 06... Once you have autcompleted your subcommand, continue [TAB] to see the next level of subcommands."
    "About: 07... == Your Options Are =="
    "About: 08... "
    "deployer   : deployer, your access point to 'deploy' subt to the localhost, azure or robots systems."
    "git        : git helper scripts, for maintaining subt deploy three level repo."
    "cloud      : cloud tools for creating & managing azure cloud setups."
    "tools      : general helper tools."
    "update     : update the deployer operations scripts."
    "help       : view help usage message in more detail."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}
__subt_help() {
  GL_TEXT_COLOR=$FG_LCYAN
  text
  text_color "usage: subt [ subcommand ] < arg > < arg > "
  text_color
  text_color "deployer   : deployer, your access point to 'deploy' subt to the localhost, azure or robots systems."
  text_color "git        : git helper scripts, for maintaining subt deploy three level repo."
  text_color "cloud      : cloud tools for creating & managing azure cloud setups."
  text_color "tools      : general helper tools."
  text_color "update     : update the deployer operations scripts."
  text_color
  text_color " == About == "
  text_color "SubT Tab Autocompleter: one stop access to all the operations tools. "
  text_color " autocomplete gives you access to all the operation scripts, all accessible in one place."
  text_color " bug fixes & new operations tools will be added to autocompleter, so please keep watch on any new tools added."
  text_color
  text_color " == Navigation == "
  text_color "You should be able to navigate all the subcommands & arguments, at all levels, using [TAB] "
  text_color "[TAB] will reveal the help, autocomplete the subcommands and autocomplete the optional arguments."
  text_color "Once you have autcompleted your subcommand, continue [TAB] to see the next level of subcommands."
  text_color
  text_color "For more help, please see the README.md or wiki."
  GL_TEXT_COLOR=$FG_DEFAULT
}

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt git'
# //////////////////////////////////////////////////////////////////////////////
__ac_git_help() {
  local usage=(
    "About: 01... git helper scripts, for automating git commands over the 3-level deploy repo structure."
    "About: 02... example, 'status' runs a 'git fetch -all' for all the submodules, for a given intermediate meta repo."
    "About: 03... tab complete each subcommand to see what arguments are available."
    "About: 04... == Your Options Are =="
    "About: 05... "
    "status   : show the general git info for every submodule (all three levels)."
    "sync     : fetch & syncs the local branches with the remote branches (all three levels)."
    "add      : adds the uncommitted changes for intermediate repos."
    "clone    : clones intermediate repo or submodules."
    "rm       : removes intermediate repo or submodules."
    "reset    : resets intermediate repo or submodules to their DETACHED HEAD state."
    "clean    : clean an intermediate or submodule repo ."
    "pull     : pulls the submodules updates in the intermediate repos (equivalent to 'git submoudle update --init --recursive')."
    "help     : view help usage message."
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
  text_color "pull     : pulls (recursive) the submodules."
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
    "About: 01... cloud scripts for automating Azure cloud system setup."
    "About: 02...   - tab complete each subcommand to see what arguments are available."
    "About: 03... == Your Options Are =="
    "About: 04... "
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
    "About: 01... General helper scripts, can be used for robots or azure setups."
    "About: 02...   - tab complete each subcommand to see what arguments are available."
    "About: 03... - please add 'help' for each command to see details on additional arguments."
    "About: 04... == Your Options Are =="
    "About: 05... "
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
    "About: 01... Shows a short summary of its git status for all submodules."
    "About: 02...   - i.e. 'dirty' submodule status for any given meta repos."
    "About: 03... == Optional Flags =="
    "About: 04..."
    "About: 05...   -table        : show as table output"
    "About: 06...   -hash         : show 'hash' column in table output"
    "About: 07...   -url          : show 'url' column in table output"
    "About: 08..."
    "About: 09... == Your Options Are =="
    "About: 10... "
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
  text_color "ugv         : ugv intermediate level repo -> ~/deploy_ws/src/ugv"
  text_color "uav         : uav intermediate level repo -> ~/deploy_ws/src/uav"
  text_color "help        : view help usage message"
  text_color "-table      : show as table output"
  text_color "-hash       : show 'hash' column in table output"
  text_color "-url        : show 'url' column in table output"
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
    "About: 01... Fetch & resets all local branches to its respective origin remote branch commit for all submodules (recursive)."
    "About: 02... == Optional Flags =="
    "About: 03..."
    "About: 04...   -del         : delete any local branches not found on the origin remote."
    "About: 05...   -hard        : sync the current checked-out branch."
    "About: 06... == Your Options Are =="
    "About: 07... "
    "deploy       : top level repo -> ~/deploy_ws/src/"
    "basestation  : basestation intermediate level repo -> ~/deploy_ws/src/basestation"
    "common       : common intermediate level repo -> ~/deploy_ws/src/common"
    "perception   : perception intermediate level repo -> ~/deploy_ws/src/perception"
    "simuation    : simulation intermediate level repo -> ~/deploy_ws/src/simulation"
    "launch       : central launch intermediate level repo -> ~/deploy_ws/src/subt_launch"
    "ugv          : ugv intermediate level repo -> ~/deploy_ws/src/ugv"
    "uav          : uav intermediate level repo -> ~/deploy_ws/src/uav"
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
    "About: 01... Prepares the intermediate repo: adding the submodules to the intermediate repo's git index."
    "About: 02... == Your Options Are =="
    "About: 03... "
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
# @brief 'subt cloud ansible'
# //////////////////////////////////////////////////////////////////////////////
__ac_cloud_ansible_help() {
  local usage=(
    "About: 01... Usage: < system_name > < playbook > [ optional flags ] "
    "About: 02... if running on your laptop, use the options:  localhost install-localhost.yaml"
    "About: 03... if running on basestation, use the options:  basestation install-localhost.yaml"
    "About: 04... if you wish to not run anything, but want to view information about the different ansible installs, just use the 'optional flags'"
    "About: 05... == Optional Flags =="
    "About: 07...     -az  : Show the available azure ansible system names."
    "About: 08...     -r   : Show the available robot ansible system names."
    "About: 09...     -l   : Show the available localhost system names."
    "About: 10...     -b   : Show the available playbooks."
    "About: 11...     -p   : Provide system password, to allow sudo installs."
    "About: 12... == Your Options Are =="
    "About: 13... "
    "help : view help usage message for subcommand."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt cloud terraform'
# //////////////////////////////////////////////////////////////////////////////
__ac_cloud_terra_help() {
  local usage=(
    "About: 01... Terraform Control Scripts: automates terraform cli setup."
    "About: 02...   - please add 'help' for each command to see more details on usage information."
    "About: 03... == Your Options Are =="
    "About: 04... "
    "init     : initializes subt's terraform setup with the correct tfstate file"
    "cert     : creates the vpn ca and user certifcations for creating an Azure VPN connection"
    "plan     : terraform plan (dry run) args are passed to terraform."
    "apply    : terraform apply in the azurebooks/subt directory, args are passed to terraform."
    "mkvpn    : creates the vpn needed to access azure (both through terraform and with network manager"
    "rmvpn    : removes the vpn needed to access azure (both through terraform and with network manager."
    "start    : starts any or all VMs on Azure"
    "stop     : stops any or all VMs on Azure"
    "destroy  : destroys all Azure resources"
    "monitor  : monitor utils for Azure resources"
    "env      : install your user's terraform bash or zsh environment variables."
    "help     : view help usage message for subcommand."
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
    "About: 01... deploys subt to a remote or local system."
    "About: 02... operations include: "
    "About: 03...    - pulling docker images from azure registries or local basestation registries"
    "About: 04...    - building docker images"
    "About: 05...    - starting, stopping, removing docker containers"
    "About: 06...    - transferring code to remote system (azure or robots)"
    "About: 07...    - catkin build & clean the different (already pre-configured) catkin profile workspaces."
    "About: 08... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU ADD THE NEXT OPTION (press backspace)"
    "About: 09... == Your Options Are =="
    "About: 10... "
    "azure      : deploys subt on azure cloud."
    "robots     : deploys subt on harware ugv & uav robots."
    "local      : deploys subt on your localhost."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

# TODO: make below only 1 function....

__ac_deploy_submenu_help() {
  local _prev=$1
  local _result=$(perl $GL_CMPL_DIR/cmpl.pl "deployer_help" "$_prev")
  # split resulting string based on newlines
  SAVEIFS=$IFS        # save current IFS, so we can revert back to it
  IFS=$'\n'           # change IFS to split on new lines
  _result=($_result)
  IFS=$SAVEIFS        # revert to old IFS

  local IFS=$'\n' # split output of compgen below by lines, not spaces
  _result[0]="$(printf '%*s' "-$COLUMNS"  "${_result[0]}")"
  COMPREPLY=("${_result[@]}")
}

__ac_git_clone_submenu_help() {
  local _prev=$1
  local _result=$(perl $GL_CMPL_DIR/cmpl.pl "git_clone_help" "$_prev")
  # split resulting string based on newlines
  SAVEIFS=$IFS        # save current IFS, so we can revert back to it
  IFS=$'\n'           # change IFS to split on new lines
  _result=($_result)
  IFS=$SAVEIFS        # revert to old IFS

  local IFS=$'\n' # split output of compgen below by lines, not spaces
  _result[0]="$(printf '%*s' "-$COLUMNS"  "${_result[0]}")"
  COMPREPLY=("${_result[@]}")
}

__ac_git_reset_submenu_help() {
  local _prev=$1
  local _result=$(perl $GL_CMPL_DIR/cmpl.pl "git_reset_help" "$_prev")
  # split resulting string based on newlines
  SAVEIFS=$IFS        # save current IFS, so we can revert back to it
  IFS=$'\n'           # change IFS to split on new lines
  _result=($_result)
  IFS=$SAVEIFS        # revert to old IFS

  local IFS=$'\n' # split output of compgen below by lines, not spaces
  _result[0]="$(printf '%*s' "-$COLUMNS"  "${_result[0]}")"
  COMPREPLY=("${_result[@]}")
}

__ac_git_pull_submenu_help() {
  local _prev=$1
  local _result=$(perl $GL_CMPL_DIR/cmpl.pl "git_pull_help" "$_prev")
  # split resulting string based on newlines
  SAVEIFS=$IFS        # save current IFS, so we can revert back to it
  IFS=$'\n'           # change IFS to split on new lines
  _result=($_result)
  IFS=$SAVEIFS        # revert to old IFS

  local IFS=$'\n' # split output of compgen below by lines, not spaces
  _result[0]="$(printf '%*s' "-$COLUMNS"  "${_result[0]}")"
  COMPREPLY=("${_result[@]}")
}

__ac_git_rm_submenu_help() {
  local _prev=$1
  local _result=$(perl $GL_CMPL_DIR/cmpl.pl "git_rm_help" "$_prev")
  # split resulting string based on newlines
  SAVEIFS=$IFS        # save current IFS, so we can revert back to it
  IFS=$'\n'           # change IFS to split on new lines
  _result=($_result)
  IFS=$SAVEIFS        # revert to old IFS

  local IFS=$'\n' # split output of compgen below by lines, not spaces
  _result[0]="$(printf '%*s' "-$COLUMNS"  "${_result[0]}")"
  COMPREPLY=("${_result[@]}")
}

__ac_git_clean_submenu_help() {
  local _prev=$1
  local _result=$(perl $GL_CMPL_DIR/cmpl.pl "git_clean_help" "$_prev")
  # split resulting string based on newlines
  SAVEIFS=$IFS        # save current IFS, so we can revert back to it
  IFS=$'\n'           # change IFS to split on new lines
  _result=($_result)
  IFS=$SAVEIFS        # revert to old IFS

  local IFS=$'\n' # split output of compgen below by lines, not spaces
  _result[0]="$(printf '%*s' "-$COLUMNS"  "${_result[0]}")"
  COMPREPLY=("${_result[@]}")
}

