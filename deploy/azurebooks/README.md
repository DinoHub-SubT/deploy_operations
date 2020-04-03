# Cloud Operation Tools

## Terraforn Example Project Walkthrough

**Azure CLI Initial Login**

        # az login will prompt a browser window. Enter your user credentials to login.
        az login

**Export your subscription and tenant ids as env variables**

        # List the ids
        az account list

        # Open bashrc or zshrc
        gedit ~/.bashrc

        # write the subscription id
        export TF_VAR_subscription_id=[ 'id' field in 'az account list' output]
        # write the tenant id
        export TF_VAR_tenant_id=[ 'tenantId' field in 'az account list' output]

**Terraform Workspace (example)**

All terraform commands must be done in the directory workspace

- Go to the terraform workspace

        cd ~/deploy_ws/operations/deploy/azurebooks/example

- Personalize the variables

        gedit ~/deploy_ws/operations/deploy/azurebooks/example/main.tf

    - Change `resource_name_prefix` to your preference

    - Change `tag_name_prefix` to your preference
        
- Initial the terraform workspace

        terraform init

- Dry-run the terraform deployment

        # Shows the user what the azure deployment will happen
        terraform plan

- Apply the terraform deployment

        # will create all the resources on azure
        terraform apply

    - Please complete the **VPN Connection Steps** shown below (if you want VPN connection), before doing this step.

You should now have an example resources deployed on azure.

**Changing Terraform Files**

Any changes to the terraform files, requires updating the terraform workspace

        terraform plan


After `plan`, apply the changes to the cloud

        terraform apply

* * *

## VPN Connection

### Ubuntu

The below instructions can be found on [azure tutorials](https://docs.microsoft.com/en-us/azure/vpn-gateway/point-to-site-vpn-client-configuration-azure-cert)

**Install Dependency Libraries**

      sudo apt-get update
      sudo apt-get install strongswan strongswan-pki libstrongswan-extra-plugins network-manager-strongswan

**Create the Root & User Certificates**

      # create the cert path
      mkdir -p ~/.ssh/azure/vpn
      cd ~/.ssh/azure/vpn

      # Create the Root CA cert
      ipsec pki --gen --outform pem > caKey.pem
      ipsec pki --self --in caKey.pem --dn "CN=VPN CA" --ca --outform pem > caCert.pem
      
      # Copy the output to the 'vpn_ca_cert' variable in 'example/main.tf'
      openssl x509 -in caCert.pem -outform der | base64 -w0 ; echo

      # == Create the user certificate ==

      # Please change 'password' to something more secure 
      export PASSWORD="password"
      # Please change 'username' to your username
      export USERNAME="client"

      # generate the user certificate
      ipsec pki --gen --outform pem > "${USERNAME}Key.pem"
      ipsec pki --pub --in "${USERNAME}Key.pem" | ipsec pki --issue --cacert caCert.pem --cakey caKey.pem --dn "CN=${USERNAME}" --san "${USERNAME}" --flag clientAuth --outform pem > "${USERNAME}Cert.pem"

      # generate the p12 bunder
      openssl pkcs12 -in "${USERNAME}Cert.pem" -inkey "${USERNAME}Key.pem" -certfile caCert.pem -export -out "${USERNAME}.p12" -password "pass:${PASSWORD}"

      # == Apply Change to Azure ==

      # apply the VPN gateway, this can take up to 30 minutes
      cd ~/deploy_ws/operations/deploy/azurebooks/example/
      terraform plan
      terraform apply

      # == Download the VPN Client ==

      # get the vpn client, this will output a https link, please remember it
      cd ~/.ssh/azure/vpn
      az network vnet-gateway vpn-client generate --name [vnet gateway name] --processor-architecture x86 --resource-group [resource group name]

      # download the client
      wget [https path from previous command]

      # unzip the vpn client package
      sudo unzip -j -d client-download [downloaded.zip]

      # == Connect to the VPN ==

      # Get the VPN server DNS, copy the name between '<VpnServer>' tags
      cd client-download
      grep -rni VpnServer


**Setup Networking GUI Plugin**

To setup the GUI, follow the [instructions here](https://docs.microsoft.com/en-us/azure/vpn-gateway/point-to-site-vpn-client-configuration-azure-cert#install).

Summary:
- Open the Network Manager Ubuntu GUI
- Add a new `VPN` connection, make sure it is the `IPsec/IKEv2 (strongswan)` connection
- Add the `[client]Cert.pem`, `[client]Key.pem` and the VPN server DNS name between `<VpnServer>` tags (from the previous step).
- Select `Request an inner IP address`
- Select the VPN connection

Verify:

        # you should see an IP that is in the range of the VPN subnet
        ifconfig

**Connect to your VM using VPN**

        # ssh into your VM
        ssh [username]@[private IP]

**Error: Permision denined**

        # ssh into your VM with the identify file specified
        ssh -i /home/$USER/.ssh/path/to/id_rsa [username]@[private IP]

**Error: Too many authentication failures**

        ssh -o IdentitiesOnly=yes [username]@[private IP]

## Remove Example Terraform Project from Azure

- **WARNING:** Be careful on what resource group you are destroying!! Do not destroy something shared by other.

        cd ~/deploy_ws/operations/deploy/azurebooks/example/

        # this will destroy everything create  in the example terraform workspace
        terraform destroy

        # remove all the terraform state files
        rm -rf .terraform
        rm terraform.tfstate terraform.tfstate.backup

## Remote Desktop

The given terraform example setup already has remote desktop port enabled. The user only needs to install rdp package dependencies on the remote server and local client.

**Connect to your VM using VPN**

        # ssh into your VM
        ssh [username]@[private IP]

**Install desktop enviornment on remote host**

        sudo apt-get update
        sudo apt-get -y install xfce4
        sudo apt-get -y install xrdp
        sudo systemctl enable xrdp
        echo xfce4-session >~/.xsession
        sudo service xrdp restart

**Create the RDP client script**

        # install rdp client dependency
        sudo apt-get install rdesktop

        # edit the params here:
        vim operations/deploy/scripts/example-remote-desktop.bash

        # close the script & make it executable
        chmod +x my-rdp-client.bash

        # connect to rdp server
        ./my-rdp-client.bash
