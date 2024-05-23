provider "flux" {
  kubernetes = {
    host = var.cluster_endpoint

    client_certificate     = terraform_data.kubernetes_credentials.output.client_certificate
    client_key             = terraform_data.kubernetes_credentials.output.client_key
    cluster_ca_certificate = terraform_data.kubernetes_credentials.output.cluster_ca_certificate
  }
  git = {
    url = "ssh://git@github.com/${data.external.env.result.GITHUB_REPOSITORY}.git"
    ssh = {
      username    = "git"
      private_key = tls_private_key.flux.private_key_pem
    }
  }
}

resource "tls_private_key" "flux" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "github_repository_deploy_key" "this" {
  title      = "Flux"
  repository = split("/", data.external.env.result.GITHUB_REPOSITORY)[1]
  key        = tls_private_key.flux.public_key_openssh
  read_only  = "false"
}

resource "flux_bootstrap_git" "this" {
  depends_on = [
    github_repository_deploy_key.this
  ]

  embedded_manifests = true
  path               = "services/flux"
}
