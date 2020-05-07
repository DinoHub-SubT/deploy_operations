# Cloud Operation Tools

[TOC]

There are two operational tools available to use: `az` or `terraform`

- `az` is the [azure commandline interface](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest)

- `terraform` is the [terraform command line interface](https://learn.hashicorp.com/terraform) to interact with `terraform` files found in `operations/deploy/azurebooks`

## Prerequisites

**Bitbucket SSH Keys**

- Generate ssh keys for azure vms:

        mkdir -p ~/.ssh/
        cd ~/.ssh/
        ssh-keygen

    - Answer the prompts from `ssh-keygen` as shown below:
        
            Enter file in which to save the key (/home/<USER-NAME>/.ssh/id_rsa): /home/<USER-NAME>/.ssh/azure_vpn
            Enter passphrase (empty for no passphrase):

    - **DO NOT ENTER A PASSPHRASE on `ssh-keygen`! LEAVE IT BLANK.**
    - Replace `<USER-NAME>` with your actual username

**About Connection Keys**

You will have a total of three types of connection keys:

- Bitubcket ssh key, used to clone repos from the subt bitbucket account.
    - Found in `/home/<USER-NAME>/.ssh/bitbucket`
- Azure VM ssh key, used to connect to the Azure VMs.
    - Found in ` /home/<USER-NAME>/.ssh/azure_vpn`
- Azure VPN certificates, used to connect to the Azure VPN setup.
    - Found in: `/home/<USER-NAME>/.ssh/azure/vpn`

Please **keep the default paths** as discussed in the readme instructions. 
- Some of these paths are hard-coded in scripts. If you do not wish to use these paths, please notify the maintainer to discuss which hard-coded values must be changed.

* * *

## Mini-Tutorial: Terraform Example Project

This terraform example will create Virtual Machines, Networking and VPN setup on Azure.

- You will be able to ssh into the VM (using the private IP) over VPN.

**Things to keep in mind:**

- The `azure username` to be used in this tutorial, is the *user name* found before your `@...hotmail.onmicrosoft.com` account email.

- The `azure resource group` that will be used in this tutorial is `SubT`.


### Terraform Subt Project Prerequisites

**Azure CLI Initial Login**

        # az login will prompt a browser window. Enter your user credentials to login.
        az login

**Aad you subscription and tenant ids as environment variables**

        # List the ids
        az account list

        # Open bashrc or zshrc
        gedit ~/.bashrc

        # write the subscription id
        export TF_VAR_subscription_id=SUBSCRIPTION_ID_GOES_HERE
        # write the tenant id
        export TF_VAR_tenant_id=TENANT_ID_GOES_HERE

**Export your subscription and tenant ids as environment variables in your current terminal**

Source your `bashrc` or `zshrc` directly:

        # source bashrc directly
        source ~/.bashrc

        # source zshrc directly
        source ~/.zshrc

### Deploy Terraform SubT Project

**All terraform commands must be done in the `azurebooks/subt` directory workspace**.

- Go to the terraform workspace

        cd ~/deploy_ws/src/operations/deploy/azurebooks/subt
    
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
        
        # Copy the output to the 'vpn_ca_cert' variable in 'subt/main.tf'
        openssl x509 -in caCert.pem -outform der | base64 -w0 ; echo

        # == Create the user certificate ==

        # Change 'password' to something more secure 
        export PASSWORD="password"
        # Change 'username' to your username (change to your azure username)
        export USERNAME="client"

        # generate the user certificate
        ipsec pki --gen --outform pem > "${USERNAME}Key.pem"
        ipsec pki --pub --in "${USERNAME}Key.pem" | ipsec pki --issue --cacert caCert.pem --cakey caKey.pem --dn "CN=${USERNAME}" --san "${USERNAME}" --flag clientAuth --outform pem > "${USERNAME}Cert.pem"

        # generate the p12 bunder
        openssl pkcs12 -in "${USERNAME}Cert.pem" -inkey "${USERNAME}Key.pem" -certfile caCert.pem -export -out "${USERNAME}.p12" -password "pass:${PASSWORD}"

- Personalize the variables

        # Go back to the deploy repo azurebooks
        cd ~/deploy_ws/src/operations/deploy/azurebooks/subt

        # Edit the main entrypoint terraform configuration file
        gedit ~/deploy_ws/src/operations/deploy/azurebooks/subt/main.tf

    - Change `terraform:key` to include your azure username

    - Change `resource_name_prefix` to your preference

    - Change `tag_name_prefix` to your preference

    - Change `vpn_ca_cert`  to the output seen in the terminal in the previous *Setup the VPN Connection certificates* step.

        - if you do not want to setup vpn, you can leave this variable with the default contents.

    - Do not change `vm_pub_ssh_key`. Use the default path that is already setup terraform `main.tf`. Please make sure this key exists on your localhost. This is the ssh key used to access the Azure VMs.
    
        - default ssh key path: `/home/<USER-NAME>/.ssh/azure_vpn`

- Dry-run the terraform deployment

        # Shows the user the azure deployment
        terraform plan

    - **Errors:** if you see `"Error: Initialization required. Please see the error message above."`, please do `terraform init` again.
  
- Apply the terraform infrastructure setup to Azure

        # will create all the resources on azure
        terraform apply

- Complete the **VPN Connection** steps shown below (if you want VPN connection).

    - Complete only the *vpn setup* steps that are not already done. If following the above steps, you can directly go to the **Download the VPN Client** step and continue from there.

You should now have an example resources deployed on azure. 

- You can verify your setup by going on the [portal.azure.com](https://portal.azure.com/#home) website, navigate to the `SubT` resource group and finding your newly created resources.

* * *

## VPN Connection

### Ubuntu

The below instructions can be found on [azure tutorials](https://docs.microsoft.com/en-us/azure/vpn-gateway/point-to-site-vpn-client-configuration-azure-cert) for reference.
  
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

        gedit ~/deploy_ws/src/operations/deploy/azurebooks/subt/main.tf

        # change `vpn_ca_cert` to the output seen in the terminal

**Apply Changes to Azure**

      # apply the VPN gateway, this can take up to 30 minutes, just for the VPN. It can be longer if setting up more resources
      cd ~/deploy_ws/src/operations/deploy/azurebooks/subt/

      # Dry-run: shows the user the azure deployment
      terraform plan
      
      # Apply the terraform setup to azure
      terraform apply

**Download the VPN Client**

      # go to a ssh folder to contain your vpn keys
      cd ~/.ssh/azure/vpn

      # Get the vpn client, this will output a https link, please remember it!
      #   - the 'vnet gateway name' is: [resource_name_prefix]-vnet-gateway
      #   - where the 'resource_name_prefix' was set in the 'subt/main.tf' in the previous steps
      #   - an example would be: kat-example-vnet-gateway
      az network vnet-gateway vpn-client generate --name [vnet gateway name] --processor-architecture x86 --resource-group SubT

      # download the client (without brackets)
      # if the wget command does not work, put the https link (from the previous step) in your browser and download it to '~/.ssh/azure/vpn' location
      wget --directory-prefix=. [https path from previous command WITHOUT QUOTES ]

      # unzip the vpn client package
      #   - its okay to ignore the warnings '1 archive had warnings but no fatal errors.'
      unzip -j -d client-download [downloaded.zip]

      # == Connect to the VPN ==

      # Get the VPN server DNS, copy the name between '<VpnServer>' tags
      cd client-download
      grep -rni VpnServer


**Setup Networking GUI Plugin**

To setup the GUI, please follow the [instructions here](https://docs.microsoft.com/en-us/azure/vpn-gateway/point-to-site-vpn-client-configuration-azure-cert#install).

Summary of above link (please use the link):

- Open the Network Manager Ubuntu GUI

- Add a new `VPN` connection, make sure it is the `IPsec/IKEv2 (strongswan)` connection

- Add the `[client]Cert.pem`, `[client]Key.pem` and the VPN server DNS name between `<VpnServer>` tags (from the previous step).

- Select `Request an inner IP address`

- Select the VPN connection

- Select the folder icon at the end of the Certificate field, browse to the Generic folder, and select the VpnServerRoot file.

**Connect to your VM using VPN**

        # ssh into your VM
        ssh [username]@[private IP]

- **To find the IP:**

    - Go to the Azure Portal Website
    
    - Or, run the command below, with `resource_name_prefix` as set previously in `subt/main.tf`:

            az vm list-ip-addresses -g SubT -o table | grep [resource_name_prefix]

**Example Errors**

- Permision denined

        # ssh into your VM with the identify file specified
        ssh -i /home/$USER/.ssh/path/to/id_rsa [username]@[private IP]

- Too many authentication failures

        ssh -o IdentitiesOnly=yes [username]@[private IP]

- For ssh errors, it might be easier to setup an [ssh connection setup](https://www.digitalocean.com/community/tutorials/how-to-configure-custom-connection-options-for-your-ssh-client) in `~/.ssh/config`

* * *

## Remote Desktop

The subt terraform example has remote desktop port enabled.
  - The user needs to install `rdp` package dependencies on the VM and on the localhost client

**Connect to your VM using VPN**

        # ssh into your VM
        ssh [username]@[private IP]

- **To find the IP:**

    - Go to the Azure Portal Website
    
    - Or, run the command below, with `resource_name_prefix` as set previously in `subt/main.tf`:

            az vm list-ip-addresses -g SubT -o table | grep [resource_name_prefix]

**Install desktop enviornment (remote host VM)**

        sudo apt-get update
        sudo apt-get -y install xfce4
        sudo apt-get -y install xrdp
        sudo systemctl enable xrdp
        echo xfce4-session >~/.xsession
        sudo service xrdp restart

**Create the RDP client script (localhost)**

        # install rdp client dependency
        sudo apt-get install rdesktop

        # edit the params here:
        vim operations/deploy/scripts/example-remote-desktop.bash

        # close the script & make it executable
        chmod +x my-rdp-client.bash

        # connect to rdp server
        ./my-rdp-client.bash

- `rdp` requires a password. There is no password setup for the default user.

    - Continue with the build tutorials where the `ansible` scripts will set a default password in the VMs for you.
    - Or, set the `subt` user's password manually in the VM.

- `rdp` services needs to be restarted on VM reboot:

    - Continue with the build tutorials where the `ansible` scripts will setup the `xrdp` service to start on VM boot for you.

    - Or restart the service manually in the VM:

            sudo systemctl enable xrdp
            echo xfce4-session >~/.xsession
            sudo service xrdp restart

* * *

# Discussion

## Changing Terraform Files

You should become comfortable creating or updating terraform files.

- A simple next example you can try out is adding another VM terraform file with username/password setup.

Any changes to the terraform files, requires updating the terraform workspace

        # Dry-run: shows the user the azure deployment
        terraform plan


Apply the changes to the cloud

        # Apply the terraform setup to azure
        terraform apply

## Remove Terraform Created Resources from Azure

**WARNING: Be careful what resource group or resources you are destroying!!**

- Be careful not destroy another user's resources (**always check** the command line variable names or nested resource links).

**Example:** Remove an existing Virtual Machine:

        cd ~/deploy_ws/src/operations/deploy/azurebooks/subt/

        # this will destroy everything create  in the example terraform workspace
        terraform destroy

        # remove a specific terraform resource (example)
        # note: terraform does not remove linked resources, only the resource explicitly specified
        terraform destroy -target module.example.azurerm_linux_virtual_machine.ugv1

        # remove multiple terraform resources
        terraform destroy -target module.example.azurerm_linux_virtual_machine.ugv1 \
                -target module.example.azurerm_network_interface_security_group_association.ugv1 \
                -target module.example.azurerm_network_interface.ugv1

Always, verify on the Azure Portal that your resources have been destroyed.

- Sometimes, the above steps can result in errors. Or it might not report any errors, but the resource might still exist on the portal.
- Go to the Azure portal and directly remove the resource if its still exists.

**WARNING:** Synchronization errors can occur when removing azure resources directly on the portal, but without removing using terraform.
  
- If terraform does not find those resources on Azure it might not be able to sync its `terraform state` files correctly.
- Always remove the resources using terraform first. If there is a failure, then remove the resource on the azure portal website directly.


## Useful Azure Command Line (az) Commands

*Feel free to add more useful commands here.*

List your user account information:

      az account list

List all resource groups available:
    
      az group list -o table

List all resources for the `SubT` resource group:
      
      az resource list -g SubT -o table

List all resources for the `SubT` resource group, matching pattern:

      # template: az resource list -g SubT -o table | grep [pattern]
      # example, with pattern:
      az resource list -g SubT -o table | grep kat

List the IPs Virtual Machines found in `SubT` resource group:

      az vm list-ip-addresses -g SubT -o table

List the IPs Virtual Machines found in `SubT` resource group, matching prefix:

      az vm list-ip-addresses -g SubT -o table | grep [pattern]

List the public IPs found in `SubT` resource group, matching prefix:

      # template: az resource list -g SubT -o table | grep [pattern]
      # example, with pattern:
      az network public-ip list -g SubT -o table | grep kat
