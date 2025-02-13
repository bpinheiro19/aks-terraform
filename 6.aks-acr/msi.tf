resource "azurerm_user_assigned_identity" "uami" {
  location            = azurerm_resource_group.rg.location
  name                = "uami-${var.suffix}"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_role_assignment" "vnet_aks_network_contributor" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.uami.principal_id
}

resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "acrpull"
  depends_on = [
    azurerm_kubernetes_cluster.aks,
    azurerm_container_registry.acr
  ]
}
