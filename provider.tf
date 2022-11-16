terraform {
  required_providers {
    harness = {
      source  = "registry.terraform.io/harness/harness"
      version = "0.7.1"
    }
  }
  backend "azurerm" {
  }
}

provider "harness" {
  endpoint         = var.endpoint
  account_id       = var.account_id
  platform_api_key = var.platform_api_key
}