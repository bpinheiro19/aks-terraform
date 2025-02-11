## Variables
variable "location" {
  type        = string
  default     = "swedencentral"
  description = "Location of the resource group."
}

## Resource groups
variable "rg" {
  type        = string
  default     = "rg-keyvault"
}

## Virtual Network
variable "vnet_name" {
  type        = string
  default     = "vnet-keyvault"
}

variable "subnet_name" {
  type        = string
  default     = "subnet-keyvault"
}

## AKS
variable "aks_name" {
  type        = string
  default     = "aks-keyvault"
}

variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 1
}

variable "kubernetes_version" {
  type        = string
  description = "The version of kubernetes"
  default     = "1.30.7"
}

variable "vm_size" {
  type        = string
  description = "VM size"
  default     = "Standard_D2s_v3"
}

variable "workload_sa_name" {
  type        = string
  description = "Kubernetes service account to permit"
  default     = "myworkloadsa"
}

variable "workload_sa_namespace" {
  type        = string
  description = "Kubernetes service account namespace to permit"
  default     = "workload-test"
}
