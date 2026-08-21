resource "scaleway_vpc" "main" {
  project_id = var.project_id
  name       = var.vpc_name
  tags       = var.tags
}

resource "scaleway_vpc_private_network" "main" {
  vpc_id = scaleway_vpc.main.id
  name   = var.private_network_name
  tags   = var.tags
}

resource "scaleway_lb_ip" "main" {
  project_id = var.project_id
  zone       = var.zone
  is_ipv6    = false
}

resource "scaleway_lb_ip" "main_v6" {
  project_id = var.project_id
  zone       = var.zone
  is_ipv6    = true
}
