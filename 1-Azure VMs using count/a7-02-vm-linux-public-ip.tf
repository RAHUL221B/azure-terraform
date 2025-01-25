# Resource-1: Create Public IP Address

resource "azurerm_public_ip" "web_linuxvm_publicip" {
  name = "${local.prefix}-web-linuxvm-publicip"
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  allocation_method = static
  sku = standard
  
}