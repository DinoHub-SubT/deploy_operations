# Cloud Operation Tools

[TOC]

## About

There are two operational tools available to use: `az` or `terraform`

- `az` is the [azure commandline interface](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest)

- `terraform` is the [terraform command line interface](https://learn.hashicorp.com/terraform) to interact with `terraform` files found in `operations/azurebooks`

This terraform example will create Virtual Machines, Networking and VPN setup on Azure.

- You will be able to ssh into the VM (using the private IP) over VPN.

**Things to keep in mind:**

- The `azure username` to be used in this tutorial, is the **user name** found before your `@...hotmail.onmicrosoft.com` account email.

- The `azure resource group` that will be used in this tutorial is `SubT`.

- Always source your `~/.bashrc` or `~/.zshrc` when changing the terraform personalized variables.

Your terraform subt workspace is located at:

        cd ~/deploy_ws/src/operations/azurebooks/subt

## Prerequisites

Make sure the docker network on localhost is running.

To remove:

        # remove all containers (since all are using the docker network)
        subt deployer local.docker.ops.rm

        # remove the docker network
        subt deployer local.docker.network.rm

## Terraform Setup

**Azure CLI Initial Login:**

        # az login will prompt a browser window. Enter your user credentials to login.
        az login

**Find your Subscription and Tenant Ids**

        # List the ids
        az account list

        # you will see the following output:
        [
        {
            "cloudName": "AzureCloud",
            "homeTenantId": "353ab185-e593-4dd3-9981-5ffe7f5d47eb",
            "id": "a3a467d5-2467-25a3-q467-247v367q323q",
            "isDefault": true,
            "managedByTenants": [],
            "name": "Microsoft Azure Sponsorship",
            "state": "Enabled",
            "tenantId": "121cb257-a394-2cd3-2425-3ase4g5f56da",
            "user": {
              "name": "USERNAME@smash0190hotmail.onmicrosoft.com",
              "type": "user"
            }
        }
        ]

Your Subscription Id is:

        "id": "a3a467d5-2467-25a3-q467-247v367q323q"

Your Tenant id is:

        "homeTenantId": "121cb257-a394-2cd3-2425-3ase4g5f56da"

**Azcopy Initial Login**

        # azcopy login
        azcopy login --tenant-id [YOUR TENANT ID]

        # azcopy login will show the following output:
        # -> To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code [SOME KEY CODE] to authenticate.

        # Follow these steps:
        - 1. Go to the given webpage "https://microsoft.com/devicelogin"
        - 2. Then enter the given "CODE" in your browser.
        - 3. Then select your Azure user account (if prompted).

- You can find more information about azcopy login [here](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10).

**Azure Docker Registry Login**

        # login to the subt docker registry
        az acr login --name subtexplore

**Setup the VPN certificates**

        # Create the Root & User Certificates
        subt cloud terraform cert

**Add your Azure user info to terraform ids**

        # Open the terraform user account configuration file
        gedit ~/.subt/terraform_id.bashrc

        # Modify the variables in to match your azure account setup:

        - Set 'TF_VAR_subscription_id'            to what the results of az account list
        - Set 'TF_VAR_tenant_id'                  to what the results of az account list
        - Set 'TF_VAR_azure_username'             to your azure username to login into azure portal (i.e. name before the @...hotmail.onmicrosoft.com)
        - Set 'TF_VAR_azure_resource_name_prefix' to your prefered prefix (usually your andrew ID, must be unique to you. Or use the same as azure username)
        - Set 'TF_VAR_subt.d/azure_vm_rsa_cert'   to the output of the openssl command from above


**Personalize your Azure setup**

        # Open the terraform user general configuration file
        gedit ~/.subt/terraform_flags.bashrc

        # Modify the common terraform flags:

        - Set 'region'        keep the default 'region' value. However you can change the region if you wish to.
        - Set '*_create_vm'   to create the VM or not (if VM already exists, setting to false will destroy the VM)
        - Set '*_disk_size'   to the disk size for each VM type (default values are already set).
        - Set '*_vm_instance' to the type of VM instance to create (default values are already set).

**Source your `bashrc` or `zshrc`**:

        # source bashrc
        source ~/.bashrc

        # source zshrc
        source ~/.zshrc

## Deploy Terraform SubT Project

**Initialize the terraform workspace**

        subt cloud terraform init

**Dry-run the terraform deployment**

        # Shows the user the azure deployment
        subt cloud terraform plan

- Errors: if you see `"Error: Initialization required. Please see the error message above."`, please do `subt cloud terraform init` again.

**Apply the terraform infrastructure setup to Azure**

        # will create all the resources on azure
        subt cloud terraform apply

- **Errors:** if you see `OperationNotAllowed ... quota limits`, **please notify the maintainer to increase quota limits**.

**Add the VPN connection to the network manager**

        # will create the gnome network manager connection for your Azure VPN
        subt cloud terraform mkvpn -n

- (optional) See the "Create a VPN Connection" and "Destroy an existing VPN Connection" below for VPN maintenance.

**Verify your Virtual Machines are created**

        # show your started virtual machines
        subt cloud terraform list

- Alternatively, you can check on the [Azure Portal Website](https://portal.azure.com/#home).

**Connect to Virtual Machine over the VPN**

        # verify you can connect to the Azure VM
        ping [ private IP ]

        # ssh into your VM (default username for all the VMs is: subt)
        ssh subt@[private IP]

- if you have issues pinging the VMs, please check your VPN connection.
- if you have issues ssh into the VMs, please see the `Issues` title below.

**Check SSH Connection To All Virtual Machines**

        # probes all ssh connections configured in ~/.ssh/config
        subt tools ssh.probe

You should now have resources deployed on Azure and be able to connect to them.

**(Optional) Destroy all resources**

        # destroy all azure resources
        subt cloud terraform destroy

- Please verify on [Azure Portal Website](https://portal.azure.com/#home) that all your resources are destroyed.

* * *

# More Tutorials

## Updating Azure Setup

To update your Azure setup, you need to update your azure env file `~/.terraform_flags.bashrc`

The available options are such as:

- create different Azure VMs
- setup the VM disk sizes
- setup the VM instance types

Remember, everytime you change the `~/.terraform_flags.bashrc`, you will need to do:

        # source your bash or zsh rc
        source ~/.bashrc

        # terraform re-plan the changes
        subt cloud terraform plan

        # terraform apply the updates
        subt cloud terraform apply

## Starting Azure VMs

        # list available Azure VMs
        subt cloud terraform start -l

        # stop an Azure VM
        subt cloud terraform start [azure vm name]

## Starting Azure VMs

        # list available Azure VMs
        subt cloud terraform stop -l

        # stop an Azure VM
        subt cloud terraform stop [azure vm name]

## Destroy All Resources

        # destroy all terraform created Azure resources (networking, VMs, etc.)
        subt cloud terraform destroy

## Remove Specific Terraform Created Resources from Azure

**WARNING: Be careful what resource group or resources you are destroying!!**

- Be careful not destroy another user's resources (**always check** the command line variable names or nested resource links).

**Example:** Remove an existing Virtual Machine:

        cd ~/deploy_ws/src/operations/azurebooks/subt/

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
      az resource list -g SubT -o table | grep USERNAME

List the IPs Virtual Machines found in `SubT` resource group:

      az vm list-ip-addresses -g SubT -o table

List the IPs Virtual Machines found in `SubT` resource group, matching prefix:

      az vm list-ip-addresses -g SubT -o table | grep [pattern]

List the public IPs found in `SubT` resource group, matching prefix:

      # template: az resource list -g SubT -o table | grep [pattern]
      # example, with pattern:
      az network public-ip list -g SubT -o table | grep USERNAME

* * *

## Issues

**Azure Disconnection**

- The Azure VPN gets disconnected often.

- If you can no longer ping your VM, restart the VPN. It takes a few minutes and a few restarts (turn off/on your VPN connection), until you are able to connect again.

**Exceed Quota Limits**

- You can check regional quota limits:

        # template for quota limit check:
        #   -> az vm list-usage --location "[ Region Name ]" -o table

        # example, check in eastus region:
        az vm list-usage --location "East US" -o table

- If you see `OperationNotAllowed ... quota limits` during `terraform apply`, **please notify the maintainer to increase quota limits**.

**SSH Permision denined**

        # ssh into your VM with the identify file specified
        ssh -i /home/$USER/.ssh/path/to/id_rsa [username]@[private IP]

**SSH Too many authentication failures**

        ssh -o IdentitiesOnly=yes [username]@[private IP]

**SSH connection stuck**

        ssh -o MACs=hmac-sha2-256 [username]@[private IP]

If you ssh connection is still stuck, debug the issue by viewing the verbose connection log:

        ssh -v [username]@[private IP]

**Remote host identification has changed**

If you ssh into your VM and you see the following error (example):

        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
        Someone could be eavesdropping on you right now (man-in-the-middle attack)!
        It is also possible that a host key has just been changed.
        The fingerprint for the ECDSA key sent by the remote host is
        SHA256:61VpK3J5BABJa3JDbjPxtMPlnoPdMeZaOVavdpn3HT8.
        Please contact your system administrator.
        Add correct host key in /home/USERNAME/.ssh/known_hosts to get rid of this message.
        Offending ECDSA key in /home/USERNAME/.ssh/known_hosts:41
        remove with:
        ssh-keygen -f "/home/USERNAME/.ssh/known_hosts" -R "azure-uav1"
        ECDSA host key for azure-uav1 has changed and you have requested strict checking.
        Host key verification failed.

The warning is saying that you have previously `ssh-ed` into a host with the same IP, but a different machine.

Perform the first step, apply the `ssh-keygen` update:

        ssh-keygen -f "/home/USERNAME/.ssh/known_hosts" -R "azure-uav1"

Perform the next step, remove the previous host key in `know_hosts`:

        # Open the known_hosts, to the problematic line.
        # Example: /home/USERNAME/.ssh/known_hosts:41
        #   - the problamatic line is 41

        # STEP:  open the file
        gedit /home/USERNAME/.ssh/known_hosts

        # STEP: Go to line 41

        # STEP:  Remove the ENTIRE line

Perform the final step, ssh into the VM again:

        # Example, enter the Azure UAV1 VM
        ssh azure.uav1

        # When prompted:
        #   'Are you sure you want to continue connecting (yes/no)?'
        # STEP: Say 'yes'

You should not see the above error again and should be logged into the remote VM.

**Terraform Error Acquiring Lock**

If you have a corrupted terraform `state` file, you might end up with a acquiring lock error as such:

        Error locking state: Error acquiring the state lock: storage: service returned error: StatusCode=409, ErrorCode=LeaseAlreadyPresent, ErrorMessage=There is already a lease present.
        RequestId:3ea11a03-701e-0092-62a0-45c8e9000000
        Time:2020-06-18T18:46:11.9697526Z, RequestInitiated=Thu, 18 Jun 2020 18:46:11 GMT, RequestId=3ea11a03-701e-0092-62a0-45c8e9000000, API Version=2018-03-28, QueryParameterName=, QueryParameterValue=
        Lock Info:
        ID:        ac14e41a-4ca6-01e5-5f1c-36368320b3c5
        Path:      subtdeploy-statefile-container/workspaces/USERNAME/terraform.tfstate
        Operation: OperationTypePlan
        Who:       USERNAME@USER-HOSTNAME
        Version:   0.12.24
        Created:   2020-06-18 18:44:10.797134982 +0000 UTC
        Info:

        Terraform acquires a state lock to protect the state from being written
        by multiple users at the same time. Please resolve the issue above and try
        again. For most commands, you can disable locking with the "-lock=false"
        flag, but this is not recommended.


If you are the only user, using thee terraform `state` file, go ahead and force an unlock:

        terraform force-unlock <lock-id-guid>

