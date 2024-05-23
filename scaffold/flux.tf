resource "tls_private_key" "flux" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "github_repository_deploy_key" "this" {
  title      = "Flux"
  repository = data.external.env.result.GITHUB_REPOSITORY
  key        = tls_private_key.flux.public_key_openssh
  read_only  = "false"
}
