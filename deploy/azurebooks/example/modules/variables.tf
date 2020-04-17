# // /////////////////////////////////////////////////////////////////////////////
# resource & network varibles
# // /////////////////////////////////////////////////////////////////////////////

variable "user_defined_resource_group_name" {
  description = "Default name prefix for resources"
  type = string
}

variable "resource_name_prefix" {
  description = "Default name prefix for resources"
  type = string
}

variable "resource_location" {
  description = "Default location of azure resources"
  type = string
  default = "eastus"
}

variable "vnet_address_space" {
  description = "Address space for azure virtual network"
  type = string
}

variable "subnet_address_space" {
  description = "Address space for subnet with VNET "
  type = string
}

variable "ip_alloc" {
  description = "Compute allocation method for public IP "
  type = string
  default = "Dynamic"
}

variable "gateway_address_subnet" {
  description = "Address space for gateway subnet"
  type = string
}

variable "vpn_address_space" {
  description = "Address space for virtual network gateway vpn"
  type = string
}

variable "vpn_ca_cert" {
  description = "Vpn root ca certificate"
  type = string
}


# // /////////////////////////////////////////////////////////////////////////////
# SubT VM Variables
# // /////////////////////////////////////////////////////////////////////////////

variable "vm_pub_ssh_key" {
  description = "Location of the public ssh key on the local computer to connect to remote VM "
  type = string
}

variable "vm_default_password" {
  description = "Default password of a VM, please change on entry!"
  type = string
  default = "Password1234!"
}

variable "basestation_hostname" {
  description = "Hostname of basestation VM"
  type = string
  default = "az-basestation"
}

variable "basestation_username" {
  description = "Username of basestation VM"
  type = string
  default = "subt"
}

variable "ugv_hostname" {
  description = "Hostname of UGV VM"
  type = string
  default = "az-ugv"
}

variable "ugv_username" {
  description = "Username of UGV VM"
  type = string
  default = "subt"
}

variable "uav_hostname" {
  description = "Hostname of UAV VM"
  type = string
  default = "az-uav"
}

variable "uav_username" {
  description = "Username of UAV VM"
  type = string
  default = "subt"
}


# // /////////////////////////////////////////////////////////////////////////////
# other terraform variables
# // /////////////////////////////////////////////////////////////////////////////
variable "tag_name_prefix" {
  description = "Example tag name"
  type = string
}
