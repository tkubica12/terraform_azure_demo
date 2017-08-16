# Resource group for shared services
resource "azurerm_resource_group" "sharedservices" {
  name     = "t-sharedservices"
  location = "West Europe"
}

# Virtual network
resource "azurerm_virtual_network" "network" {
  name                = "myProductionNet"
  address_space       = ["10.0.0.0/16"]
  location            = "West Europe"
  resource_group_name = "${azurerm_resource_group.sharedservices.name}"
}

resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = "${azurerm_resource_group.sharedservices.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = "${azurerm_resource_group.sharedservices.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  address_prefix       = "10.0.2.0/24"
}

output "subnet1_id" {
  value = "${azurerm_subnet.subnet1.id}"
}

output "subnet2_id" {
  value = "${azurerm_subnet.subnet2.id}"
}

