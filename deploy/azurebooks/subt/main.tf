# // /////////////////////////////////////////////////////////////////////////////
# Setup the cloud provider
# // /////////////////////////////////////////////////////////////////////////////
provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x. 
  # If you're using version 1.x, the "features" block is not allowed.
  version = "~>2.0"
  features {}
  
  # setup credentials
  subscription_id = var.subscription_id
  tenant_id = var.tenant_id
}

# // /////////////////////////////////////////////////////////////////////////////
# @brief Terraform Backend
# Note: Variables are not allowed, everything must be statically written.
# // /////////////////////////////////////////////////////////////////////////////
terraform {
  # setup the backend remote for maintaining state file storage
  
  backend "azurerm" {

    # existing storage account (make sure exists on azure)
    storage_account_name = "subtdeployterrastate"

    # existing storage container
    container_name       = "subtdeploy-statefile-container"

    # resource group, for the storage account
    resource_group_name  = "SubT"

    # path to the statefiles on the remote backend storage container
    # !! -- PLEASE CHANGE THE USERNAME (azure username) -- !!
    key                  = "workspaces/USERNAME/terraform.tfstate"
  }
}

# // /////////////////////////////////////////////////////////////////////////////
# Load the example modules
# // /////////////////////////////////////////////////////////////////////////////
module "example" {
  source = "./modules/"

  # // /////////////////////////////////////////////////////////////////////////////
  # Resource & Network Settings
  # // /////////////////////////////////////////////////////////////////////////////
  
  # use existing resource group name
  user_defined_resource_group_name = "SubT"

  # name prefix to be used for all resources
  resource_name_prefix    = "SubT"
  
  # tag prefix
  # !! -- PLEASE CHANGE THE USERNAME (azure username) -- !!
  tag_name_prefix         = "tag-USERNAME-example"

  # resource VNET, address space
  vnet_address_space      = "10.3.0.0/16"

  # resource SUBNET, example subnet address space with above VNET
  subnet_address_space    = "10.3.0.0/22"

  # rsource SUBNET, gateway
  gateway_address_subnet  = "10.3.10.0/24"

  # vpn settings
  vpn_address_space       = "10.2.0.0/24"

  # vpn ca certificate
  # !! -- PLEASE CHANGE VPN CA CERTIFCATE -- !!
  vpn_ca_cert             = "YOUR VPN CA CERTIFICATE GOES HERE"

  # // /////////////////////////////////////////////////////////////////////////////
  # VM Settings
  # // /////////////////////////////////////////////////////////////////////////////

  # location of local ssh key to connect to remove VM
  vm_pub_ssh_key          = "~/.ssh/azure_vpn.pub"
}
