# Virtual Network Interface -- connect VMs to network & security setup
resource "azurerm_network_interface" "perception1" {
  # name of NIC
  name                        = "${var.resource_name_prefix}-NIC-perception1"

  # resource group
  resource_group_name         = var.user_defined_resource_group_name

  # region location
  location                    = var.resource_location

  # toggle creation of a resource
  count                       = var.perception1_create_vm ? 1 : 0

  ip_configuration {
    # name of NIC configuration
    name                          = "${var.resource_name_prefix}-NIC-perception1-configuration"

    # subnet configuration for this NIC
    subnet_id                     = azurerm_subnet.example.id

    # private ip allocation method
    private_ip_address_allocation = "static"

    # private ip address
    private_ip_address            = "10.3.1.14"
  }

  tags = {
    environment = var.tag_name_prefix
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "perception1" {
  # NIC interface id
  network_interface_id      = azurerm_network_interface.perception1[count.index].id

  # Security Rules
  network_security_group_id = azurerm_network_security_group.example_ssh.id

  # toggle creation of a resource
  count                     = var.perception1_create_vm ? 1 : 0
}

# Create virtual machine -- perception1
resource "azurerm_linux_virtual_machine" "perception1" {

  # name of vm
  name                  = "${var.resource_name_prefix}-perception1"

  # resource group
  resource_group_name   = var.user_defined_resource_group_name

  # region location
  location              = var.resource_location

  # NIC interface id
  network_interface_ids = [azurerm_network_interface.perception1[count.index].id]

  # toggle creation of a resource
  count                 = var.perception1_create_vm ? 1 : 0

  # == VM instance Settings ==

  # instance type
  size                  = var.perception_vm_instance

  os_disk {
    name                      = "${var.resource_name_prefix}-perception1-os-disk"
    caching                   = "ReadWrite"
    storage_account_type      = "Standard_LRS"
    disk_size_gb              = var.perception_disk_size
  }

  source_image_reference {
    offer                     = "ngc_azure_17_11"
    publisher                 = "nvidia"
    sku                       = "ngc_machine_image_20_03_1"
    version                   = "20.03.1"
  }

  plan {
    product                   = "ngc_azure_17_11"
    publisher                 = "nvidia"
    name                      = "ngc_machine_image_20_03_1"
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

data "azurerm_platform_image" "ubuntu1804" {
  location  = var.resource_location
  publisher = "Canonical"
  offer     = "UbuntuServer"
  sku       = "18.04-LTS"
}

resource "azurerm_managed_disk" "perception1" {
  name                 = "${var.resource_name_prefix}-perception1-disk1"
  location             = var.resource_location
  resource_group_name  = var.user_defined_resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "FromImage"
  disk_size_gb         = 1000
  image_reference_id   = "/Subscriptions/b1e974e5-8229-44c3-a472-235a580d611a/Providers/Microsoft.Compute/Locations/westus/Publishers/Canonical/ArtifactTypes/VMImage/Offers/UbuntuServer/Skus/18.04-LTS/Versions/18.04.202004080"
  # toggle creation of a resource
  count                = var.perception1_create_vm ? 1 : 0
}

resource "azurerm_virtual_machine_data_disk_attachment" "perception1" {
  managed_disk_id       = azurerm_managed_disk.perception1[count.index].id
  virtual_machine_id    = azurerm_linux_virtual_machine.perception1[count.index].id
  lun                   = "10"
  caching               = "ReadWrite"
  # toggle creation of a resource
  count                 = var.perception1_create_vm ? 1 : 0
}
