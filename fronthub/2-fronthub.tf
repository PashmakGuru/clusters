locals {
  data = jsondecode(file("${path.module}/fronthub.lock.json"))
}

module "front_hub" {
  source  = "app.terraform.io/PashmakGuru/kubernetes-cluster/azure"
  version = "0.0.1-alpha.1"

  zones             = local.data.zones
  origin_groups     = local.data.origin_groups
  public_ip_origins = local.data.public_ip_origins
  endpoints         = local.data.endpoints
  rule_sets         = local.data.rule_sets
  routes            = local.data.routes
}

output "name_servers" {
  value = module.front_hub.name_servers
}

output "urls" {
  value = module.front_hub.urls
}
