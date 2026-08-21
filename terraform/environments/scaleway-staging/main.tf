terraform {
  required_version = ">= 1.5.0"
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.40.0"
    }
  }
}

provider "scaleway" {
  project_id = var.scaleway_project_id
  region     = var.scaleway_region
  zone       = var.scaleway_zone
}

module "network" {
  source               = "../../modules/network"
  vpc_name             = "quatrain-staging-vpc"
  private_network_name = "quatrain-staging-pn"
  lb_name              = "quatrain-staging-lb"
  tags                 = ["env=staging", "arch=arm64"]
}

module "kapsule" {
  source             = "../../modules/kapsule-cluster"
  cluster_name       = "quatrain-staging-cluster"
  private_network_id = module.network.private_network_id
  node_type          = "COP-ARM-2" # Scaleway ARM64
  min_nodes          = 2
  max_nodes          = 4
  tags               = ["env=staging", "arch=arm64"]
}

module "dns" {
  source       = "../../modules/dns"
  dns_zone     = var.dns_zone
  lb_public_ip = module.network.public_ip
  subdomains   = ["@", "*", "lorawan", "chirpstack", "app"]
}
