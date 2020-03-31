# // /////////////////////////////////////////////////////////////////////////////
# Global Settings
# // /////////////////////////////////////////////////////////////////////////////

# Specific version of terraform
terraform {
  required_version = ">= 0.12"
}

# // /////////////////////////////////////////////////////////////////////////////
# Resource Setup
# // /////////////////////////////////////////////////////////////////////////////

# Setup an azure resource group
resource "azurerm_resource_group" "example" {
  
  # name of resourec group
  name     = var.resource_name_prefix

  # region location for resource group
  location = var.resource_location

  tags = {
    environment = var.tag_name_prefix
  }
}

# Setup the virtual network (VNET)
resource "azurerm_virtual_network" "example" {
  
  # name of VNET
  name                = "${var.resource_name_prefix}-vnet"
  
  # resource group
  resource_group_name = azurerm_resource_group.example.name

  # region location
  location            = var.resource_location

  # VNET address space
  address_space       = [var.vnet_address_space]
  
  tags = {
    environment = var.tag_name_prefix
  }
}


# Setup the subnet in the VNET
resource "azurerm_subnet" "example" {
    
  # name of subnet
  name                 = "${var.resource_name_prefix}-subnet"
  
  # resource group
  resource_group_name  = azurerm_resource_group.example.name
  
  # VNET for this subnet
  virtual_network_name = azurerm_virtual_network.example.name

  # subnet address space
  address_prefix       = var.subnet_address_space
}

# public IP to access the VMs
resource "azurerm_public_ip" "example" {
  # name identifier of pub IP
  name                         = "${var.resource_name_prefix}-PUB-IP"
  
  # resource group
  resource_group_name          = azurerm_resource_group.example.name

  # region location
  location                     = var.resource_location
  
  # how to allocate the public IP (dynamic, static)
  allocation_method            = var.ip_alloc

  tags = {
    environment = var.tag_name_prefix
  }
}

# network security setup, rules: enable ssh
resource "azurerm_network_security_group" "example_ssh" {
  # name of network security group (ssh)
  name                = "${var.resource_name_prefix}-security-group"
  
  # resource group
  resource_group_name = azurerm_resource_group.example.name

  # region location
  location            = var.resource_location
  
  # security rule (ssh enable)
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.tag_name_prefix
  }
}