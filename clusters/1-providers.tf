terraform {
  required_providers  {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.85.0"
    }
    port-labs = {
      source = "port-labs/port-labs"
      version = "1.7.1"
    }
  }
  required_version = "~> 1.6.3"
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }

  skip_provider_registration = "true"

  # Connection to Azure
  subscription_id = var.azure_subscription_id
  client_id = var.azure_client_id
  client_secret = var.azure_client_secret
  tenant_id = var.azure_tenant_id
}

provider "port-labs" {
  client_id = var.port_client_id
  secret = var.port_secret
}
