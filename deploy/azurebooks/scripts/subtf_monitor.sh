#!/usr/bin/env bash
eval "$(cat $(dirname "${BASH_SOURCE[0]}")/header.sh)"
if chk_flag --help $@ || chk_flag help $@ || chk_flag -h $@ || chk_flag -help $@; then
    title "$__file_name [ flags ]: Monitors azure resources."
    text "Flags:"
    text "    -st : show VM status."
    text "    -g  : azure resource group."
    text "    -v  : display verbose output."
    exit 0
fi

# check the the azure resource group name is given
if ! chk_flag -g $@; then
  warning "please set your azure resource group with flag -g [group name]"
  exit_on_failure
fi

# globals
_GL_DISPLAY_RUNNING=false
# printf colors
GL_PF_RED=$(tput setaf 1)
GL_PF_YELLOW=$(tput setaf 3)
GL_PF_BLUE=$(tput setaf 4)
GL_PF_DEFAULT=$(tput sgr0)

# @brief: get the azure group name
_get_group() {
  # get the index of the -g flag, to be able to get the flag's argument
  local idx=$(arr_idx -g $@)
  ((idx++))
  local arg=${@:$idx:1}
  echo "$arg"
}

# @brief list vm status messages
_vm_running() {
  local _group=$1
  # get list of azure vms -- split on newline
  IFS=$'\n'
  local _vms=($(az vm list -g SubT --output table))

  for _list in "${_vms[@]}"; do
    local _name=$( echo "$_list"  | awk '{ print $1; }' )

    # ignore the header from the status message
    [ "$_name" = "----------------------------" ] || [ "$_name" = "Name" ] && continue;

    # get the vm status information
    local _status=$(az vm get-instance-view --name $_name -g $_group --output table --query "instanceView.statuses[1]" --output table)

    # display warning if VM status is not deallocated
    if [[ ! "$_status" == *"deallocated"* ]]; then
      printf "%-30s | %-30s \n" "${GL_PF_YELLOW}not deallocated! $GL_PF_DEFAULT" "$_name"
    else
      printf "%-30s | %-30s \n" "${GL_PF_BLUE}deallocated $GL_PF_DEFAULT" "$_name"
    fi

    # display vm status
    if $_GL_DISPLAY_RUNNING; then
      text "$_status \n"
    fi
  done
}

# //////////////////////////////////////////////////////////////////////////////
# Create the Root & User Certificates
title == Azure Monitor ==

# trap ctrl-c and call ctrl_c
trap ctrl_c INT

_group=$(_get_group $@)
[ -z $_group ] && warning "please set your azure resource group with flag -g [group name]" && exit_failure

if chk_flag -st $@; then
  text "...checking for running VMs.\n"
  chk_flag -v $@ && _GL_DISPLAY_RUNNING=true
  _vm_running $_group
fi
