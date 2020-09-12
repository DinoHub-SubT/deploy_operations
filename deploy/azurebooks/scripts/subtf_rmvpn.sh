#!/usr/bin/env bash
eval "$(cat $(dirname "${BASH_SOURCE[0]}")/header.sh)"

if chk_flag --help $@ || chk_flag help $@ || chk_flag -h $@ || chk_flag -help $@; then
    title "$__file_name [ flags ]: Removes the vpn needed to access azure (both through terraform and with network manager."
    text "Flags:"
    text "    -y : do not ask for confirmation before running terraform apply"
    text "    -t : Apply only the terraform changes (takes ~12 minutes)"
    text "    -n : Apply only network manager changes"
    exit 0
fi

cd $__dir/../subt


if ! chk_flag -n $@; then
    title Applying Terraform
    if chk_flag -y $@; then
        # Echo the path to the state file variable into the terraform init command
        echo yes | terraform destroy -target module.example.azurerm_virtual_network_gateway.example
    else
        terraform destroy -target module.example.azurerm_virtual_network_gateway.example
    fi
fi

if ! chk_flag -t $@; then
    title Applying Network Manager
    nmcli connection | grep -q "AZURE_VPN_CONNECTION"
    
    if last_command_failed; then
        error AZURE_VPN_CONNECTION not listed in 'nmcli connection', unable to delete
    else
        nmcli connection delete "AZURE_VPN_CONNECTION"
        last_command_failed && error AZURE_VPN_CONNECTION was not deleted!
    fi
fi

cd $__call_dir
