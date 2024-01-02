locals {
  data = jsondecode(file("${path.module}/input_processed.json"))
}

module "front_hub" {
  source = "./../"

  resource_group_name     = "front-hub-solution_example-testing"
  resource_group_location = "West US"

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
