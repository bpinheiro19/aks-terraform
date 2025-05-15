resource "azurerm_user_assigned_identity" "uami" {
  location            = azurerm_resource_group.rg.location
  name                = "${random_pet.azurerm_kubernetes_cluster_name.id}-uami"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_role_assignment" "vnet_aks_network_contributor" {
  scope                = azurerm_virtual_network.vnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.uami.principal_id
}
