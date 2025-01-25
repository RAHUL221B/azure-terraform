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
}

provider "azurerm" {
  features{}
}
