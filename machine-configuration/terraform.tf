terraform {
  backend "s3" {
    key = "states/infrastructure/machine-configuration/terraform.tfstate"
  }

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "4.4.0"
    }
  }
}

provider "vault" {
  headers {
    name  = "CF-Access-Client-Id"
    value = data.external.env.result.CF_ACCESS_CLIENT_ID
  }

  headers {
    name  = "CF-Access-Client-Secret"
    value = data.external.env.result.CF_ACCESS_CLIENT_SECRET
  }
}