# Resource-1: Azure Application Gateway Public IP
resource "azurerm_public_ip" "web_ag_publicip" {
  name                = "${local.prefix}-web-ag-publicip"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  sku = "Standard"  
}

# Azure Application Gateway - Locals Block 
#since these variables are re-used - a locals block makes this more maintainable
locals {
  # Generic 
  frontend_port_name             = "${azurerm_virtual_network.vnet.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.vnet.name}-feip"
  listener_name                  = "${azurerm_virtual_network.vnet.name}-httplstn"
  request_routing_rule1_name      = "${azurerm_virtual_network.vnet.name}-rqrt-1"
  url_path_map                   =  "${azurerm_virtual_network.vnet.name}-upm-app1-app2" 
  # App1
  backend_address_pool_name_app1      = "${azurerm_virtual_network.vnet.name}-beap-app1"
  http_setting_name_app1              = "${azurerm_virtual_network.vnet.name}-be-htst-app1"
  probe_name_app1                = "${azurerm_virtual_network.vnet.name}-be-probe-app1"

  # App2
  backend_address_pool_name_app2      = "${azurerm_virtual_network.vnet.name}-beap-app2"
  http_setting_name_app2              = "${azurerm_virtual_network.vnet.name}-be-htst-app2"
  probe_name_app2                    = "${azurerm_virtual_network.vnet.name}-be-probe-app2"

  # Default Redirect on Root Context (/)
  redirect_configuration_name    = "${azurerm_virtual_network.vnet.name}-rdrcfg"

}



# Resource-2: Azure Application Gateway - Standard
resource "azurerm_application_gateway" "web_ag" {
  name                = "${local.prefix}-web-ag"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
# START: --------------------------------------- #
# SKU: Standard_v2 (New Version )
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    #capacity = 2
  }
  autoscale_configuration {
    min_capacity = 0
    max_capacity = 10
  }  
# END: --------------------------------------- #

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.agsubnet.id
  }

  # Frontend Configs
  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.web_ag_publicip.id    
  }

  # Listener: HTTP 80
  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  # App1 Configs
  backend_address_pool {
    name = local.backend_address_pool_name_app1
  }
  backend_http_settings {
    name                  = local.http_setting_name_app1
    cookie_based_affinity = "Disabled"
    #path                  = "/app1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = local.probe_name_app1
  }
  probe {
    name                = local.probe_name_app1
    host                = "127.0.0.1"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    protocol            = "Http"
    port                = 80
    path                = "/app1/status.html"
    match { # Optional
      body              = "App1"
      status_code       = ["200"]
    }
  }   
# App2 Backend Configs
  backend_address_pool {
    name = local.backend_address_pool_name_app2
  }
  backend_http_settings {
    name                  = local.http_setting_name_app2
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60  
    probe_name            = local.probe_name_app2    
  }  
  probe {
    name                = local.probe_name_app2
    host                = "127.0.0.1"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    protocol            = "Http"
    port                = 80
    path                = "/app2/status.html"
    match { # Optional
      body              = "App2"
      status_code       = ["200"]
    }
  }  
  # Rule-1
  request_routing_rule {
    name                       = local.request_routing_rule1_name
    rule_type                  = "PathBasedRouting"
    http_listener_name         = local.listener_name
    url_path_map_name           = local.url_path_map
  }
  url_path_map {
    name = local.url_path_map  
    default_redirect_configuration_name = local.redirect_configuration_name
    path_rule {
      name = "app1-rule"
      paths = ["/app1/*"]
      backend_address_pool_name = local.backend_address_pool_name_app1
      backend_http_settings_name = local.http_setting_name_app1
    }
    path_rule {
      name = "app2-rule"
      paths = ["/app2/*"]
      backend_address_pool_name = local.backend_address_pool_name_app2
      backend_http_settings_name = local.http_setting_name_app2           
    }
        
}
# Default Root Context (/ - Redirection Config)
  redirect_configuration {
    name = local.redirect_configuration_name
    redirect_type = "Permanent"
    target_url = "https://stacksimplify.com/azure-aks/azure-kubernetes-service-introduction/"
  }
}