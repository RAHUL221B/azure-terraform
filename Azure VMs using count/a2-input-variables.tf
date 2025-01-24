variable "Business_divison" {

    description = "Business division this infra belongs"
    type = string
    default = "SAP"
}

variable "environment" {

    description = "environment of the infra"
    type = string
    default = "dev"
}

variable "resource_group_name" {

    description = "Resource group where infra needs to be created"
    type = string
    default = "rg-default"
}

variable "resource_group_location" {
  description = "location of the resource group"
  type = string
  default = "eastus2"  
}

