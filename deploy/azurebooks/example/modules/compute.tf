# Virtual Network Interface -- connect VMs to network & security setup
resource "azurerm_network_interface" "example" {
  # name of NIC
  name                        = "${var.resource_name_prefix}-NIC"

  # resource group
  resource_group_name         = azurerm_resource_group.example.name

  # region location
  location                    = var.resource_location

  ip_configuration {
    # name of NIC configuration
    name                          = "${var.resource_name_prefix}-NIC-configuration"

    # subnet configuration for this NIC
    subnet_id                     = azurerm_subnet.example.id

    # private ip allocation method
    private_ip_address_allocation = var.ip_alloc
    
    # public IP resource connection
    # public_ip_address_id          = azurerm_public_ip.example.id
  }

  tags = {
    environment = var.tag_name_prefix
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  # NIC interface id
  network_interface_id      = azurerm_network_interface.example.id
  
  # Security Rules
  network_security_group_id = azurerm_network_security_group.example_ssh.id
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "example" {

  # name of vm
  name                  = "${var.resource_name_prefix}-VM-example"

  # resource group
  resource_group_name   = azurerm_resource_group.example.name

  # region location
  location              = var.resource_location

  network_interface_ids = [azurerm_network_interface.example.id]

  # == OS Settings ==
  size                  = "Standard_DS1_v2"

  os_disk {
    name              = "myOsDisk"
    caching           = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  # == User Access Settings ==
  
  computer_name  = var.hostname
  admin_username = var.username

  # only allow ssh key connection
  disable_password_authentication = true    
  admin_ssh_key {
    username       = var.username
    public_key     = file(var.vm_pub_ssh_key)
  }

  tags = {
    environment = var.tag_name_prefix
  }
}
