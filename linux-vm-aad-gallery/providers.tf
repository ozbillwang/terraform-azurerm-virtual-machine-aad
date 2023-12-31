terraform {
  required_version = ">= 1.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.11, < 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.0.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.0.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Configuration for the "secondary" subscription
# Share image gallery from master subscription, where the images are built
provider "azurerm" {
  alias           = "secondary"
  tenant_id       = var.tenant_id
  subscription_id = var.secondary_subscription_id

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

}
