output "cluster_id" {
  value = module.kapsule.cluster_id
}

output "lb_public_ip" {
  value = module.network.public_ip
}
