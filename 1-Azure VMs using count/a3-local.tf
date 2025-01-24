locals {
  owners= var.Business_divison
  environment= var.environment
  prefix = "${var.Business_divison}-${var.environment}"

  common_tags = {
    owners = local.owners
    environment = local.environment
  }
}