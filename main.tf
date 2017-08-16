variable "webnodes" {
  default = 3
}

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

module "sharedservices" {
  source = "./shared_services"
}

module "web_nodes_production" {
  source     = "./web_nodes"
  nodes      = "${var.webnodes}"
  subnet     = "${module.sharedservices.subnet1_id}"
  group_name = "t-web-prod"
}

module "web_nodes_test" {
  source     = "./web_nodes"
  nodes      = "1"
  subnet     = "${module.sharedservices.subnet1_id}"
  group_name = "t-web-test"
}

# Resource group for database
resource "azurerm_resource_group" "db" {
  name     = "t-db"
  location = "West Europe"
}
