locals {
  ssh_keys_import = ["https://github.com/0xinterface.keys"]
}

data "external" "env" {
  program = ["jq", "-n", "env"]
}

resource "tls_private_key" "this" {
  algorithm = "ED25519"
}

module "bastion" {
  source = "github.com/narwhl/blueprint//modules/debian"
  name   = "bastion"
  ssh_authorized_keys = [
    tls_private_key.this.public_key_openssh
  ]
  ssh_import_id = local.ssh_keys_import
}

resource "vault_generic_secret" "bastion_config" {
  path      = "secret/infrastructure/machine-configuration/bastion"
  data_json = jsonencode(module.bastion.config)
}
