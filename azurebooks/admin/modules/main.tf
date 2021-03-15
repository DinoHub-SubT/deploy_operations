# // /////////////////////////////////////////////////////////////////////////////
# Global Settings
# // /////////////////////////////////////////////////////////////////////////////

# Basic Terraform Setup
terraform {
  # setup the required terraform version
  required_version  = ">= 0.12"
}

# Setup an azure resource group
# --> enable if you have the permissions to craete a new resource group (only admins)
resource "azurerm_resource_group" "admin" {
  
  # name of resourec group
  name              = var.new_project_resource_group_name

  # region location for resource group
  location          = var.resource_location

  # toggle creation of a resource group.
  count             = var.resource_group_toggle_creation

  # tag name for resource group
  tags = {
    environment = var.tag_name_prefix
  }
}
