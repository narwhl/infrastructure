terraform {
  backend "s3" {
    key = "states/infrastructure/scaffold/terraform.tfstate"
  }
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = "1.3.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.2.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.13.2"
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
