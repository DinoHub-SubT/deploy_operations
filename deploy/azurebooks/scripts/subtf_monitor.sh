#!/usr/bin/env bash
eval "$(cat $(dirname "${BASH_SOURCE[0]}")/header.sh)"
if chk_flag --help $@ || chk_flag help $@ || chk_flag -h $@ || chk_flag -help $@; then
    title "$__file_name [ flags ] -g < resource group name >: Monitors azure resources."
    text "Flags:"
    text "    -g        : azure resource group."
    text "    -ls       : list group names."
    text "    -vm       : show VM status."
    text "    -vnet     : list vnet resources."
    text "    -pubip    : list public IPs resources."
    text "    -disk     : list all managed disks attached to VMs."
    text "    -stg      : display all storage accounts."
    text "    -v        : display verbose output."
    exit 0
fi

# @brief list all resource group names
if chk_flag -ls $@; then
  az group list --output table
  exit_success
fi

# check the the azure resource group name is given
if ! chk_flag -g $@; then
  warning "please set your azure resource group with flag -g [group name]"
  exit_failure
fi

# globals
_GL_DISPLAY_RUNNING=false
# printf colors
GL_PF_RED=$(tput setaf 1)
GL_PF_YELLOW=$(tput setaf 3)
GL_PF_BLUE=$(tput setaf 4)
GL_PF_DEFAULT=$(tput sgr0)

# @brief: get the azure group name
_get_group_arg() {
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
  local _vms=($(az vm list -g $_group --output table))
  local _total=0 _running=0
  for _list in "${_vms[@]}"; do
    local _name=$( echo "$_list"  | awk '{ print $1; }' )
    # ignore the header from the status message
     [[ "$_name" == *"----"* ]] || [ "$_name" = "Name" ] && continue;
    ((++_total))

    # get the vm status information
    local _status=$(az vm get-instance-view --name $_name -g $_group --output table --query "instanceView.statuses[1]" --output table)

    # display warning if VM status is not deallocated
    if [[ ! "$_status" == *"deallocated"* ]]; then
      printf "%-30s | %-30s \n" "${GL_PF_YELLOW}not deallocated! $GL_PF_DEFAULT" "$_name"
      ((++_running))
    else
      printf "%-30s | %-30s \n" "${GL_PF_BLUE}deallocated $GL_PF_DEFAULT" "$_name"
    fi

    # display vm status
    if $_GL_DISPLAY_RUNNING; then
      text "$_status \n"
    fi
  done

  text "\nTotal number of VMs: $_total"
  text "\nTotal number of running VMs: $_running"
}

# @brief display number of vnet gateways
_list_vnets() {
  local _group=$1
  local _status=$(az network vnet-gateway list -g $_group -o table)
  echo "$_status"
  local _total=$( echo "$_status" | wc -l)
  text "\nTotal number of vnet: $_total"
}

# @brief display number of public IPs
_list_ip() {
  local _group=$1
  local _status=$(az network public-ip list -g $_group -o table)
  echo "$_status"
  local _total=$( echo "$_status" | wc -l)
  text "\nTotal number of public IP: $_total"
}

# @brief display number of VM storage disks
_list_disk() {
  IFS=$'\n'
  local _group=$1
  local _status=($(az disk list -g $_group -o table))
  local _total=0
  local _count_lrs=0 _count_ssd_lrs=0 _count_premium_lrs=0
  local _size_lrs=0 _size_ssd_lrs=0 _size_premium_lrs=0

  for _disk in "${_status[@]}"; do
    echo "$_disk"
    ((++_total))
    # count the disk type
    if [[ "$_disk" == *"Standard_LRS"* ]]; then
      ((++_count_lrs))
      local _size=$(echo "$_disk" | awk '{print $6}' )
      ((_size_lrs = _size_lrs + _size))

    elif [[ "$_disk" == *"StandardSSD_LRS"* ]]; then
      ((++_count_ssd_lrs))
      local _size=$(echo "$_disk" | awk '{print $6}' )
      ((_size_ssd_lrs = _size_ssd_lrs + _size))

    elif [[ "$_disk" == *"Premium_LRS"* ]]; then
      ((++_count_premium_lrs))
      local _size=$(echo "$_disk" | awk '{print $6}' )
      ((_size_premium_lrs = _size_premium_lrs + _size))
    fi

  done
  text "\nTotal number of managed disks: $_total"

  printf "%-30s | %-30s | %-30s \n" "Standard_LRS" "$_count_lrs" "$_size_lrs GB"
  printf "%-30s | %-30s | %-30s \n" "StandardSSD_LRS" "$_count_ssd_lrs" "$_size_ssd_lrs GB"
  printf "%-30s | %-30s | %-30s \n" "Premium_LRS" "$_count_premium_lrs" "$_size_premium_lrs GB"

}


# //////////////////////////////////////////////////////////////////////////////
# Create the Root & User Certificates
title == Azure Monitor ==

# trap ctrl-c and call ctrl_c
trap ctrl_c INT

_group=$(_get_group_arg $@)
[ -z $_group ] && warning "please set your azure resource group with flag -g [group name]" && exit_failure

if chk_flag -vm $@; then
  text "...checking for running VMs.\n"
  chk_flag -v $@ && _GL_DISPLAY_RUNNING=true
  _vm_running $_group
fi

if chk_flag -vnet $@; then
  _list_vnets $_group
fi

if chk_flag -pubip $@; then
  _list_ip $_group
fi

if chk_flag -disk $@; then
  _list_disk $_group
fi

exit_success
