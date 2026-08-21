resource "scaleway_object_bucket" "main" {
  name          = var.bucket_name
  region        = var.region
  tags          = var.tags
  force_destroy = var.force_destroy

  versioning {
    enabled = var.versioning_enabled
  }
}
