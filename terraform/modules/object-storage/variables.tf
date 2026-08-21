variable "bucket_name" {
  type        = string
  description = "Unique name of the S3 Object Storage bucket"
}

variable "region" {
  type        = string
  default     = "fr-par"
  description = "Scaleway region for the bucket"
}

variable "versioning_enabled" {
  type        = bool
  default     = true
  description = "Enable object versioning for disaster recovery"
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Allow Terraform to destroy the bucket even if not empty"
}

variable "tags" {
  type        = list(string)
  default     = ["managed-by=terraform"]
  description = "Tags applied to the bucket"
}
