output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  sensitive = true
}

output "aks_cluster_name" {
  value     = azurerm_kubernetes_cluster.aks_cluster.name
  sensitive = true
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}
