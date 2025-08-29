terraform {
  backend "azurerm" {
    resource_group_name  = "p20tfstate"
    storage_account_name = "p20tfstate"
    container_name      = "p20tfstate"
    key                 = "terraform.tfstate"
  }
}