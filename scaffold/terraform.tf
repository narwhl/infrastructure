terraform {
  backend "s3" {
    key = "states/infrastructure/scaffold/terraform.tfstate"
  }
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.2.1"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.50.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.5.0"
    }
  }
}
