# Terraform with Azure demo

## Install Terraform

sudo apt-get install unzip
wget https://releases.hashicorp.com/terraform/0.10.0/terraform_0.10.0_linux_amd64.zip
unzip terraform_0.10.0_linux_amd64.zip
sudo mv ./terraform /usr/bin

## Use
Jump into directory

Create configuration file with Azure access details (service principal access, note that client id = app id and tenant id = directory id) terraform.tfvars:
subscription_id = "xxx"
client_id       = "xxx"
client_secret   = "xxx"
tenant_id       = "xxx"

terraform plan
terraform apply
terraform destroy

## What it does
This example shows complex terraform infrastructure with reusable modules. main.tf contains main declarative state infrastructure with some inputs. Modules are used to create reusable infrastructure as code and setup production and test environment. Shared services module creates network. Web module creates couple of VMs and load balancer. App module creates container registry and Kubernetes cluster. Database module prepares Azure SQL DB.