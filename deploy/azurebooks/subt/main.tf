# // /////////////////////////////////////////////////////////////////////////////
# Setup the cloud provider
# // /////////////////////////////////////////////////////////////////////////////
provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x. 
  # If you're using version 1.x, the "features" block is not allowed.
  version = "~>2.0"
  features {}
  
  # setup credentials
  # -- please have these variables set in your ~/.bashrc (or ~/.zshrc)
  subscription_id   = var.subscription_id
  tenant_id         = var.tenant_id

  # skip provider registration
  skip_provider_registration  = "true"
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
  user_defined_resource_group_name  = "SubT"

  # set the resource location
  resource_location                 = "eastus"

  # name prefix to be used for all resources
  # !! -- PLEASE CHANGE THE USERNAME (azure username) -- !!
  resource_name_prefix              = "USERNAME-example"
  
  # tag prefix
  # !! -- PLEASE CHANGE THE USERNAME (azure username) -- !!
  tag_name_prefix                   = "tag-USERNAME-example"

  # resource VNET, address space
  vnet_address_space                = "10.3.0.0/16"

  # resource SUBNET, example subnet address space with above VNET
  subnet_address_space              = "10.3.0.0/22"

  # rsource SUBNET, gateway
  gateway_address_subnet            = "10.3.10.0/24"

  # vpn settings
  vpn_address_space                 = "10.2.0.0/24"

  # vpn ca certificate
  # !! -- PLEASE CHANGE VPN CA CERTIFCATE -- !!
  vpn_ca_cert                       = "YOUR VPN CA CERTIFICATE GOES HERE" 

  # // /////////////////////////////////////////////////////////////////////////////
  # VM Settings
  # // /////////////////////////////////////////////////////////////////////////////

  # location of local ssh key to connect to remote VM
  #   -- remember to to keep the '.pub' suffix.
  # !! -- PLEASE CHANGE AZURE SSH KEY -- !!
  vm_pub_ssh_key                    = "~/.ssh/azure_vpn.pub"

  # // /////////////////////////////////////////////////////////////////////////////
  # Number Of Robot VMs To Create
  # // /////////////////////////////////////////////////////////////////////////////

  # !! -- PLEASE CHANGE THE TOGGLE TO YOUR PREFERENCE -- !!
  # Recommendation:
  #   - Please keep 'basic' enabled always.
  #   - Enable 'perception' if you wish to test perception simulation.
  #   - Enable 'coord' if you wish to test the full coordination simulation.
  
  # About:
  #   - basic simulation:         basestation, ugv1, uav1
  #   - perception simulation:    perception
  #   - coordination simulation:  ugv2, ugv3, ..., uav2, uav3, ...
  # Comments:
  #   - ENABLING ALL: creates the entire full simulation
  #   - DISABLE ANY: will remove that set of VMs from azure

  # Create all the robot VMs for basic simulation setup
  # Robot VMs: basestation, ugv1, uav1
  #   -- Enable: 1 == true
  #   -- Disable: 0 == false
  basic_robots_toggle                 = 1

  # Create all the robot VMs for full coordination simulation setup
  # Robot VMs: ugv2, ugv3, ..., uav2, uav3, ...
  #   -- Enable: 1 == true
  #   -- Disable: 0 == false
  perception_robots_toggle            = 0

  # Create all the robot VMs for full coordination simulation setup
  # Robot VMs: ugv2, ugv3, ..., uav2, uav3, ...
  #   -- Enable: 1 == true
  #   -- Disable: 0 == false
  coord_robots_toggle                 = 0
}
