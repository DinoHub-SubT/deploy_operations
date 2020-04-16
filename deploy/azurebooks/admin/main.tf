# // /////////////////////////////////////////////////////////////////////////////
# @brief Setup the cloud provider
# // /////////////////////////////////////////////////////////////////////////////
provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x. 
  # If you're using version 1.x, the "features" block is not allowed.
  version = "~>2.0"
  features {}
  
  # setup credentials
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

# // /////////////////////////////////////////////////////////////////////////////
# @brief Terraform Backend
# Note: Variables are not allowed, everything must be statically written.
# // /////////////////////////////////////////////////////////////////////////////
terraform {
  # setup the backend remote for maintaining state file storage
  
  backend "azurerm" {

    # existing storage account
    storage_account_name = "katexampleterrastate"

    # existing storage container
    container_name       = "katexample-statefile-container"

    # resource group, for the storage account
    resource_group_name  = "kat-example"

    # path to the statefiles on the remote backend storage container
    key                  = "workspaces/kat/terraform.tfstate"
  }
}

# // /////////////////////////////////////////////////////////////////////////////
# @brief Load & setup modules
# // /////////////////////////////////////////////////////////////////////////////
module "admin" {

  # load module
  source = "./modules/"

  # // /////////////////////////////////////////////////////////////////////////////
  # Resource Group -- create a new resource group
  # // /////////////////////////////////////////////////////////////////////////////
  
  # name for new resource group to be created
  new_project_resource_group_name   = "kat-example"
  
  # create the resource group toggle -- 0 == false, 1 == true
  resource_group_toggle_creation    = 0

  # // /////////////////////////////////////////////////////////////////////////////
  # Storage State -- create a new storage account for storing terraform state files
  # // /////////////////////////////////////////////////////////////////////////////

  # resource group for state storage account
  state_resource_group              = "kat-example"

  # storage account name for terraform state files (only lower case allowed)
  state_storage_name_prefix         = "subtdeploy"

  # tag prefix
  tag_name_prefix                   = "kat-example"
}
