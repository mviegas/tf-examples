provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id


  features {}
}

variable "subscription_id" {
  description = "This is your Azure Subscription Id"
}

variable "client_id" {
  sensitive   = true
  description = "This is the appId value from the AZ SP creation script"
}

variable "client_secret" {
  sensitive   = true
  description = "This is the password value from the AZ SP creation script"
}

variable "tenant_id" {
  sensitive   = true
  description = "This is the tenant value from the AZ SP creation script"
}

variable "sku_size" {
  type        = string
  description = "Choose one of the followings SKUS: \n \n* D1: Free \n* B1, B2 or B3: Basic \n* S1, S2, S3: Standard \n* P1, ªP2, P3: Premium \n* P1v2, P2v2, P3v3: PremiumV2\n\n Check https://azure.microsoft.com/pt-pt/pricing/details/app-service/linux/ for more details."
}

variable "container_image" {
  type        = string
  description = "Container image name."
}

variable "port" {
  type        = string
  default     = null
  description = "The value of the expected container port number."
}

variable "https_only" {
  type        = bool
  default     = true
  description = "Redirect all traffic made to the web app using HTTP to HTTPS."
}

variable "docker_registry_url" {
  type        = string
  default     = "https://index.docker.io"
  description = "The container registry url."
}

variable "docker_registry_username" {
  type        = string
  default     = null
  sensitive   = false
  description = "The container registry username."
}

variable "docker_registry_password" {
  type        = string
  default     = null
  sensitive   = true
  description = "The container registry password."
}

locals {
  resource_group   = "rg-blue-green-test"
  app_service_plan = "ASP-blue-green-test"
  app_service      = "example-blue-green-test"

  app_settings = {
    "ASPNETCORE_ENVIRONMENT"          = "Production"
    "WEBSITES_PORT"                   = var.port
    "DOCKER_REGISTRY_SERVER_USERNAME" = var.docker_registry_username
    "DOCKER_REGISTRY_SERVER_URL"      = var.docker_registry_url
    "DOCKER_REGISTRY_SERVER_PASSWORD" = var.docker_registry_password
  }

  staging_app_settings = {
    "ASPNETCORE_ENVIRONMENT"          = "Staging"
    "WEBSITES_PORT"                   = var.port
    "DOCKER_REGISTRY_SERVER_USERNAME" = var.docker_registry_username
    "DOCKER_REGISTRY_SERVER_URL"      = var.docker_registry_url
    "DOCKER_REGISTRY_SERVER_PASSWORD" = var.docker_registry_password
  }

  linux_fx_version = "DOCKER|${var.container_image}"

  # FIXME: create a data source that exports list of all SKUs.
  sku_map = {
    "Free"      = ["F1", "Free"]
    "Shared"    = ["D1", "Shared"]
    "Basic"     = ["B1", "B2", "B3"]
    "Standard"  = ["S1", "S2", "S3"]
    "Premium"   = ["P1", "P2", "P3"]
    "PremiumV2" = ["P1v2", "P2v2", "P3v2"]
  }

  skus = flatten([
    for tier, sizes in local.sku_map : [
      for size in sizes : {
        tier = tier
        size = size
      }
    ]
  ])

  sku_tiers = { for sku in local.skus : sku.size => sku.tier }

  is_shared = contains(["F1", "FREE", "D1", "SHARED"], upper(var.sku_size))

  always_on = local.is_shared ? false : true

  use_32_bit_worker_process = local.is_shared ? true : false
}
