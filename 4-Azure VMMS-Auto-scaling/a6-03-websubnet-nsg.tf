#Resource1 - create a webtier subnet
resource "azurerm_subnet" "webtier_subnet"{

name = "${azurerm_virtual_network.vnet.name}-${var.web_subnet_name}"
resource_group_name = var.resource_group_location
virtual_network_name = var.vnet_name
address_prefixes = var.web_subnet_address

}

# Resource 2 - create a network security group

resource "azurerm_network_security_group" "webtier_nsg" {

name = "${azurerm_subnet.webtier_subnet}-nsg"
location = var.resource_group_location
resource_group_name = var.resource_group_location
  
}

#Resource3 - Associate nsg and subnet

resource "azurerm_subnet_network_security_group_association" "websubnet_nsg_associate" {

    depends_on = [azurerm_network_security_rule.web_nsg_rule_inbound  ] # Every NSG Rule Association will disassociate NSG from Subnet and Associate it, so we associate it only after NSG is completely created - Azure Provider Bug https://github.com/terraform-providers/terraform-provider-azurerm/issues/354  
    network_security_group_id =  azurerm_network_security_group.webtier_nsg.id
    subnet_id =    azurerm_subnet.webtier_subnet.id
}

# Resource-4: Create NSG Rules
## Locals Block for Security Rules

locals {
  web_inbound_ports_map = {
    100 : "80" ,
    110 : "443",
    120 : "22"
  }
}

## NSG Inbound Rule for WebTier Subnets

resource "azurerm_network_security_rule" "web_nsg_rule_inbound" {
    for_each = local.web_inbound_ports_map
    name                        =  "Rule-port-${each.value}"
    priority                    = each.key
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = each.value 
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = azurerm_resource_group.myrg.name
    network_security_group_name = azurerm_network_security_group.webtier_nsg.name
}
