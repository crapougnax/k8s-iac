output "volumes" {
  value = { for k, v in scaleway_block_volume.volumes : k => {
    id         = v.id
    name       = v.name
    size_in_gb = v.size_in_gb
  }}
}
