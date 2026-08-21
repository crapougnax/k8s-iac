resource "scaleway_domain_record" "records_a" {
  for_each   = var.enabled ? toset(var.subdomains) : toset([])
  project_id = var.project_id
  dns_zone   = var.dns_zone
  name       = each.value == "@" ? "" : each.value
  type       = "A"
  data       = var.lb_public_ip
  ttl        = 60
}
