variable "mastercount" {
  default = 1
}

variable "agentcount" {
  default = 1
}

variable "group_name" {}
variable "client_id" {}
variable "client_secret" {}

# Random generator
resource "random_id" "master" {
  byte_length = 4
}
resource "random_id" "agent" {
  byte_length = 4
}
resource "random_id" "registry" {
  byte_length = 4
}
resource "random_id" "storage" {
  byte_length = 4
}

# Resource group for app layer in Kubernetes
resource "azurerm_resource_group" "app" {
  name     = "${var.group_name}"
  location = "West Europe"
}

# Storage account for registry
resource "azurerm_storage_account" "app" {
  name                = "storage${random_id.storage.hex}"
  resource_group_name = "${azurerm_resource_group.app.name}"
  location            = "${azurerm_resource_group.app.location}"
  account_type        = "Standard_LRS"
}

# Azure Container Registry
resource "azurerm_container_registry" "app" {
  name                = "contreg${random_id.registry.hex}"
  resource_group_name = "${azurerm_resource_group.app.name}"
  location            = "${azurerm_resource_group.app.location}"
  admin_enabled       = true
  sku                 = "Basic"

  storage_account {
    name       = "${azurerm_storage_account.app.name}"
    access_key = "${azurerm_storage_account.app.primary_access_key}"
  }
}

# Kubernetes cluster
resource "azurerm_container_service" "app" {
  name                   = "appkubernetes"
  location               = "${azurerm_resource_group.app.location}"
  resource_group_name    = "${azurerm_resource_group.app.name}"
  orchestration_platform = "Kubernetes"

  master_profile {
    count      = "${var.mastercount}"
    dns_prefix = "master-${random_id.master.hex}"
  }

  linux_profile {
    admin_username = "myadmin"
    ssh_key {
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqaZoyiz1qbdOQ8xEf6uEu1cCwYowo5FHtsBhqLoDnnp7KUTEBN+L2NxRIfQ781rxV6Iq5jSav6b2Q8z5KiseOlvKA/RF2wqU0UPYqQviQhLmW6THTpmrv/YkUCuzxDpsH7DUDhZcwySLKVVe0Qm3+5N2Ta6UYH3lsDf9R9wTP2K/+vAnflKebuypNlmocIvakFWoZda18FOmsOoIVXQ8HWFNCuw9ZCunMSN62QGamCe3dL5cXlkgHYv7ekJE15IA9aOJcM7e90oeTqo+7HTcWfdu0qQqPWY5ujyMw/llas8tsXY85LFqRnr3gJ02bAscjc477+X+j/gkpFoN1QEmt terraform@demo.tld"
    }
  }

  agent_pool_profile {
    name       = "default"
    count      = "${var.agentcount}"
    dns_prefix = "agent-${random_id.agent.hex}"
    vm_size    = "Standard_A0"
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

  diagnostics_profile {
    enabled = false
  }
}