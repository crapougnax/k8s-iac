output "vpc_id" {
  value = scaleway_vpc.main.id
}

output "private_network_id" {
  value = scaleway_vpc_private_network.main.id
}

output "public_ip_id" {
  value = scaleway_lb_ip.main.id
}

output "public_ip" {
  value = scaleway_lb_ip.main.ip_address
}

output "public_ipv6_id" {
  value = scaleway_lb_ip.main_v6.id
}

output "public_ipv6" {
  value = scaleway_lb_ip.main_v6.ip_address
}
