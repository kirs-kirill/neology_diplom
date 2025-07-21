terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">=1.5"
}

provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.default_zone
  # service_account_key_file = file("~/.key.json")
  token                    = var.token
}

# provider "aws" {}