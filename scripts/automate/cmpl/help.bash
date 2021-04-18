#!/usr/bin/env bash

# NOTICE: cant import header.sh or formatters.sh, then tab-complete will not work

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

subt_help() {
  echo -e "About: 01... == SubT == "
  echo -e "About: 02... Enabling Enhanced Situational Awareness and Human Augmentation through Efficient Autonomous Systems"
  echo -e "About: 03..."
  echo -e "About: 04... HowTo:"
  echo -e "About: 05...  - Press 'Tab' once, to preview a list of completed word options."
  echo -e "About: 06...  - Input a tab-complete word, from the preview list of completed words."
  echo -e "About: 07...  - Press '.', TAB to preview the next list of next available deployer actions."
  echo -e "About: 08...  - Press SPACE, TAB to show the help message and preview words (for your current completion match)."
  echo -e "About: 09... * MAKE SURE THERE IS NO WHITESPACE WHEN YOU SELECT THE NEXT KEYWORD (i.e. press backspace to show tab-complete list)"
  echo -e "About: 11..."
  echo -e "About: 12... == Optional Flags =="
  echo -e "About: 13..."
  echo -e "About: 14...   -p           : preview the deployer commands that will be run"
  echo -e "About: 15...   -verbose     : show the exact (verbose) bash commands that will run"
  echo -e "About: 16..."
  echo -e "About: 17... == Your Tab-Completed Word Options Are =="
  echo -e "About: 18..."
  echo -e "deployer   : deployer, your access point to 'deploy' subt to the localhost, azure or robots systems."
  echo -e "git        : git helper scripts, for maintaining subt deploy three level repo."
  echo -e "cloud      : cloud tools for creating & managing azure cloud setups."
  echo -e "ansible    : tools for pulling updates to localhost or robot system."
  echo -e "tools      : general helper tools, can be used for any infrastructure system (azure, robot, local)."
  echo -e "tutorial   : tutorials on commonly used deployer commands."
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
