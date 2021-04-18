#!/usr/bin/env bash
eval "$(cat $(dirname "${BASH_SOURCE[0]}")/header.sh)"
. "$SUBT_PATH/operations/scripts/header.sh"
. "$SUBT_PATH/operations/scripts/formatters.sh"

if chk_flag --help $@ || chk_flag help $@ || chk_flag -h $@ || chk_flag -help $@; then
    title "$__file_name [ flags ] [ vm_name ]: Starts vms."
    text "Flags:"
    text "    -a : start ALL of your vm's on azure."
    text "    -l : list your created VMs."
    text "Args:"
    text "    vm_name: the name of the vm to start (will match to all VM's with this in the name)"
    exit 0
fi

# source the terraform environment
source_terra_env

# go to the terraform project path
pushd $SUBT_OPERATIONS_PATH/azurebooks/subt

# Make sure resource name is set
if [[ -z "$TF_VAR_azure_resource_name_prefix" ]] && chk_flag -a $@; then
    exit_pop_error Unable to find TF_VAR_azure_resource_name_prefix... make sure deployer is installed and terraform is setup according to the readme!
fi

# Make sure we actually have an argument...
if [[ $# == 0 ]]; then
    exit_pop_error "No arguments provided, unable to run command. Run '--help'."
fi

# list created vms
if chk_flag -l $@; then
    vms=($(az vm list -g SubT --query "[?contains(name, '$TF_VAR_azure_resource_name_prefix')].id" -o tsv))
    for vm in "${vms[@]}"; do
        _vm_name=${vm##*/}
        echo "$_vm_name"
    done
    exit_pop_success
fi

# Get the ID(s) of the VM(s) we want to start
title Getting VM IDs
vm_spec=""
vm_name=${@:-1}
if chk_flag -a $@; then
    vm_spec=$(az vm list -g SubT --query "[?contains(name, '$TF_VAR_azure_resource_name_prefix')].id" -o tsv)
else
    vm_spec=$(az vm list -g SubT --query "[?contains(name, '$vm_name')].id" -o tsv)
fi

# Make sure we actually have ID's
if last_command_failed; then
    exit_pop_error "Azure command failed, make sure you are logged in!"
fi

if [[ -z "$vm_spec" ]]; then
    exit_pop_error "No VM's matched! Unable to stop them!"
fi

for line in $vm_spec; do
    debug $line
done

# Stop the selected VM's
title Starting VMs
az vm start --ids $vm_spec

# Make sure we actually have ID's
if last_command_failed; then
    exit_pop_error "Azure command failed, make sure you are logged in! Or contact maintainer!"
else
    text Command Succeeded!
fi

# cleanup & exit
exit_pop_success
