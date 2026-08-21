variable "enabled" {
  type        = bool
  default     = false
  description = "Enable DNS management via Scaleway Domains"
}

variable "enable_aaaa" {
  type        = bool
  default     = false
  description = "Enable AAAA IPv6 DNS records"
}

variable "project_id" {
  type        = string
  description = "Target Scaleway Project ID"
}

variable "dns_zone" {
  type        = string
  description = "Root DNS zone managed in Scaleway"
}

variable "lb_public_ip" {
  type        = string
  description = "Target Public IPv4 of the Load Balancer"
}

variable "lb_public_ipv6" {
  type        = string
  default     = ""
  description = "Target Public IPv6 of the Load Balancer"
}

variable "subdomains" {
  type        = list(string)
  default     = ["@", "*", "eu1.paris", "*.eu1.paris", "argocd.eu1.paris", "eu1.lorawan"]
  description = "List of subdomains / records to register"
}
