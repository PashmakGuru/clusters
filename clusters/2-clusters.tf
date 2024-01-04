locals {
  clusters = {
    for cluster in jsondecode(file("${path.module}/clusters.json")).clusters:
      cluster.name => cluster
  }
}

module "kubernetes_cluster" {
  for_each = local.clusters

  source  = "app.terraform.io/PashmakGuru/kubernetes-cluster/azure"
  version = "~> 0.0.2"

  name = each.value.name
  environment = each.value.environment
  resource_group_name = each.value.resource_group_name
  location = each.value.resource_group_location
}

resource "port_entity" "this" {
  depends_on = [
    module.kubernetes_cluster,
  ]

  for_each = local.clusters

  provider = port-labs

  blueprint = "clusters"
  identifier = each.value.name
  title = each.value.name
  teams = ["Platform Engineers"]
  properties = {
    string_props = {
      azure_resource_group_name = each.value.resource_group_name
      azure_resource_group_location = each.value.resource_group_location
    }
  }
  relations = {
    single_relations = {
      environment = each.value.environment
    }
  }
}
