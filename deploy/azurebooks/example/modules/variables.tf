# // /////////////////////////////////////////////////////////////////////////////
# resource & network varibles
# // /////////////////////////////////////////////////////////////////////////////

variable "resource_name_prefix" {
  description = "default name prefix for resources"
  type = string
}

variable "resource_location" {
  description = "default location of azure resources"
  type = string
  default = "eastus"
}

variable "vnet_address_space" {
  description = "address space for azure virtual network"
  type = string
}

variable "subnet_address_space" {
  description = "address space for subnet with VNET "
  type = string
}

variable "ip_alloc" {
  description = "compute allocation method for public IP "
  type = string
  default = "Dynamic"
}

variable "gateway_address_subnet" {
  description = "address space for gateway subnet"
  type = string
}

variable "vpn_address_space" {
  description = "address space for virtual network gateway vpn"
  type = string
}

variable "vpn_ca_cert" {
  description = "vpn root ca certificate"
  type = string
}


# // /////////////////////////////////////////////////////////////////////////////
# VM Variables
# // /////////////////////////////////////////////////////////////////////////////

variable "hostname" {
  description = "computer name of example VM "
  type = string
}

variable "username" {
  description = "computer name of example VM "
  type = string
}

variable "vm_pub_ssh_key" {
  description = "location of the public ssh key on the local computer to connect to remote VM "
  type = string
}

# // /////////////////////////////////////////////////////////////////////////////
# terraform tags
# // /////////////////////////////////////////////////////////////////////////////
variable "tag_name_prefix" {
  description = "example tag name"
  type = string
}
