variable "volumes" {
  type = map(object({
    name       = string
    size_in_gb = number
    iops       = optional(number, 5000)
  }))
  default     = {}
  description = "Map of Scaleway Block Storage volumes to provision"
}

variable "zone" {
  type        = string
  default     = "fr-par-1"
  description = "Scaleway availability zone"
}

variable "tags" {
  type        = list(string)
  default     = ["managed-by=terraform"]
  description = "Tags applied to block volumes"
}
