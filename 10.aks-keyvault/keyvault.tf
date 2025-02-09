data "azurerm_client_config" "current" {}

resource "random_pet" "azurerm_keyvault_prefix" {
  prefix = "akv"
}

resource "azurerm_key_vault" "keyvault" {
  name                        = random_pet.azurerm_keyvault_prefix.id 
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "Set",
      "List",
      "Delete",
      "Recover",
      "Backup",
      "Restore"
    ]
  }

}

resource "azurerm_key_vault_secret" "secret" {
  name         = "secret-sauce"
  value        = "szechuan"
  key_vault_id = azurerm_key_vault.keyvault.id
}