data "azurerm_subscription" "current" {}

resource "azurerm_user_assigned_identity" "myworkload_identity" {
  location            = azurerm_resource_group.rg.location
  name                = "myworkloadidentity"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_federated_identity_credential" "myworkload_identity" {
  name                = azurerm_user_assigned_identity.myworkload_identity.name
  resource_group_name = azurerm_user_assigned_identity.myworkload_identity.resource_group_name
  parent_id           = azurerm_user_assigned_identity.myworkload_identity.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  subject             = "system:serviceaccount:${var.workload_sa_namespace}:${var.workload_sa_name}"
}

data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

resource "azurerm_role_assignment" "identity_contributor" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = "${data.azurerm_subscription.current.id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = azurerm_user_assigned_identity.myworkload_identity.principal_id
}

resource "azurerm_role_assignment" "identity_secret_user" {
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.myworkload_identity.principal_id
}

output "myworkload_identity_client_id" {
  description = "The client ID of the created managed identity to use for the annotation 'azure.workload.identity/client-id' on your service account"
  value       = azurerm_user_assigned_identity.myworkload_identity.client_id
}