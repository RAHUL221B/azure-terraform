terraform {
  required_version = "3.0.0"  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">3.0.0"
    }
    random = {
       source = "hashicorp/random"
       version = ">2.0" 
    }
    null = {
       source = "hashicorp/null"
       version = ">2.0"
    }
  }

# Terraform State Storage to Azure Storage Container
  backend "azurerm" {
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformstate201"
    container_name        = "tfstatefiles"
    key                   = "project-2-westus2-terraform.tfstate"
  }  
}


provider "azurerm" {
  features{}
}
