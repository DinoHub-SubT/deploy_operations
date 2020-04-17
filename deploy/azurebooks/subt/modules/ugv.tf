# Virtual Network Interface -- connect VMs to network & security setup
resource "azurerm_network_interface" "ugv1" {
  # name of NIC
  name                        = "${var.resource_name_prefix}-NIC-ugv1"

  # resource group
  resource_group_name         = var.user_defined_resource_group_name

  # region location
  location                    = var.resource_location

  ip_configuration {
    # name of NIC configuration
    name                          = "${var.resource_name_prefix}-NIC-ugv1-configuration"

    # subnet configuration for this NIC
    subnet_id                     = azurerm_subnet.example.id

    # private ip allocation method
    private_ip_address_allocation = "Static"
    
    # private ip address (UGV1)
    private_ip_address = "10.3.1.11"
  }

  tags = {
    environment = var.tag_name_prefix
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "ugv1" {
  # NIC interface id
  network_interface_id      = azurerm_network_interface.ugv1.id
  
  # Security Rules
  network_security_group_id = azurerm_network_security_group.example_ssh.id
}

# Create virtual machine -- UGV1
resource "azurerm_linux_virtual_machine" "ugv1" {

  # name of vm
  name                  = "${var.resource_name_prefix}-ugv1"

  # resource group
  resource_group_name   = var.user_defined_resource_group_name

  # region location
  location              = var.resource_location

  network_interface_ids = [azurerm_network_interface.ugv1.id]

  # == VM instance Settings ==
  
  # instance type
  size                  = "Standard_F8s_v2"
  
  os_disk {
    name                    = "${var.resource_name_prefix}-ugv1-os-disk"
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
  
  computer_name  = "${var.ugv_hostname}1"
  admin_username = var.ugv_username
  # admin_password = var.vm_default_password

  # only allow ssh key connection
  disable_password_authentication = true

  # ssh connection configurations
  admin_ssh_key {
    username       = var.username
    public_key     = file(var.vm_pub_ssh_key)
  }

  tags = {
    environment = var.tag_name_prefix
  }
}
