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
    # we will not actually fill this out since it must be static... this will prevent
    # each user from having a different version of this file...
    # key                  = "workspaces/${var.azure_username}/terraform.tfstate"
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
  resource_location                 = var.region

  # name prefix to be used for all resources
  # !! -- PLEASE CHANGE THE USERNAME (azure username) -- !!
  resource_name_prefix              = var.azure_resource_name_prefix

  # tag prefix
  # !! -- PLEASE CHANGE THE USERNAME (azure username) -- !!
  tag_name_prefix                   = var.azure_resource_name_prefix

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
  vpn_ca_cert                       = var.azure_vpn_cert

  # // /////////////////////////////////////////////////////////////////////////////
  # General VM Settings
  # // /////////////////////////////////////////////////////////////////////////////

  # location of local ssh key to connect to remote VM
  #   -- PLEASE DO NOT CHANGE!! KEEP THE DEFAULT PATH!!
  vm_pub_ssh_key                    = "~/.ssh/azure_vpn.pub"

  # VM disk sizes (in GB)
  # !! -- PLEASE CHANGE THE VALUE TO YOUR PREFERENCE -- !!
  basestation_disk_size             = var.basestation_disk_size
  ugv_disk_size                     = var.ugv_disk_size
  uav_disk_size                     = var.uav_disk_size
  perception_disk_size              = var.perception_disk_size

  # VM instance types
  # !! -- PLEASE CHANGE THE VALUE TO YOUR PREFERENCE -- !!
  ugv_vm_instance                   = var.ugv_vm_instance
  uav_vm_instance                   = var.uav_vm_instance
  perception_vm_instance            = var.perception_vm_instance
  # Basestation available options:
  #   - choose 'Standard_F8s_v2' to only test the GUI only for the basestation
  #   - choose 'Standard_NC6' to create a GPU VM, in order to build the perception workspace for the basestation
  basestation_cpu_vm_instance       = var.basestation_cpu_vm_instance
  basestation_gpu_vm_instance       = var.basestation_gpu_vm_instance

  # // /////////////////////////////////////////////////////////////////////////////
  # VM Creation -- number of VMs to create options
  # // /////////////////////////////////////////////////////////////////////////////

  # Create the Basestation VMs
  # !! -- PLEASE CHANGE THE VALUE TO YOUR PREFERENCE -- !!
  basestation_create_vm             = var.basestation_create_vm

  # Basesation: create a GPU or CPU VM
  #   - set true:   when choosing to create a GPU VM instance (such as 'Standard_NC6')
  #   - set false:  when choosing to create a CPU only VM instance (such as 'Standard_F8s_v2')
  # -- note: your VM instaces types are defined by `basestation_cpu_vm_instance` and `basestation_gpu_vm_instance`
  basestation_enable_gpu            = var.basestation_enable_gpu

  # Create the UGV VMs
  # !! -- PLEASE CHANGE THE VALUES TO YOUR PREFERENCE -- !!
  ugv1_create_vm                    = var.ugv1_create_vm
  ugv2_create_vm                    = var.ugv2_create_vm
  ugv3_create_vm                    = var.ugv3_create_vm

  # Create the UAV VMs
  # !! -- PLEASE CHANGE THE VALUES TO YOUR PREFERENCE -- !!
  uav1_create_vm                    = var.uav1_create_vm
  uav2_create_vm                    = var.uav2_create_vm
  uav3_create_vm                    = var.uav3_create_vm
  uav4_create_vm                    = var.uav4_create_vm

  # Create the Perception VMs
  # !! -- PLEASE CHANGE THE VALUES TO YOUR PREFERENCE -- !!
  perception1_create_vm             = var.perception1_create_vm
}
