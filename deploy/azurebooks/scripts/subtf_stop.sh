#!/usr/bin/env bash
eval "$(cat $(dirname "${BASH_SOURCE[0]}")/header.sh)"

if chk_flag --help $@; then
    title "$__file_name [ flags ] [ vm_name ]: Stops vms."
    text "Flags:"
    text "    -a : stop ALL of your vm's on azure."
    text "Args:"
    text "    vm_name: the name of the vm to stop (will match to all VM's with this in the name)"
    exit 0
fi

# Make sure resource name is set
if [[ -z "$TF_VAR_azure_resource_name_prefix" ]] && chk_flag -a $@; then
    error Unable to find TF_VAR_azure_resource_name_prefix... make sure deployer is installed and terraform is setup according to the readme!
    exit 1
fi

# Make sure we actually have an argument...
if [[ $# == 0 ]]; then
    error No arguments provided, unable to run command. Run `--help`.
    exit 1
fi

cd $__dir/../subt

# Get the ID(s) of the VM(s) we want to shut down
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
    error "Azure command failed, make sure you are logged in!"
    cd $__call_dir
    exit 1
fi

if [[ -z "$vm_spec" ]]; then
    echo "No VM's matched! Unable to stop them!"
    cd $__call_dir
    exit 1
fi

debug $vm_spec

# Stop the selected VM's
title Stopping VMS
az vm stop --ids $vm_spec

# Make sure we actually have ID's
if last_command_failed; then
    error "Azure command failed, make sure you are logged in! Or contact maintainer!"
    cd $__call_dir
    exit 1
else
    text Command Succeeded!
fi

cd $__call_dir
