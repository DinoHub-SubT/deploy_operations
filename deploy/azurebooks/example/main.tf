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
  # client_id = var.client_id
  # client_secret = var.client_secret
  tenant_id = var.tenant_id
}

# // /////////////////////////////////////////////////////////////////////////////
# Load the example modules
# // /////////////////////////////////////////////////////////////////////////////
module "example" {
  source = "./modules/"

  # // /////////////////////////////////////////////////////////////////////////////
  # Resource & Network Settings
  # // /////////////////////////////////////////////////////////////////////////////
  
  # name prefix to be used for all resources
  resource_name_prefix = "kat-example"
  # tag prefix
  tag_name_prefix="tag-kat-example"

  # resource VNET, address space
  vnet_address_space = "10.0.0.0/16"

  # resource SUBNET, example subnet address space with above VNET
  subnet_address_space = "10.0.2.0/24"

  # // /////////////////////////////////////////////////////////////////////////////
  # VM Settings
  # // /////////////////////////////////////////////////////////////////////////////
  
  # hostname of example VM
  hostname = "kat-computer"

  # username of example VM
  username = "kat"

  # location of local ssh key to connect to remove VM
  vm_pub_ssh_key = "/home/katarina/.ssh/azure_id_rsa.pub"
  
}