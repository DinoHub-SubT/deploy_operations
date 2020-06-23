# // /////////////////////////////////////////////////////////////////////////////
# resource & network varibles
# // /////////////////////////////////////////////////////////////////////////////

variable "user_defined_resource_group_name" {
  description = "default name prefix for resources"
  type = string
}

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

# /// basestation

variable "basestation_cpu_hostname" {
  description = "Hostname of basestation VM"
  type = string
  default = "az-basestation-cpu"
}

variable "basestation_gpu_hostname" {
  description = "Hostname of basestation VM"
  type = string
  default = "az-basestation-gpu"
}

variable "basestation_username" {
  description = "Username of basestation VM"
  type = string
  default = "subt"
}

variable "basestation_disk_size" {
  description = "basestation disk size"
  type = number
  default = 30
}

variable "basestation_cpu_vm_instance" {
  description = "Basestation VM CPU Instance Type"
  type = string
  default = "Standard_F8s_v2"
}

variable "basestation_gpu_vm_instance" {
  description = "Basestation VM GPU Instance Type"
  type = string
  default = "Standard_F8s_v2"
}

variable "enable_basestation_gpu" {
  description = "toggle (enable or disable) for creating basestation VMs with GPU"
  type = bool
  default = false
}

# /// UGV

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

variable "ugv_disk_size" {
  description = "basestation disk size"
  type = number
  default = 30
}

variable "ugv_vm_instance" {
  description = "UGV VM Instance Type"
  type = string
  default = "Standard_F16s_v2"
}

# /// UAV

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

variable "uav_disk_size" {
  description = "basestation disk size"
  type = number
  default = 30
}

variable "uav_vm_instance" {
  description = "UAV VM Instance Type"
  type = string
  default = "Standard_F16s_v2"
}

# /// perception

variable "perception_hostname" {
  description = "Hostname of UAV VM"
  type = string
  default = "az-perception"
}

variable "perception_username" {
  description = "Username of Perception VM"
  type = string
  default = "subt"
}

variable "perception_disk_size" {
  description = "basestation disk size"
  type = number
  default = 100
}

variable "perception_vm_instance" {
  description = "Perception VM Instance Type"
  type = string
  default = "Standard_NC6"
}

# // /////////////////////////////////////////////////////////////////////////////
# resource creation toggles
# // /////////////////////////////////////////////////////////////////////////////

variable "basic_robots_toggle" {
  description = "toggle (enable or disable) for creating VMs for basic robot simulation"
  type = number
  default = 0
}

variable "coord_robots_toggle" {
  description = "toggle (enable or disable) for creating VMs for full coordination robot simulation"
  type = number
  default = 0
}

variable "perception_robots_toggle" {
  description = "toggle (enable or disable) for creating VMs for perception robot simulation"
  type = number
  default = 0
}

# // /////////////////////////////////////////////////////////////////////////////
# terraform tags
# // /////////////////////////////////////////////////////////////////////////////
variable "tag_name_prefix" {
  description = "example tag name"
  type = string
}
