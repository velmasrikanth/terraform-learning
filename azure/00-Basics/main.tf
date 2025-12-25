resource "azurerm_resource_group" "sa-group" {
  name     = "rg-storage-account"
  location = "Central India"

}

resource "azurerm_storage_account" "sa" {
  name                     = "vsstorage57"
  resource_group_name      = azurerm_resource_group.sa-group.name
  location                 = azurerm_resource_group.sa-group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "dev"
  }

}