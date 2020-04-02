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
  vpn_ca_cert             = "MIIC5jCCAc6gAwIBAgIIHE7Ugy9ttNwwDQYJKoZIhvcNAQELBQAwETEPMA0GA1UEAxMGVlBOIENBMB4XDTIwMDQwMTA4MTkxOFoXDTIzMDQwMTA4MTkxOFowETEPMA0GA1UEAxMGVlBOIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAv20Cvw6rt1PVznKVZH+aY0pzlYAXsf149oH79vop+nCcsl8wgoUYfnopBKjh7tfwFroJVPpi8ngTA4ZU5+yv0AWXAJcPqf69HtNSoI1ZMc0tamoEO63MEm8jsIZFD3COLCvnNkt85q/09WzBAKf+HcdMSqVBvEqlzZ4rxcZAEc2zccIwY5VUyEO9bqZG+hoOl3f7lg/Xf3dg1X3e16iuv6e/Gn6W2PedDhcUoODLaP1FT82N8/pD2YNqRPie4EK0kBzbNUFrB72sPG79HP8O6tzwu8C9QGjRi56WGCMZUM0vOxuOKi4yO3r+pbLJzGV7xkZKjstH6qtGbLzwaAS8OQIDAQABo0IwQDAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUIkhjZfxcZs2BxPa4e/4GBSsbHm8wDQYJKoZIhvcNAQELBQADggEBAH41DzZbiB+VnVy84x7Ca3TeVvhScRtrLpw7/M8qKDtvrnwOlyiZSm26FVe+hiNWDbwSpQtlK1EVnvG7dOoUGiiJYUQl2rqzw4qydy3DDJrHy1gHIt3jrrmRcvKGZoRSBOZoFyw482QAutylaqNZtYzIMihcWrwuZchOrwsOSRFhtTTFVjbMJzJeBb6vuOuc+NtJ42ZWj86SOLA4u68FIu4xrPkG8Ox42le96Rq4A2UBLHP6v49EjlPHkwOag18KZTsxy7oEdfyhVMSLlLzW4bg1YvtH6iT+95zh2mWf31YFHWBVVi1cbGDo3Feuwyqk6ePFxV9qsou6Gcu7vVdEFyI="

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