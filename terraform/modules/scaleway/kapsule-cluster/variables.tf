variable "project_id" {
  type        = string
  description = "Target Scaleway Project ID"
}

variable "cluster_name" {
  type        = string
  description = "Name of the Scaleway Kapsule cluster"
}

variable "region" {
  type        = string
  default     = "fr-par"
  description = "Scaleway region"
}

variable "cni" {
  type        = string
  default     = "cilium"
  description = "CNI plugin for Kubernetes (cilium / calico)"
}

variable "k8s_version" {
  type        = string
  default     = "1.34.6"
  description = "Kubernetes control plane version"
}

variable "private_network_id" {
  type        = string
  description = "ID of the VPC Private Network attached to the cluster"
}

variable "node_type" {
  type        = string
  default     = "STANDARD2-A2C-8G"
  description = "Scaleway ARM64 node type (e.g. STANDARD2-A2C-8G, STANDARD2-A4C-16G)"
}

variable "min_nodes" {
  type        = number
  default     = 3
  description = "Minimum number of nodes in the auto-scaling pool"
}

variable "max_nodes" {
  type        = number
  default     = 8
  description = "Maximum number of nodes in the auto-scaling pool"
}

variable "tags" {
  type        = list(string)
  default     = ["architecture=arm64", "managed-by=terraform"]
  description = "Tags applied to cluster and nodes"
}
