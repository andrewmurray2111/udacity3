provider "azurerm" {
  tenant_id       = "${var.tenant_id}"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  skip_provider_registration = "true"
  features {}
}
terraform {
  backend "azurerm" {
    storage_account_name = "udacity3sta"
    container_name       = "tfstate"
    key                  = "test.terraform.tfstate"
    access_key           = "wckZ1mTjf5yOd+iXCBMA+lVJonvR1BOEm2UpawJ7hv73+sROs4YMWBhdRQtRyX258+6Yp0ce4xui+AStz7YGjQ=="
  }
}

module "resource_group" {
  source               = "../../modules/resource_group"
  resource_group       = "${var.resource_group}"
  location             = "${var.location}"
}
module "network" {
  source               = "../../modules/network"
  address_space        = "${var.address_space}"
  location             = "${var.location}"
  virtual_network_name = "${var.virtual_network_name}"
  application_type     = "${var.application_type}"
  resource_type        = "NET"
  resource_group       = "${module.resource_group.resource_group_name}"
  address_prefix_test  = "${var.address_prefix_test}"
}

module "nsg-test" {
  source           = "../../modules/networksecuritygroup"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "NSG"
  resource_group   = "${module.resource_group.resource_group_name}"
  subnet_id        = "${module.network.subnet_id_test}"
  address_prefix_test = "${var.address_prefix_test}"
}
module "appservice" {
  source           = "../../modules/appservice"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "AppService"
  resource_group   = "${module.resource_group.resource_group_name}"
}
module "publicip" {
  source           = "../../modules/publicip"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "publicip"
  resource_group   = "${module.resource_group.resource_group_name}"
}
module "vm" {
  source                      = "../../modules/vm"
  location                    = var.location
  subnet_id                   = module.network.subnet_id_test
  resource_group              = module.resource_group.resource_group_name
  public_ip_address_id        = module.publicip.public_ip_address_id
  admin_username              = var.admin_username
  shared_image_name           = var.shared_image_name
  shared_image_gallery        = var.shared_image_gallery
  shared_image_resource_group = var.shared_image_resource_group
}