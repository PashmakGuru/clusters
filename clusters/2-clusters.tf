locals {
  clusters = jsondecode(file("${path.module}/input-port.json")).clusters
}

module "kubernetes_cluster" {
  for_each = {
    for _, value in local.clusters:
      value.name => value
  }
  source  = "app.terraform.io/PashmakGuru/kubernetes-cluster/azure"
  version = "0.0.1-alpha.8"

  environment = "testing"
  location = local.administrative_cluster_resource_group_location
  name = local.administrative_cluster_name
  resource_group_name = local.administrative_cluster_resource_group_name
}
