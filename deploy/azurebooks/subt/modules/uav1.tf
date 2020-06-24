# Virtual Network Interface -- connect VMs to network & security setup
resource "azurerm_network_interface" "uav1" {
  # name of NIC
  name                        = "${var.resource_name_prefix}-NIC-uav1"

  # resource group
  resource_group_name         = var.user_defined_resource_group_name

  # region location
  location                    = var.resource_location

  # toggle creation of a resource
  count                       = var.uav1_create_vm ? 1 : 0

  ip_configuration {
    # name of NIC configuration
    name                          = "${var.resource_name_prefix}-NIC-uav1-configuration"

    # subnet configuration for this NIC
    subnet_id                     = azurerm_subnet.example.id

    # private ip allocation method
    private_ip_address_allocation = "Static"

    # private ip address
    private_ip_address            = "10.3.1.51"
  }

  tags = {
    environment = var.tag_name_prefix
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "uav1" {
  # NIC interface id
  network_interface_id      = azurerm_network_interface.uav1[count.index].id

  # Security Rules
  network_security_group_id = azurerm_network_security_group.example_ssh.id

  # toggle creation of a resource
  count                     = var.uav1_create_vm ? 1 : 0
}

# Create virtual machine -- uav1
resource "azurerm_linux_virtual_machine" "uav1" {

  # name of vm
  name                  = "${var.resource_name_prefix}-uav1"

  # resource group
  resource_group_name   = var.user_defined_resource_group_name

  # region location
  location              = var.resource_location

  # NIC interface id
  network_interface_ids = [azurerm_network_interface.uav1[count.index].id]

  # toggle creation of a resource
  count                 = var.uav1_create_vm ? 1 : 0

  # == VM instance Settings ==

  # instance type
  size                  = var.uav_vm_instance

  # OS disk setup
  os_disk {
    name                    = "${var.resource_name_prefix}-uav1-os-disk"
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

  computer_name  = "${var.uav_hostname}1"
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
