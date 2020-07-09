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
