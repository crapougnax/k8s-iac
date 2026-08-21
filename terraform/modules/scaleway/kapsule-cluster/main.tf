resource "scaleway_k8s_cluster" "main" {
  project_id                  = var.project_id
  region                      = var.region
  name                        = var.cluster_name
  version                     = var.k8s_version
  cni                         = var.cni
  private_network_id          = var.private_network_id
  delete_additional_resources = false
  tags                        = var.tags

  auto_upgrade {
    enable                        = false
    maintenance_window_start_hour = 3
    maintenance_window_day        = "sunday"
  }
}

resource "scaleway_k8s_pool" "arm64_nodes" {
  cluster_id        = scaleway_k8s_cluster.main.id
  name              = "${var.cluster_name}-arm64-pool"
  node_type         = var.node_type
  size              = var.min_nodes
  min_size          = var.min_nodes
  max_size          = var.max_nodes
  autoscaling       = true
  autohealing       = true
  container_runtime = "containerd"
  tags              = var.tags
}
