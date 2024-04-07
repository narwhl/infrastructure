terraform {
  backend "s3" {
    key = "states/infrastructure/scaffold/terraform.tfstate"
  }
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.7.0"
    }
  }
}
