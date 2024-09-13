# Azure credentials and configuration
variable "subscription_id" {
  description = "The subscription ID for Azure"
  type        = string
}

variable "tenant_id" {
  description = "The tenant ID for Azure"
  type        = string
}

variable "client_id" {
  description = "The client ID for Azure service principal"
  type        = string
}

variable "client_secret" {
  description = "The client secret for Azure service principal"
  type        = string
}

# Resource details
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "my-resource-group"
}

variable "aks_cluster_name" {
  description = "The name of the AKS cluster"
  type        = string
  default     = "my-aks-cluster"
}

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
  default     = "East US"
}

variable "node_count" {
  description = "The number of nodes in the AKS cluster"
  type        = number
  default     = 1
}

variable "environment" {
  description = "The environment for tagging"
  type        = string
  default     = "Testing"
}
