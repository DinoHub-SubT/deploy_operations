# Cloud Operation Tools

[TOC]

There are two operational tools available to use: `az` or `terraform`

- `az` is the [azure commandline interface](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest)

- `terraform` is the [terraform command line interface](https://learn.hashicorp.com/terraform) to interact with `terraform` files found in `operations/deploy/azurebooks`

## Prerequisites

**Azure SSH Keys**

- Generate ssh keys for azure vms:

        mkdir -p ~/.ssh/
        cd ~/.ssh/
        ssh-keygen

    - Answer the prompts from `ssh-keygen` as shown below:

            Enter file in which to save the key (/home/<USER-NAME>/.ssh/id_rsa): /home/<USER-NAME>/.ssh/azure_vpn
            Enter passphrase (empty for no passphrase):

    - **DO NOT ENTER A PASSPHRASE on `ssh-keygen`! LEAVE IT BLANK.**
    - Replace `<USER-NAME>` with your actual username

- Add the ssh azure vpn key to your localhost ssh config file:

        # create (if not created) ssh config file
        touch ~/.ssh/config

        # open the ssh config file
        gedit ~/.ssh/config

        # Add the following to the top of the config file:
        IdentityFile ~/.ssh/azure_vpn

        # exit the ssh config file

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

- Always source your `~/.bashrc` or `~/.zshrc` when changing the terraform personalized variables.

Your terraform subt workspace is located at:

        cd ~/deploy_ws/src/operations/deploy/azurebooks/subt

### Terraform Subt Project Prerequisites

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
        # - go to the given webpage "https://microsoft.com/devicelogin"
        # - then enter the given "CODE" in your browser.
        # - then select your Azure user account (if prompted).

- You can find more information about azcopy login [here](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10).

**Azure Docker Registry Login**

        # login to the subt docker registry
        az acr login --name subtexplore

**Setup the VPN certificates**

        # Create the Root & User Certificates
        subtf_cert.sh

**Add your Azure user info to terraform ids**

        # Install the terraform environment variables
        install-terraform-current.sh

        # Modify the variables in .terraform_id.bashrc to match your setup
        # Set TF_VAR_subscription_id and TF_VAR_tenant_id to what the results of az account list
        # Then set TF_VAR_azure_username to the username provided by Kat
        # Set TF_VAR_azure_resource_name_prefix to your prefered prefix (usually your andrew ID, must be unique to you)
        # Set TF_VAR_azure_vpn_cert to the output of the openssl command from above
        gedit ~/.terraform_id.bashrc

**Personalize your Azure setup**

        # Modify the common terraform flags
        # - Keep the default `region` value. However you can change the region if you wish to.
        # - Change `*_create_vm` to create the VM or not (if VM already exists, setting to false will destroy the VM)
        # - Change `*_disk_size` to the disk size for each VM type (default values are already set).
        # - Change `*_vm_instance` to the type of VM instance to create (default values are already set).
        gedit ~/.terraform_flags.bashrc

**Source your `bashrc` or `zshrc`**:

        # source bashrc
        source ~/.bashrc

        # source zshrc
        source ~/.zshrc

### Deploy Terraform SubT Project

**Initialize the terraform workspace**

        subtf_init.sh

**Dry-run the terraform deployment**

        # Shows the user the azure deployment
        subtf_plan.sh

- Errors: if you see `"Error: Initialization required. Please see the error message above."`, please do `subtf_init.sh` again.

**Apply the terraform infrastructure setup to Azure**

        # will create all the resources on azure
        subtf_apply.sh

- **Errors:** if you see `OperationNotAllowed ... quota limits`, **please notify the maintainer to increase quota limits**.

**Add the VPN connection to the network manager**

        subtf_mkvpn.sh -n

- See the "Create a VPN Connection" and "Destroy an existing VPN Connection" below for VPN maintenance.

**Verify your VMs are created**

- Go to the Azure Portal Website

- Or, run the command below, with `resource_name_prefix` as set previously in `~/.terraform_flags.bashrc`:

        az vm list-ip-addresses -g SubT -o table | grep [resource_name_prefix]

**Connect to your VM (over the VPN)**

        # verify you can connect to the Azure VM
        ping [ private IP ]

        # ssh into your VM (default username for all the VMs is: subt)
        ssh subt@[private IP]

- if you have issues pinging the VMs, please check your VPN connection.
- if you have issues ssh into the VMs, please see the `Issues` title below.

You should now have resources deployed on Azure and be able to connect to them.

* * *

# Discussion

## Changing Terraform Files

You should become comfortable creating or updating terraform files.

- A simple next example you can try out is adding another VM terraform file with username/password setup.

Any changes to the terraform files, requires updating the terraform workspace

        # Dry-run: shows the user the azure deployment
        subtf_plan.sh

Apply the changes to the cloud

        # Apply the terraform setup to azure
        subtf_apply.sh

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

**More discussion**

For solving ssh errors, it might be easier to setup an [ssh connection setup](https://www.digitalocean.com/community/tutorials/how-to-configure-custom-connection-options-for-your-ssh-client) in `~/.ssh/config`

