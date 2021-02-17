# // /////////////////////////////////////////////////////////////////////////////
# user-defined terraform varibles
# // /////////////////////////////////////////////////////////////////////////////

variable "subscription_id" {
  description = "user subscription id"
  type = string
}
variable "tenant_id" {
  description = "user tenant id"
  type = string
}
variable "azure_username" {
  description = "azure username provided by kat"
  type = string
}
variable "azure_resource_name_prefix" {
  description = "azure resource name (usually your andrew ID but can be different)"
  type = string
}
variable "azure_vpn_cert" {
  description = "azure vpn certifate obtained during setup"
  type = string
}

# // /////////////////////////////////////////////////////////////////////////////
# create VM variables
# // /////////////////////////////////////////////////////////////////////////////

variable "basestation_create_vm" {
  description = "toggle (enable or disable) for creating basestation VMs"
  type = bool
  default = true
}
variable "basestation_enable_gpu" {
  description = "toggle (enable or disable) for creating basestation VMs with GPU"
  type = bool
  default = false
}

variable "ugv1_create_vm" {
  description = "toggle (enable or disable) for creating ugv1 VMs"
  type = bool
  default = true
}
variable "ugv2_create_vm" {
  description = "toggle (enable or disable) for creating ugv2 VMs"
  type = bool
  default = false
}
variable "ugv3_create_vm" {
  description = "toggle (enable or disable) for creating ugv3 VMs"
  type = bool
  default = false
}

variable "uav1_create_vm" {
  description = "toggle (enable or disable) for creating uav1 VMs"
  type = bool
  default = true
}
variable "uav2_create_vm" {
  description = "toggle (enable or disable) for creating uav2 VMs"
  type = bool
  default = false
}
variable "uav3_create_vm" {
  description = "toggle (enable or disable) for creating uav3 VMs"
  type = bool
  default = false
}
variable "uav4_create_vm" {
  description = "toggle (enable or disable) for creating uav4 VMs"
  type = bool
  default = false
}

variable "perception1_create_vm" {
  description = "toggle (enable or disable) for creating perception1 VMs"
  type = bool
  default = true
}

# // /////////////////////////////////////////////////////////////////////////////
# VM disk sizes
# // /////////////////////////////////////////////////////////////////////////////

variable "basestation_disk_size" {
  description = "basestation VM disk size"
  type = number
  default = 100
}

variable "ugv_disk_size" {
  description = "ugv VM disk size"
  type = number
  default = 64
}

variable "uav_disk_size" {
  description = "uav VM disk size"
  type = number
  default = 64
}

variable "perception_disk_size" {
  description = "perception VM disk size"
  type = number
  default = 100
}

# // /////////////////////////////////////////////////////////////////////////////
# VM instance types
# // /////////////////////////////////////////////////////////////////////////////

variable "basestation_cpu_vm_instance" {
  description = "basestation CPU VM instance type"
  type = string
  default = "Standard_F8s_v2"
}
variable "basestation_gpu_vm_instance" {
  description = "basestation GPU VM instance type"
  type = string
  default = "Standard_NC6"
}

variable "ugv_vm_instance" {
  description = "UGV VM instance type"
  type = string
  default = "Standard_F16s_v2"
}

variable "uav_vm_instance" {
  description = "UAV VM instance type"
  type = string
  default = "Standard_F16s_v2"
}

variable "perception_vm_instance" {
  description = "perception VM instance type"
  type = string
  default = "Standard_NC6"
}

# // /////////////////////////////////////////////////////////////////////////////
# Other variables
# // /////////////////////////////////////////////////////////////////////////////

variable "region" {
  description = "region location for all Subt VMs"
  type = string
  default = "eastus"
}
