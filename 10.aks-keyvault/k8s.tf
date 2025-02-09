
resource "kubernetes_namespace_v1" "namespace" {
  metadata {
    name = var.workload_sa_namespace
  }
}

resource "kubernetes_service_account_v1" "service_account" {
  metadata {
    name      = var.workload_sa_name
    namespace = var.workload_sa_namespace
    annotations = {
      "azure.workload.identity/client-id" = azurerm_user_assigned_identity.myworkload_identity.client_id
    }
    labels = {
      "azure.workload.identity/use" = "true"
    }
  }
}

resource "kubernetes_pod_v1" "sample_workload" {
  metadata {
    name      = "ngsample-workload-identity-key-vaultnx"
    namespace = kubernetes_namespace_v1.namespace.metadata.0.name
    labels = {
      "azure.workload.identity/use" = "true"
    }
  }

  spec {
    service_account_name = var.workload_sa_name
    container {
      image = "ghcr.io/azure/azure-workload-identity/msal-go"
      name  = "oidc"

      env {
        name  = "KEYVAULT_URL"
        value = azurerm_key_vault.keyvault.vault_uri
      }
      env {
        name  = "SECRET_NAME"
        value = "secret-sauce"
      }
    }
  }
}
