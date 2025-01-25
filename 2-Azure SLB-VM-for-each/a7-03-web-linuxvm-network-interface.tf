# Resource-2: Create Network Interface

resource "azurerm_network_interface" "web_linuxvm_nic" {
  for_each =  var.web_linuxvm_instance_count
  name = "${local.prefix}--web-linuxvm-nic-${each.key}"
  location = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name = "web-linuxvm-ip-1"
    subnet_id = azurerm_subnet.webtier_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}