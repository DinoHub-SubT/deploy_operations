# // /////////////////////////////////////////////////////////////////////////////
# Global Settings
# // /////////////////////////////////////////////////////////////////////////////

# Specific version of terraform
terraform {
  required_version = ">= 0.12"
}

# Setup the virtual network (VNET)
resource "azurerm_virtual_network" "example" {
  
  # name of VNET
  name                = "${var.resource_name_prefix}-vnet"
  
  # resource group
  resource_group_name = var.user_defined_resource_group_name

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
  resource_group_name  = var.user_defined_resource_group_name
  
  # VNET for this subnet
  virtual_network_name = azurerm_virtual_network.example.name

  # subnet address space
  address_prefix       = var.subnet_address_space
}

# Setup the gateway subnet -- has to have name "GatewaySubnet" ?
resource "azurerm_subnet" "example_gateway_subnet" {

  # name of gateway subnet
  name                 = "GatewaySubnet"

  # resource group
  resource_group_name  = var.user_defined_resource_group_name

  # vnet associated wtih this gateway subnet
  virtual_network_name = azurerm_virtual_network.example.name

  # address range for gateway subnet
  address_prefix       = var.gateway_address_subnet
}

# network security setup, rules: enable ssh
resource "azurerm_network_security_group" "example_ssh" {
  # name of network security group (ssh)
  name                = "${var.resource_name_prefix}-security-group"
  
  # resource group
  resource_group_name = var.user_defined_resource_group_name

  # region location
  location            = var.resource_location
  
  # == security rules ==
  
  # ssh enable
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
  # Allow all web ports (inbound) - http, https
  security_rule {
    name                       = "Allow-Web-All-In"
    priority                   = 1002
    direction                  = "Inbound"  
    access                     = "Allow"  
    protocol                   = "TCP"  
    source_port_range          = "*"  
    destination_port_ranges    = ["80","443", "8080"]
    source_address_prefix      = "*"  
    destination_address_prefix = "*"  
  }
  # Allow all web ports (outbound) - http, https
  security_rule {
    name                       = "Allow-Web-All-Out"
    priority                   = 1002
    direction                  = "Outbound"
    access                     = "Allow"  
    protocol                   = "TCP"  
    source_port_range          = "*"  
    destination_port_ranges    = ["80","443", "8080"]
    source_address_prefix      = "*"  
    destination_address_prefix = "*"  
  }
  # remote desktop
  security_rule {
    name                       = "RDP"  
    priority                   = 1003  
    direction                  = "Inbound"  
    access                     = "Allow"  
    protocol                   = "Tcp"  
    source_port_range          = "*"  
    destination_port_range     = "3389"  
    source_address_prefix      = "*"  
    destination_address_prefix = "*"  
  }
  # ping (inbound)
  security_rule {
    name                       = "ICMP-Ping-In"
    priority                   = 1004
    direction                  = "Inbound"  
    access                     = "Allow"  
    protocol                   = "ICMP"  
    source_port_range          = "*"  
    destination_port_range     = "*"  
    source_address_prefix      = "*"  
    destination_address_prefix = "*"  
  }
  # ping (outbound)
  security_rule {
    name                       = "ICMP-Ping-Out"
    priority                   = 1005
    direction                  = "Outbound"
    access                     = "Allow"  
    protocol                   = "ICMP"  
    source_port_range          = "*"  
    destination_port_range     = "*"  
    source_address_prefix      = "*"  
    destination_address_prefix = "*"  
  }

  tags = {
    environment = var.tag_name_prefix
  }
}

# public IP to access the VMs
resource "azurerm_public_ip" "example" {
  # name identifier of pub IP
  name                         = "${var.resource_name_prefix}-PUB-IP"
  
  # resource group
  resource_group_name          = var.user_defined_resource_group_name

  # region location
  location                     = var.resource_location
  
  # how to allocate the public IP (dynamic, static)
  allocation_method            = var.ip_alloc

  tags = {
    environment = var.tag_name_prefix
  }
}
# Virtual Network Gateway
resource "azurerm_virtual_network_gateway" "example" {
  
  # name of virtual network gateway
  name                = "${var.resource_name_prefix}-vnet-gateway"

  # region location
  location            = var.resource_location

  # resource group
  resource_group_name = var.user_defined_resource_group_name

  # == VPN Setings == 

  # vpn default settings
  type     = "Vpn"
  vpn_type = "RouteBased"
  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  # vpn ip configuration
  ip_configuration {
    # name of the gateway config
    name                          = "${var.resource_name_prefix}-vnet-gateway-config"

    # public ip
    public_ip_address_id          = azurerm_public_ip.example.id

    # public ip allocation method
    private_ip_address_allocation = var.ip_alloc

    # subnet to be used
    subnet_id                     = azurerm_subnet.example_gateway_subnet.id
  }

  # VPN certificate settings
  vpn_client_configuration {

    # vpn address range
    address_space = [ var.vpn_address_space ]

    # vpn client tunnel type
    vpn_client_protocols = [ "SSTP", "IkeV2"]

    # setup root certificate in vpn point-to-site configuration
    root_certificate {
      # name of the root certificate
      name = "${var.resource_name_prefix}-root-ca"
      # root ca certificate
      public_cert_data = var.vpn_ca_cert
    }
  }
}
