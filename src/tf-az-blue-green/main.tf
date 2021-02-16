# component - {provider}_{resource-type} - name
resource "azurerm_resource_group" "blue_green" {
  name     = local.resource_group
  location = "westeurope"

  tags = {
    Environment = "Development"
  }
}

resource "azurerm_app_service_plan" "blue_green" {
  name                = local.app_service_plan
  location            = azurerm_resource_group.blue_green.location
  resource_group_name = azurerm_resource_group.blue_green.name
  kind                = "linux"
  reserved            = true

  sku {
    tier = local.sku_tiers[var.sku_size]
    size = var.sku_size
  }
}

resource "azurerm_app_service" "blue_green" {
  name                    = local.app_service
  location                = azurerm_resource_group.blue_green.location
  resource_group_name     = azurerm_resource_group.blue_green.name
  app_service_plan_id     = azurerm_app_service_plan.blue_green.id
  https_only              = var.https_only
  client_affinity_enabled = false

  site_config {
    always_on        = local.always_on
    linux_fx_version = local.linux_fx_version
  }

  app_settings = local.app_settings
}

resource "azurerm_app_service_slot" "blue_green" {
    name                = "${azurerm_app_service.blue_green.name}-staging"
    location            = azurerm_resource_group.blue_green.location
    resource_group_name = azurerm_resource_group.blue_green.name
    app_service_plan_id = azurerm_app_service_plan.blue_green.id
    app_service_name    = azurerm_app_service.blue_green.name

    site_config {
    always_on        = false
    linux_fx_version = local.linux_fx_version
  }

  app_settings = local.staging_app_settings
}

resource "azurerm_app_service_active_slot" "blue_green" {
    resource_group_name   = azurerm_resource_group.blue_green.name
    app_service_name      = azurerm_app_service.blue_green.name
    app_service_slot_name = azurerm_app_service_slot.blue_green.name
}
