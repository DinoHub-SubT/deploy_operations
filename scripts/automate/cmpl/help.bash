#!/usr/bin/env bash

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt'
# //////////////////////////////////////////////////////////////////////////////
__ac_subt_help() {
  local usage=(
    "About: 01... == SubT == "
    "About: 02... Enabling Enhanced Situational Awareness and Human Augmentation through Efficient Autonomous Systems"
    "About: 03..."
    "About: 04... HowTo:"
    "About: 05...  - Press 'Tab' once, to preview a list of completed word options."
    "About: 06...  - Input a tab-complete word, from the preview list of completed words."
    "About: 07...  - Press '.', TAB to preview the next list of next available deployer actions."
    "About: 08...  - Press SPACE, TAB to show the help message and preview words (for your current completion match)."
    "About: 09... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU SELECT THE NEXT KEYWORD (i.e. press backspace to show tab-complete list)"
    "About: 11..."
    "About: 12... == Optional Flags =="
    "About: 13..."
    "About: 14...   -p           : preview the deployer commands that will be run"
    "About: 15...   -verbose     : show the exact (verbose) bash commands that will run"
    "About: 16..."
    "About: 17... == Your Tab-Completed Word Options Are =="
    "About: 18..."
    "deployer   : deployer, your access point to 'deploy' subt to the localhost, azure or robots systems."
    "git        : git helper scripts, for maintaining subt deploy three level repo."
    "cloud      : cloud tools for creating & managing azure cloud setups."
    "ansible    : tools for pulling updates to localhost or robot system."
    "tools      : general helper tools, can be used for any infrastructure system (azure, robot, local)."
    "tutorial   : tutorials on commonly used deployer commands."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

# //////////////////////////////////////////////////////////////////////////////
# @brief 'subt cloud'
# //////////////////////////////////////////////////////////////////////////////
__ac_cloud_help() {
  local usage=(
    "About: 01... Cloud scripts for automating Azure cloud system setup."
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
    "ssh.probe        : shows which configured ssh connections are are available to connect."
    "teamviewer.probe : shows which teamviewer connections are are available to connect."
    "rdp              : establish a rdp (rdesktop) session with an Azure VM."
    "snapshot         : creates a snapshot logfile of deploy repo submodules."
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}

# //////////////////////////////////////////////////////////////////////////////
# @brief 'mmpug ansible'
# //////////////////////////////////////////////////////////////////////////////
__ac_ansible_help() {
  local usage=(
    "About: 00... == Ansible =="
    "About: 01... Installs base system library dependencies, extra tools & sets up system configuration on the different systems."
    "About: 02... - Customize your ansible install here: ~/.subt/ansible_config.yaml"
    "About: 03..."
    "About: 11... Input: "
    "About: 12...   [ flags ] < system_name > < playbook > "
    "About: 13... Flags:"
    "About: 14...   -s  : Show the available system names."
    "About: 15...   -b  : Show the available playbooks."
    "About: 16...   -p  : Provide system password, to allow sudo installs."
    "About: 17... Args:"
    "About: 17...   system_name: the name of the remote system to install on"
    "About: 18...   playbook: the name of the robot ansible playbook to run"
    "             "
  )
  local IFS=$'\n' # split output of compgen below by lines, not spaces
  usage[0]="$(printf '%*s' "-$COLUMNS"  "${usage[0]}")"
  COMPREPLY=("${usage[@]}")
}
