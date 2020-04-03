# Cloud Operation Tools

## Prerequisites

**Bitbucket SSH Keys**

- Generate ssh keys for azure vms:

        mkdir -p ~/.ssh/
        cd ~/.ssh/
        ssh-keygen

    - Please answer the prompts from `ssh-keygen` as shown below:
        
            Enter file in which to save the key (/home/<USER-NAME>/.ssh/id_rsa): /home/<USER-NAME>/.ssh/azure_vpn
            Enter passphrase (empty for no passphrase):

    - **DO NOT ENTER A PASSPHRASE on `ssh-keygen`! LEAVE IT BLANK.**
    - Please replace `<USER-NAME>` with your actual username


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

All terraform commands must be done in the `azurebooks/example` directory workspace

- Go to the terraform workspace

        cd ~/deploy_ws/operations/deploy/azurebooks/example
    
- Initialize the terraform workspace

        terraform init

- Setup the **VPN Connection** certificates

        # == Install Dependency Libraries ==
        sudo apt-get update
        sudo apt-get install strongswan strongswan-pki libstrongswan-extra-plugins network-manager-strongswan

        # == Create the Root & User Certificates ==
        
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

- Personalize the variables

        # Go back to the deploy repo azurebooks
        cd ~/deploy_ws/operations/deploy/azurebooks/example

        # Edit the main entrypoint terraform configuration file
        gedit ~/deploy_ws/src/operations/deploy/azurebooks/example/main.tf

    - Change `resource_name_prefix` to your preference

    - Change `tag_name_prefix` to your preference

    - Change `hostname` to your preference

    - Change `username` to your preference

    - Change `vm_pub_ssh_key` to the the ssh key path generated in the *Bitbucket SSH Keys steps*
    
        - example key path: `/home/<USER-NAME>/.ssh/azure_vpn`
        
    - Change `vpn_ca_cert`  to the output seen in the terminal in the previous *Setup the VPN Connection certificates* step.

        - if you do not want to setup vpn, you can leave this variable with the default contents.

- Dry-run the terraform deployment

        # Shows the user the azure deployment
        terraform plan

- Apply the terraform deployment

        # will create all the resources on azure
        terraform apply

- Please complete the **VPN Connection** steps shown below (if you want VPN connection).

    - Complete only the *vpn setup* steps that are not already done. If following the above steps, you can directly go to *Download the VPN Client* step and continue from there.

You should now have an example resources deployed on azure.

### Changing Terraform Files

Any changes to the terraform files, requires updating the terraform workspace

        # Dry-run: shows the user the azure deployment
        terraform plan


After `plan`, apply the changes to the cloud

        # Apply the terraform setup to azure
        terraform apply

* * *

## VPN Connection

### Ubuntu

The below instructions can be found on [azure tutorials](https://docs.microsoft.com/en-us/azure/vpn-gateway/point-to-site-vpn-client-configuration-azure-cert)
  
  - Please follow the below instructions and use the *azure tutorials* only when running into issues or for more background information.

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

**Update personalized terraform variables**


Change the personalized cert key variable in the `main.tf` terraform:

        gedit ~/deploy_ws/operations/deploy/azurebooks/example/main.tf

        # change `vpn_ca_cert` to the output seen in the terminal

Apply Change to Azure

      # apply the VPN gateway, this can take up to 30 minutes, just for the VPN. It can be longer if setting up more resources
      cd ~/deploy_ws/operations/deploy/azurebooks/example/
      # Dry-run: shows the user the azure deployment
      terraform plan
      # Apply the terraform setup to azure
      terraform apply

**Download the VPN Client**

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

**Connect to your VM using VPN**

        # ssh into your VM
        ssh [username]@[private IP]

**Example Errors**

- Permision denined

        # ssh into your VM with the identify file specified
        ssh -i /home/$USER/.ssh/path/to/id_rsa [username]@[private IP]

- Too many authentication failures

        ssh -o IdentitiesOnly=yes [username]@[private IP]

- For ssh errors, it might be easier to setup an [ssh connection setup](https://www.digitalocean.com/community/tutorials/how-to-configure-custom-connection-options-for-your-ssh-client) in `~/.ssh/config`

* * *

## Remove Terraform Project from Azure

- **WARNING:** Be careful on what resource group you are destroying!! Be carefult not destroy other user resources (always check command line variable names or nested resource links).

        cd ~/deploy_ws/operations/deploy/azurebooks/example/

        # this will destroy everything create  in the example terraform workspace
        terraform destroy

        # remove all the terraform state files
        rm -rf .terraform
        rm terraform.tfstate terraform.tfstate.backup

* * *

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
