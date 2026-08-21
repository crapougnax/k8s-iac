variable "project_id" {
  type        = string
  description = "Target Scaleway Project ID"
}

variable "vpc_name" {
  type        = string
  description = "Name of the Scaleway VPC"
}

variable "private_network_name" {
  type        = string
  description = "Name of the Private Network"
}

variable "lb_name" {
  type        = string
  description = "Name of the Scaleway Public Load Balancer"
}

variable "zone" {
  type        = string
  default     = "fr-par-1"
  description = "Scaleway availability zone"
}

variable "tags" {
  type        = list(string)
  default     = ["managed-by=terraform"]
  description = "Tags applied to network resources"
}
