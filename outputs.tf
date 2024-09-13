# Output the AKS cluster kube config file
output "kube_config" {
  description = "Kube config for AKS cluster"
  value       = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
}

# Output resource group name
output "resource_group_name" {
  value = azurerm_resource_group.aks_rg.name
}

# Output AKS cluster name
output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.name
}
