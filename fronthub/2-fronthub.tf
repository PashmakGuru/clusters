locals {
  data = jsondecode(file("${path.module}/fronthub.lock.json"))
}

module "front_hub" {
  source  = "app.terraform.io/PashmakGuru/front-hub/azure"
  version = "~> 0.0.1"

  zones             = local.data.zones
  origin_groups     = local.data.origin_groups
  public_ip_origins = local.data.public_ip_origins
  endpoints         = local.data.endpoints
  rule_sets         = local.data.rule_sets
  routes            = local.data.routes
}

resource "port_entity" "this" {
  depends_on = [
    module.front_hub,
  ]

  for_each = local.data.zones

  provider = port-labs

  blueprint = "dns_zones"
  identifier = each.key
  title = each.key
  teams = ["Platform Engineers"]
  properties = {
    array_props = {
      string_items = {
        name_servers = module.front_hub.name_servers[each.key]
      }
    }
  }
}

# output "urls" {
#   value = module.front_hub.urls
# }
