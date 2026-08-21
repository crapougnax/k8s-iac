variable "scaleway_organization_id" {
  type        = string
  default     = "4cf0281e-2ff0-4b0d-89ca-810c562b9986"
  description = "Scaleway Organization ID for Quatrain Technologies"
}

variable "scaleway_project_id" {
  type        = string
  default     = "f719f1ef-8495-4254-8870-818131813fab"
  description = "Scaleway Project ID for Production (f719f1ef-8495-4254-8870-818131813fab)"
}

variable "scaleway_region" {
  type        = string
  default     = "fr-par"
}

variable "scaleway_zone" {
  type        = string
  default     = "fr-par-1"
}

variable "dns_zone" {
  type        = string
  default     = "qtrn.io"
  description = "Root domain for production cluster and services"
}

variable "enable_scaleway_dns" {
  type        = bool
  default     = false
  description = "Enable Scaleway DNS records management (false if external registrar)"
}
