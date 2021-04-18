#!/usr/bin/env bash
eval "$(cat $(dirname "${BASH_SOURCE[0]}")/header.sh)"
. "$SUBT_PATH/operations/scripts/header.sh"
. "$SUBT_PATH/operations/scripts/formatters.sh"

if chk_flag --help $@ || chk_flag help $@ || chk_flag -h $@ || chk_flag -help $@; then
    title "$__file_name [ flags ] : Lists the power status of virtual machines."
    text "Flags:"
    text "    -st : lists all started vms."
    text "    -sp : lists all stopped vms."
    text "Args:"
    text "    resource_group_name: the name of the resource group where the virtual machine is located."
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

# get a list of all the vms registered for this user
vm_spec=$(az vm list -g SubT --query "[?contains(name, '$TF_VAR_azure_resource_name_prefix')].id" -o tsv)

# Make sure we actually have ID's
if last_command_failed; then
    exit_pop_error "Azure command failed, make sure you are logged in!"
fi

if [[ -z "$vm_spec" ]]; then
    exit_pop_error "No VM's matched! Unable to stop them!"
fi

for line in $vm_spec; do
    vm_name=$(basename $line)
    status=$(az vm get-instance-view --name $vm_name -g SubT --output table --query "instanceView.statuses[1]" --output table)
    ip=$(az vm list-ip-addresses -g SubT --name $vm_name --query "[].virtualMachine.network.privateIpAddresses" -o tsv)

    if [[ "$status" == *"deallocated"* ]] && chk_flag -sp $@; then
        printf "%-30s | %-10s | %-10s \n" $vm_name $ip running
    elif [[ "$status" == *"running"* ]] && chk_flag -st $@; then
        printf "%-30s | %-10s | %-10s \n" $vm_name $ip running
    elif ! chk_flag -sp $@ && ! chk_flag -st $@; then
        status=$(echo $status | awk '{print $7}' )
        printf "%-30s | %-10s | %-10s \n" $vm_name $ip $status
    fi
done

# cleanup & exit
exit_pop_success
