terraform {
  backend "s3" {
    key = "states/infrastructure/scaffold/terraform.tfstate"
  }
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.50.0"
    }
  }
}
