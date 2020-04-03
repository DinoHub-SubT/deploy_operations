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
  
  # use existing resource group name
  user_defined_resource_group_name = "SubT"

  # name prefix to be used for all resources
  resource_name_prefix    = "kat-example"
  
  # tag prefix
  tag_name_prefix         = "tag-kat-example"

  # resource VNET, address space
  vnet_address_space      = "10.0.0.0/16"

  # resource SUBNET, example subnet address space with above VNET
  subnet_address_space    = "10.0.2.0/24"

  # rsource SUBNET, gateway
  gateway_address_subnet  = "10.0.1.0/24"

  # vpn settings
  vpn_address_space       = "10.2.0.0/24"

  # vpn ca certificate
  vpn_ca_cert             = "MIIC5jCCAc6gAwIBAgIIfJwMCWXJ/iAwDQYJKoZIhvcNAQELBQAwETEPMA0GA1UEAxMGVlBOIENBMB4XDTIwMDQwMjA4MjAwMloXDTIzMDQwMjA4MjAwMlowETEPMA0GA1UEAxMGVlBOIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtrPGLzHE1HdffPpK73PhTi6MP8l8V8QWIHVbRFNEszuWm1YwDRKkbgsId8NKewnKuBvPgMdWwobdc98dt/OZN3yGaHSJdgkyNawxdNudpnmoE90KQh+ze9B9WB/r7w82jTRHHK2FxJjFay10Z297YcDqmSF0o2yN9t2PTtMzlLyPoR5gEsp3PHXlCHQc3kGLr3Vyp9fy3FdDfTVfUFyIvo4zqZdiLGkh5ql5CrWS3KiL7SF/ZQZktfzMbhR7gZPpDPewXN54AeYNWHEp8JWBSs+cbKYL+OBEifha/WOzx+pcRphvr6o5FeBLhRsBw9Xg3uCipEnXUbJUOwz/XncBpQIDAQABo0IwQDAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUiBgkY+JrY1Ez/q//YVDG303sVuswDQYJKoZIhvcNAQELBQADggEBAFTRoBnAGwcNSSDIOdqNkqogoMN6Jq/6PQto8c7SkIYveuuj1DIf3IMvBDfh8yShE+xoGByoo4bD336cS1wIMANtCn8wfXhJXHYfNYp1nZ01GAQdkCdOBLnJRGFdC+D8cu47JxMBuRq3L64l+oDu+u/zZJwWV4CBp+xbzM81pwaKxX0z4R+ev1RnheE+4n99p7R5zWKHXo9Tpu6QYbo9asUXf1JuP3KjaVDS+2a5LX+9xjRPKo9UhpAJmQ/DHXdH3V6tj7zaqZtNC53lP1/wavGRMCpYj+RGVLsAWZFt73CrkIukB7lqH0WXhWNAlaRgGnoH14ob0ePHxQ0ecD1/eSw="

  # // /////////////////////////////////////////////////////////////////////////////
  # VM Settings
  # // /////////////////////////////////////////////////////////////////////////////
  
  # hostname of example VM
  hostname                = "kat-computer"

  # username of example VM
  username                = "kat"

  # location of local ssh key to connect to remove VM
  vm_pub_ssh_key          = "/home/katarina/.ssh/azure/vm-keys/example_id_rsa.pub"
}