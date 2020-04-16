# Azure Storage Account
resource "azurerm_storage_account" "terraform_statefiles" {
  
  # storage account name
  name                      = "${var.state_storage_name_prefix}terrastate"

  # resource group
  resource_group_name       = var.state_resource_group

  # region location
  location                  = var.resource_location

  # type of storage account
  account_kind              = "StorageV2"

  # tier of storage account
  account_tier              = "Standard"

  # replication type (LRS == Locally redundant storage)
  account_replication_type  = "LRS"

  # TODO encryption? -- default Microsoft.Storage ?

  # tag for data storage
  tags = {
    environment = var.tag_name_prefix
  }
}

# Azure Storage Container
resource "azurerm_storage_container" "terraform_statefiles" {
  
  # storage container prefix
  name                      = "${var.state_storage_name_prefix}-statefile-container"
  
  # name of the storage account
  storage_account_name      = azurerm_storage_account.terraform_statefiles.name
  
  # container access type
  container_access_type     = "private"
}

# Azure Storage Blob
resource "azurerm_storage_blob" "terraform_statefiles" {

  # storage container prefix
  name                      = "${var.state_storage_name_prefix}-statefile-blob"

  # storage account to use
  storage_account_name      = azurerm_storage_account.terraform_statefiles.name

  # storage container to use
  storage_container_name    = azurerm_storage_container.terraform_statefiles.name

  # storage blob type
  type                      = "Block"
}

