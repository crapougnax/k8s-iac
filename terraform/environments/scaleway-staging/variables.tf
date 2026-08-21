variable "scaleway_project_id" {
  type        = string
  description = "Scaleway Project ID for Staging"
}

variable "scaleway_region" {
  type    = string
  default = "fr-par"
}

variable "scaleway_zone" {
  type    = string
  default = "fr-par-1"
}

variable "dns_zone" {
  type    = string
  default = "staging.brad.farm"
}
