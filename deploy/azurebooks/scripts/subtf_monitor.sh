#!/usr/bin/env bash
eval "$(cat $(dirname "${BASH_SOURCE[0]}")/header.sh)"
if chk_flag --help $@ || chk_flag help $@ || chk_flag -h $@ || chk_flag -help $@; then
    title "$__file_name [ flags ] -g < resource group name >: Monitors azure resources."
    text "Flags:"
    text "    -ns       : list resource groups."
    text "    -g        : azure resource group."
    text "    -all      : use all resource groups names."
    text "    -vm       : show VM status."
    text "    -vnet     : list vnet resources."
    text "    -ip    : list public IPs resources."
    text "    -disk     : list all managed disks attached to VMs."
    text "    -flt        : filter the types of disk to show: 'Standard_LRS', 'StandardSSD_LRS', 'Premium_LRS'."
    text "    -v        : display verbose output."
    exit 0
fi

# globals
_GL_VM_VERBOSE=false
# printf colors
GL_PF_RED=$(tput setaf 1)
GL_PF_YELLOW=$(tput setaf 3)
GL_PF_BLUE=$(tput setaf 4)
GL_PF_DEFAULT=$(tput sgr0)
GL_NS_GROUPS=()

# @brief list all resource group names
if chk_flag -ns $@; then
  az group list --output table
  exit_success
fi

# check the the azure resource group name is given
if ! chk_flag -g $@ && ! chk_flag -all $@; then
  warning "please set your azure resource group with flag -g [group name] or use all -all to run over all resource groups."
  exit_failure
fi

# ignore the default az stdout header
ignore_az_stdout_header() {
  [[ "$1" == *"----"* ]] || [ "$1" = "Name" ] && return 0;
  return 1;
}

# get a list of all the resource groups
resource_groups_list() {
  local _groups=($(az group list --output table | awk '{ print $1; }'))
  for _group in "${_groups[@]}"; do
    ignore_az_stdout_header $_group && continue;
    GL_NS_GROUPS+=("$_group")
  done
}

set_resource_group_list() {
  if chk_flag -g $@; then
    GL_NS_GROUPS=$(get_arg -g $@)
  else
    resource_groups_list
  fi
  # echo "GL_NS_GROUPS: ${GL_NS_GROUPS[@]}"
}

# @brief list vm status messages
monitor_virtual_machines() {
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
    local _vm_size=$(az vm get-instance-view --name $_name -g $_group --output table --query "hardwareProfile.vmSize" --output table | tail -1)
    # display warning if VM status is not deallocated
    if [[ ! "$_status" == *"deallocated"* ]]; then
      printf "%-30s | %-30s | %-30s \n" "${GL_PF_YELLOW}not deallocated! $GL_PF_DEFAULT" "$_name" "$_vm_size"
      ((++_running))
    else
      printf "%-30s | %-30s | %-30s \n" "${GL_PF_BLUE}deallocated $GL_PF_DEFAULT" "$_name" "$_vm_size"
    fi

    # display vm status
    if $_GL_VM_VERBOSE; then
      text "$_status \n"
    fi
  done

  text "\nTotal number of VMs: $_total"
  text "\nTotal number of running VMs: $_running"
}

# @brief display number of vnet gateways
monitor_virtual_networks() {
  local _group=$1
  local _status=$(az network vnet-gateway list -g $_group -o table)
  echo "$_status"
  local _total=$( echo "$_status" | wc -l)
  text "\nTotal number of vnet: $_total"
}

# @brief display number of public IPs
monitor_public_ips() {
  local _group=$1
  local _status=$(az network public-ip list -g $_group -o table)
  echo "$_status"
  local _total=$( echo "$_status" | wc -l)
  text "\nTotal number of public IP: $_total"
}

# @brief display number of VM storage disks
monitor_disk_usage() {
  IFS=$'\n'
  local _group=$1
  local _filter=$2
  local _status=($(az disk list -g $_group -o table))
  local _total=0
  local _count_lrs=0 _count_ssd_lrs=0 _count_premium_lrs=0
  local _size_lrs=0 _size_ssd_lrs=0 _size_premium_lrs=0

  # az disk show -n kat-ugv1-os-disk -g SubT | grep managedBy

  for _disk in "${_status[@]}"; do

    # ignore the headers
    ignore_az_stdout_header $_disk && continue;

    # display the managed by vm disk info
    if echo "$_disk" | grep -v -q "Name"; then
      local _name=$(echo $_disk | awk '{print $1}')
      local _is_managed_out=$(az disk show -n $_name -g $_group | grep managedBy)
      local _is_managed_value=$(echo "$_is_managed_out" | sed -n -e 's/^.*://p' | sed 's/.$//' | xargs basename )
    fi

    # setup filter results flag
    local _filter_print=false

    # skip line if no filter
    if  [ ! -z "$_filter" ] && echo "$_disk" | grep -q "$_filter" ; then
      _filter_print=true
    elif [ ! -z "$_filter" ] && echo "$_is_managed_value" | grep -q "$_filter" ; then
      _filter_print=true
    fi

    # show all results, or show only filtered results
    if $_filter_print || [ -z "$_filter" ] ; then
      # print disk info line
      printf "%-30s | %-30s \n" "$_is_managed_value" "$_disk" # "$_disk \t\t$_is_managed_value"

      # count the total number of disks
      ((++_total))

      # count the disk type
      if [[ "$_disk" == *"Standard_LRS"* ]]; then
        ((++_count_lrs))
        local _size=$(echo "$_disk" | awk '{print $(NF-1)}' )
        ((_size_lrs = _size_lrs + _size))

      elif [[ "$_disk" == *"StandardSSD_LRS"* ]]; then
        ((++_count_ssd_lrs))
        local _size=$(echo "$_disk" | awk '{print $(NF-1)}' )
        ((_size_ssd_lrs = _size_ssd_lrs + _size))

      elif [[ "$_disk" == *"Premium_LRS"* ]]; then
        ((++_count_premium_lrs))
        local _size=$(echo "$_disk" | awk '{print $(NF-1)}' )
        ((_size_premium_lrs = _size_premium_lrs + _size))
      fi
    fi

  done
  text "\nTotal number of managed disks: $_total"

  printf "%-30s | %-30s | %-30s \n" "Standard_LRS" "$_count_lrs" "$_size_lrs GB"
  printf "%-30s | %-30s | %-30s \n" "StandardSSD_LRS" "$_count_ssd_lrs" "$_size_ssd_lrs GB"
  printf "%-30s | %-30s | %-30s \n" "Premium_LRS" "$_count_premium_lrs" "$_size_premium_lrs GB"
}

# //////////////////////////////////////////////////////////////////////////////
title == Azure Monitor ==
# //////////////////////////////////////////////////////////////////////////////

# trap ctrl-c and call ctrl_c
trap ctrl_c INT

# setup the resource group list
set_resource_group_list $@

# perform azure monitor
for _group in "${GL_NS_GROUPS[@]}"; do

  newline && divider
  subtitle $_group
  # monitor virtual machines
  if chk_flag -vm $@; then
    text "...checking for virtual machines\n"
    chk_flag -v $@ && _GL_VM_VERBOSE=true
    monitor_virtual_machines $_group
  fi

  # monitor virtual networks
  if chk_flag -vnet $@; then
    text "...checking for virtual networks\n"
    monitor_virtual_networks $_group
  fi

  if chk_flag -ip $@; then
    monitor_public_ips $_group
  fi

  if chk_flag -disk $@ && ! chk_flag -f $@ ; then
    monitor_disk_usage $_group $(get_arg -flt $@)
  fi

done

exit_success
