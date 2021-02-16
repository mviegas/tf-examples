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
  description = "This is the appId value from the AZ SP creation script"
}

variable "client_secret" {
  description = "This is the password value from the AZ SP creation script"
}

variable "tenant_id" {
  description = "This is the tenant value from the AZ SP creation script"
}

variable "resource_group" {
    default = "rg-blue-green-test"
}

variable "app_service_plan" {
  default = "ASP-blue-green-test"
}

variable "app_service" {
    default = "example-app-service"
}