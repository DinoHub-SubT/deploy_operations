# Cloud Operation Tools

## Example Walkthrough

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

You should now have an example resources deployed on azure.

**Changing Terraform Files**

Any changes to the terraform files, requires updating the terraform workspace

        terraform plan


After `plan`, apply the changes to the cloud

        terraform apply

## VPN Connection To Private Resources
