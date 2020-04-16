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
  resource_name_prefix    = "Ryan2"
  
  # tag prefix
  tag_name_prefix         = "Ryan2"

  # resource VNET, address space
  vnet_address_space      = "10.3.0.0/16"

  # resource SUBNET, example subnet address space with above VNET
  subnet_address_space    = "10.3.0.0/22"

  # rsource SUBNET, gateway
  gateway_address_subnet  = "10.3.10.0/24"

  # vpn settings
  vpn_address_space       = "10.2.0.0/24"

  # vpn ca certificate 			  
  vpn_ca_cert             = "MIIC5jCCAc6gAwIBAgIId9WekobHtIUwDQYJKoZIhvcNAQELBQAwETEPMA0GA1UEAxMGVlBOIENBMB4XDTIwMDQxNDAzNTUyM1oXDTIzMDQxNDAzNTUyM1owETEPMA0GA1UEAxMGVlBOIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAywUx61CJN7cATAQNXL+H6Gv+oon/gHamYACkjyBFSnwKJIHpSO2cyZPRj6gSSo/zGo1+q6pY7xhTgisiS3/aSR7CnKNCAqZf9SFRj8qE+WyT8khr7x/TuMpe3Hu3Sk6/+vPC3aCmAqp0pBzGE5b9y17NoZF0tE8JdivT79I3s3BTvV5oCo1IHeYQBVIlCPkXkjYtAtkk1xNjwmFHzAf0IRLGIWLXehXWkpMbrjL+dNpV3Bf6rk+zcICXjjEWnElxTccYmhjwgqJibASSGLYSm8shcVm4KY6xFSI7ua89Z4ux350VcQv6no4oU8N3BPLLCcL/+3NTwi/vZ7Lh5ItvQQIDAQABo0IwQDAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUSN6IpZf9hHCcQvEoEoIwbW2BEdswDQYJKoZIhvcNAQELBQADggEBAHYamxi3eQr1jgWnbEf2pW3UInPNc4oLrrbZHUOShVVTXO50JpVtsaTmLDp1otXydGkoiEPUmH1QKxJ9LAHZIYiceQgo11ILNhuNnRLyHa0QznwQx/GRAJstXMvb4ZVLgIHLDFru7nU1otINspbx2jeyaw52U9nDccKspRJ+0P0rlxx9o1EXOY/6QudPmTKjGiDNdH7YdryuPQnT1bo0qFjQAPzC6ZF+JuwGIRpBsl/6HfghHQQ87acO2BB69+QAH5BD8HB2GWEpnFsjnGa/QT8Yi6GY5QiwvYINPqPlDyh9ipZEqeBGqKB0lpN22FMe16GBkKpWEAeEIXXI6CBEThk="

  # // /////////////////////////////////////////////////////////////////////////////
  # VM Settings
  # // /////////////////////////////////////////////////////////////////////////////
  
  # hostname of example VM
  hostname                = "Ryan-Computer"

  # username of example VM
  username                = "Ryan"

  # location of local ssh key to connect to remove VM
  vm_pub_ssh_key          = "/home/ryan/.ssh/azure_vpn.pub"
}
