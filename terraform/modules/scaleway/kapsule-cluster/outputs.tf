output "cluster_id" {
  value = scaleway_k8s_cluster.main.id
}

output "cluster_name" {
  value = scaleway_k8s_cluster.main.name
}

output "kubeconfig" {
  value     = scaleway_k8s_cluster.main.kubeconfig[0].config_file
  sensitive = true
}

output "wildcard_dns" {
  value = scaleway_k8s_cluster.main.wildcard_dns
}
