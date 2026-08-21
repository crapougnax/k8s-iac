output "cluster_id" {
  value = module.kapsule.cluster_id
}

output "lb_public_ip" {
  value = module.network.public_ip
}

output "lb_public_ipv6" {
  value = module.network.public_ipv6
}
