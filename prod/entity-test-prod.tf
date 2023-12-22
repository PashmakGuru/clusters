# Port Generated (demo)
module "kubernetes-cluster" {
  source  = "app.terraform.io/PashmakGuru/kubernetes-cluster/azure"
  version = "0.0.1-alpha.2"
  
  environment = "prod"
  location = "West Europe"
  name = "test"
}