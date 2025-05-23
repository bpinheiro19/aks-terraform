## Variables
variable "location" {
  type        = string
  default     = "swedencentral"
  description = "Location of the resource group."
}

## Resource groups
variable "rg_name" {
  type        = string
  default     = "aks-fw-rg"
}

## VNETS
variable "vnet_name" {
  type        = string
  default     = "vnet"
}

## AKS
variable "aks_name" {
  type        = string
  default     = "aks-overlay-fw"
}

variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 1
}

variable "kubernetes_version" {
  type        = string
  description = "The version of kubernetes"
  default     = "1.31.7"
}

variable "vm_size" {
  type        = string
  description = "VM size"
  default     = "Standard_D2ps_v6"
}

## FW
variable "zones" {
  description = "Specifies the availability zones of the Azure Firewall"
  default     = ["1", "2", "3"]
  type        = list(string)
}

variable "sku_name" {
  description = "(Required) SKU name of the Firewall. Possible values are AZFW_Hub and AZFW_VNet. Changing this forces a new resource to be created."
  default     = "AZFW_VNet"
  type        = string
  validation {
    condition = contains(["AZFW_Hub", "AZFW_VNet" ], var.sku_name)
    error_message = "The value of the sku name property of the firewall is invalid."
  }
}

variable "sku_tier" {
  description = "(Required) SKU tier of the Firewall. Possible values are Premium, Standard, and Basic."
  default     = "Standard"
  type        = string
  validation {
    condition = contains(["Premium", "Standard", "Basic" ], var.sku_tier)
    error_message = "The value of the sku tier property of the firewall is invalid."
  }
}

variable "threat_intel_mode" {
  description = "(Optional) The operation mode for threat intelligence-based filtering. Possible values are: Off, Alert, Deny. Defaults to Alert."
  default     = "Alert"
  type        = string
  validation {
    condition = contains(["Off", "Alert", "Deny"], var.threat_intel_mode)
    error_message = "The threat intel mode is invalid."
  }
}
