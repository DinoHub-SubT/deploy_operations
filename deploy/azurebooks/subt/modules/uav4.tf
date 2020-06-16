# Virtual Network Interface -- connect VMs to network & security setup
resource "azurerm_network_interface" "uav4" {
  # name of NIC
  name                        = "${var.resource_name_prefix}-NIC-uav4"

  # resource group
  resource_group_name         = var.user_defined_resource_group_name

  # region location
  location                    = var.resource_location

  # toggle creation of a resource
  count                       = var.coord_robots_toggle

  ip_configuration {
    # name of NIC configuration
    name                          = "${var.resource_name_prefix}-NIC-uav4-configuration"

    # subnet configuration for this NIC
    subnet_id                     = azurerm_subnet.example.id

    # private ip allocation method
    private_ip_address_allocation = "static"

    # private ip address
    private_ip_address            = "10.3.1.54"
  }

  tags = {
    environment = var.tag_name_prefix
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "uav4" {
  # NIC interface id
  network_interface_id      = azurerm_network_interface.uav4[count.index].id

  # Security Rules
  network_security_group_id = azurerm_network_security_group.example_ssh.id

  # toggle creation of a resource
  count                     = var.coord_robots_toggle
}

# Create virtual machine -- uav4
resource "azurerm_linux_virtual_machine" "uav4" {

  # name of vm
  name                  = "${var.resource_name_prefix}-uav4"

  # resource group
  resource_group_name   = var.user_defined_resource_group_name

  # region location
  location              = var.resource_location

  # toggle creation of a resource
  count                 = var.coord_robots_toggle

  # NIC interface id
  network_interface_ids = [azurerm_network_interface.uav4[count.index].id]

  # == VM instance Settings ==

  # instance type
  size                  = "Standard_F16s_v2"

  # OS disk setup
  os_disk {
    name                    = "${var.resource_name_prefix}-uav4-os-disk"
    caching                 = "ReadWrite"
    storage_account_type    = "Standard_LRS"
    disk_size_gb            = var.uav_disk_size
  }

  # VM image setup
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  # == User Access Settings ==

  computer_name  = "${var.uav_hostname}4"
  admin_username = var.uav_username
  # admin_password = var.vm_default_password

  # only allow ssh key connection
  disable_password_authentication = true

  # ssh connection configurations
  admin_ssh_key {
    username       = var.uav_username
    public_key     = file(var.vm_pub_ssh_key)
  }

  tags = {
    environment = var.tag_name_prefix
  }
}
