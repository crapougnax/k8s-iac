resource "scaleway_block_volume" "volumes" {
  for_each   = var.volumes
  name       = each.value.name
  size_in_gb = each.value.size_in_gb
  iops       = each.value.iops
  zone       = var.zone
  tags       = var.tags
}
