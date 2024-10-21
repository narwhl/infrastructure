terraform {

  backend "s3" {
    key = "states/infrastructure/images/terraform.tfstate"
  }

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.66.2"
    }
  }
}
