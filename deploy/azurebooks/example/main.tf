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
    storage_account_name = "katdeployterrastate"

    # existing storage container
    container_name       = "katdeploy-statefile-container"

    # resource group, for the storage account
    resource_group_name  = "kat-example"

    # path to the statefiles on the remote backend storage container
    # PLEASE CHANGE THE USERNAME
    key                  = "workspaces/kat/terraform.tfstate"
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
  user_defined_resource_group_name = "kat-example"

  # name prefix to be used for all resources
  resource_name_prefix    = "subt-sim"

  # tag prefix
  tag_name_prefix         = "tag-subt-sim"

  # resource VNET, address space
  vnet_address_space      = "10.0.0.0/16"

  # resource SUBNET, example subnet address space with above VNET
  subnet_address_space    = "10.0.2.0/24"

  # rsource SUBNET, gateway
  gateway_address_subnet  = "10.0.1.0/24"

  # vpn settings
  vpn_address_space       = "10.2.0.0/24"

  # vpn ca certificate
  vpn_ca_cert             = "MIIC5jCCAc6gAwIBAgIIDjS6v+UwRS0wDQYJKoZIhvcNAQELBQAwETEPMA0GA1UEAxMGVlBOIENBMB4XDTIwMDQwMTA2NTgyOFoXDTIzMDQwMTA2NTgyOFowETEPMA0GA1UEAxMGVlBOIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzEJY8vH3S8Bc5ooiUVQTYof0hwJJUgdABU3BBkUXop8g3k25YcnVY0PFBirjS/3kMNmWZMjyzA/QEFEHn2K24KKVonyJCzeFinWIJ5R33pvwYwMk62p3PTr1UWYEuaZxiwRbs8vhebRtZUgsia/tWxW7z9QuCxDfqIgohCVkpoNbQMLMMJkwzYOyVYpv1KqHfJYDdcclK6IsbgkmVS3WeFSSpJ71IbBbGnbmlXb5NSv1eSWG91Ky7a6Bay18oxajHJ7r1kZrdhWVOhiQ06Q9RG8HFTGhwHCVSciSAOInBYVnM5Poq18zvWRXNbReHBmzRbxOCk70bMZje4yeAG7UdwIDAQABo0IwQDAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUd2ESPfEKTTMLucbb38aNh+yhVFkwDQYJKoZIhvcNAQELBQADggEBAEAYkoc2M6wwlUhyjZAfs06Vs8+0pTewcIF5RtacPyioMELT+BI68CFhVd1K0MyQ2SeX6FqZtqnhx6x2qtGTYFVpmbYEdS1il1Ebg9bqMx5RE/IqVV64dBBdEOnmSX/1WxijrlLhnKFiWGy8Odnp6vA4TyaQOzNCzYW1tgFXO2znPdzBw3XGl3MLpK2MLeuOzY012lfEETcl2iQkg+zsMPdr6//biAIum+Q9d+v946T10oJmorGWPL2iUKiiLXFCkwMpiYj60mF6GpaEyKVYAv8RWepYAM2oMMlxi+1FCKpuZUAzXsd3GpKh2Oryapih9mcxPDbpHmxyPZoUvXAwGE4="

  # // /////////////////////////////////////////////////////////////////////////////
  # VM Settings
  # // /////////////////////////////////////////////////////////////////////////////
  
  # basestation VM
  basestation-username    = "subt"
  basestation-hostname    = "az-basestation"

  # uav VM
  uav-username            = "subt"
  uav-hostname            = "az-uav"
  
  # ugv VM
  ugv-username            = "subt"
  ugv-hostname            = "az-ugv"

  # location of local ssh key to connect to remove VM
  vm_pub_ssh_key          = "/home/katarina/.ssh/azure/subt-sim-vpn/id_rsa.pub"
}
