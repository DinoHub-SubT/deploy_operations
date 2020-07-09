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