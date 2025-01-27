locals {
  owners= var.Business_divison
  environment= var.environment
  #prefix = "${var.Business_divison}-${var.environment}"
  prefix = "${var.resource_group_location}-${var.Business_divison}-${var.environment}"

  common_tags = {
    owners = local.owners
    environment = local.environment
    Tag = "demo-tag1"  # Uncomment during step-08   
    Tag = "demo-tag2" 
    Tag = "demo-tag3" 
    Tag = "demo-tag4" 
  }
}