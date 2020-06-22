# Virtual Network Interface -- connect VMs to network & security setup
resource "azurerm_network_interface" "basestation-cpu" {
  # name of NIC
  name                        = "${var.resource_name_prefix}-NIC-basestation"

  # resource group
  resource_group_name         = var.user_defined_resource_group_name

  # region location
  location                    = var.resource_location

  # toggle creation of a resource
  count                       = !var.enable_basestation_gpu ? var.basic_robots_toggle : 0

  ip_configuration {
    # name of NIC configuration
    name                          = "${var.resource_name_prefix}-NIC-basestation-configuration"

    # subnet configuration for this NIC
    subnet_id                     = azurerm_subnet.example.id

    # private ip allocation method
    private_ip_address_allocation = "Static"

    # private ip address
    private_ip_address            = "10.3.1.1"
  }

  tags = {
    environment = var.tag_name_prefix
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "basestation-cpu" {
  # NIC interface id
  network_interface_id      = azurerm_network_interface.basestation-cpu[count.index].id

  # Security Rules
  network_security_group_id = azurerm_network_security_group.example_ssh.id

  # toggle creation of a resource
  count                     = !var.enable_basestation_gpu ? var.basic_robots_toggle : 0
}

# Create virtual machine -- basestation
resource "azurerm_linux_virtual_machine" "basestation-cpu" {

  # name of vm
  name                  = "${var.resource_name_prefix}-basestation"

  # resource group
  resource_group_name   = var.user_defined_resource_group_name

  # region location
  location              = var.resource_location

  # NIC interface id
  network_interface_ids = [azurerm_network_interface.basestation-cpu[count.index].id]

  # toggle creation of a resource
  count                 = !var.enable_basestation_gpu ? var.basic_robots_toggle : 0

  # == VM instance Settings ==

  # instance type
  size                  = var.basestation_cpu_vm_instance

  # OS disk setup
  os_disk {
    name                    = "${var.resource_name_prefix}-basestation-os-disk"
    caching                 = "ReadWrite"
    storage_account_type    = "Standard_LRS"
    disk_size_gb            = var.basestation_disk_size
  }

  # VM image setup
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  # == User Access Settings ==

  computer_name  = var.basestation_cpu_hostname
  admin_username = var.basestation_username
  # admin_password = var.vm_default_password

  # only allow ssh key connection
  disable_password_authentication = true

  # ssh connection configurations
  admin_ssh_key {
    username       = var.basestation_username
    public_key     = file(var.vm_pub_ssh_key)
  }

  tags = {
    environment = var.tag_name_prefix
  }
}
