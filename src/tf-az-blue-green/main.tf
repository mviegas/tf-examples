# component - {provider}_{resource-type} - name
resource "azurerm_resource_group" "blue_green" {
  name     = var.resource_group
  location = "westeurope"

  tags = {
    Environment = "Development"
  }
}

resource "azurerm_app_service_plan" "blue_green" {
  name                = var.app_service_plan
  location            = azurerm_resource_group.blue_green.location
  resource_group_name = azurerm_resource_group.blue_green.name
  kind = "Linux"

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "blue_green" {
  name                = var.app_service
  location            = azurerm_resource_group.blue_green.location
  resource_group_name = azurerm_resource_group.blue_green.name
  app_service_plan_id = azurerm_app_service_plan.blue_green.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}
