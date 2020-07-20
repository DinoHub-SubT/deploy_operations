#!/usr/bin/env bash
eval "$(cat $(dirname "${BASH_SOURCE[0]}")/header.sh)"

if chk_flag --help $@; then
    title "$__file_name [ flags ]: Creates the vpn needed to access azure (both through terraform and with network manager."
    text "Flags:"
    text "    -y : do not ask for confirmation before running terraform apply"
    text "    -t : Apply only the terraform changes (Takes ~25 minutes)"
    text "    -n : Apply only network manager changes"
    text "    -c : Use existing files in ~/.ssh/azure/vpn "
    exit 0
fi

cd $__dir/../subt

if ! chk_flag -n $@; then
    title Applying Terraform
    if chk_flag -y $@; then
        # Echo the path to the state file variable into the terraform init command
        echo yes | terraform apply -target module.example.azurerm_virtual_network_gateway.example
    else
        terraform apply -target module.example.azurerm_virtual_network_gateway.example
    fi
fi

if ! chk_flag -t $@; then
    title Applying Network Manager
    if [[ -z $TF_VAR_azure_resource_name_prefix ]]; then
        error \$TF_VAR_azure_resource_name_prefix is NOT set! Please make sure deployer is installed, and the azure_books README.md was followed.
        cd $__call_dir
        exit 1
    fi
    
    mkdir -p ~/.ssh/azure/vpn
    cd ~/.ssh/azure/vpn
    if ! chk_flag -c $@; then
        zip_url=$(az network vnet-gateway vpn-client generate --name ${TF_VAR_azure_resource_name_prefix}-vnet-gateway --processor-architecture x86 --resource-group SubT)
        if last_command_failed; then
            error Azure command failed.. please check your azure login and setup [az login] and [~/.terraform_id.bashrc]
            cd $__call_dir
            exit 1
        fi
        
        debug $zip_url
        # Remove the quote marks...
        cleaned_zip_url=$(sed -e 's/^"//' -e 's/"$//' <<<"$zip_url")
        debug $cleaned_zip_url
        
        if [ -d client_download ]; then
            if [ -d client_download.bkp ]; then
                rm -rf client_download.bkp
            fi
            mv client_download client_download.bkp
        fi
        rm vpn_settings.zip
        wget --directory-prefix=. -O vpn_settings.zip $cleaned_zip_url

        if last_command_failed; then
            error Wget command failed.. please contact maintainer..
            cd $__call_dir
            exit 1
        fi

        # This usually gives warning so we won't check it...
        unzip -j -d client_download vpn_settings.zip

        if [[ ! -e client_download/VpnSettings.xml ]]; then
            error [$(pwd)/client_download/VpnSettings.xml] does not exist... contact maintainer...
            cd $__call_dir
            exit 1
        fi
    fi

    azure_url=$(grep -o -P '(?<=VpnServer\>).*(?=\</VpnServer)' <<< cat client_download/VpnSettings.xml)
    debug $azure_url

    if [[ ! -e client_download/VpnServerRoot.cer ]]; then
        error [$(pwd)/client_download/VpnServerRoot.cer] does not exist... contact maintainer...
        cd $__call_dir
        exit 1
    fi

    if [[ ! -e $(pwd)/${TF_VAR_azure_username}Cert.pem ]]; then
        error [$(pwd)/${TF_VAR_azure_username}Cert.pem] does not exist... make sure you followed the azure setup instructions correctly
        cd $__call_dir
        exit 1
    fi

    if [[ ! -e $(pwd)/${TF_VAR_azure_username}Key.pem ]]; then
        error [$(pwd)/${TF_VAR_azure_username}Key.pem] does not exist... make sure you followed the azure setup instructions correctly
        cd $__call_dir
        exit 1
    fi

    title Removing Old Connection if it exists
    nmcli connection | grep -q "AZURE_VPN_CONNECTION"
    
    if last_command_succeeded; then
        nmcli connection delete "AZURE_VPN_CONNECTION"
        last_command_failed && error AZURE_VPN_CONNECTION was not deleted! Contact Maintainer
    fi

    title Creating new connection AZURE_VPN_CONNECTION
    sudo nmcli connection add \
        connection.id AZURE_VPN_CONNECTION \
        connection.type vpn \
        connection.autoconnect false \
        connection.permissions ${USER} \
        vpn.service-type org.freedesktop.NetworkManager.strongswan \
        ipv4.method auto \
        ipv6.method auto \
        +vpn.data address=${azure_url} \
        +vpn.data certificate=$(pwd)/client_download/VpnServerRoot.cer \
        +vpn.data encap=no \
        +vpn.data ipcomp=no \
        +vpn.data method=key \
        +vpn.data proposal=no \
        +vpn.data usercert=$(pwd)/${TF_VAR_azure_username}Cert.pem \
        +vpn.data userkey=$(pwd)/${TF_VAR_azure_username}Key.pem \
        +vpn.data virtual=yes \
        ifname ""

fi

cd $__call_dir
