# Virtual Network Interface -- connect VMs to network & security setup
resource "azurerm_network_interface" "perception" {
  # name of NIC
  name                        = "${var.resource_name_prefix}-NIC-perception"

  # resource group
  resource_group_name         = var.user_defined_resource_group_name

  # region location
  location                    = var.resource_location

  ip_configuration {
    # name of NIC configuration
    name                          = "${var.resource_name_prefix}-NIC-perception-configuration"

    # subnet configuration for this NIC
    subnet_id                     = azurerm_subnet.example.id

    # private ip allocation method
    private_ip_address_allocation = "static"
    
    # private ip address
    private_ip_address = "10.3.1.14"
    
    # public IP resource connection
    # public_ip_address_id          = azurerm_public_ip.example.id
  }

  tags = {
    environment = var.tag_name_prefix
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "perception" {
  # NIC interface id
  network_interface_id      = azurerm_network_interface.perception.id
  
  # Security Rules
  network_security_group_id = azurerm_network_security_group.example_ssh.id
}

# Create virtual machine -- perception
resource "azurerm_linux_virtual_machine" "perception" {

  # name of vm
  name                  = "${var.resource_name_prefix}-perception"

  # resource group
  resource_group_name   = var.user_defined_resource_group_name

  # region location
  location              = var.resource_location

  network_interface_ids = [azurerm_network_interface.perception.id]

  # == VM instance Settings ==
  
  # instance type
  size                  = "Standard_F8s_v2"
  
  os_disk {
    name                    = "${var.resource_name_prefix}-perception-os-disk"
    caching                 = "ReadWrite"
    storage_account_type    = "Standard_LRS"
    disk_size_gb            = "30"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  # == User Access Settings ==
  
  computer_name  = "${var.perception_hostname}1"
  admin_username = var.perception_username

  # only allow ssh key connection
  disable_password_authentication = true    
  admin_ssh_key {
    username       = var.perception_username
    public_key     = file(var.vm_pub_ssh_key)
  }

  tags = {
    environment = var.tag_name_prefix
  }
}
