provider "flux" {
  kubernetes = {
    host = data.talos_cluster_kubeconfig.this.kubernetes_client_configuration.host

    client_certificate     = base64decode(data.talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_certificate)
    client_key             = base64decode(data.talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_key)
    cluster_ca_certificate = base64decode(data.talos_cluster_kubeconfig.this.kubernetes_client_configuration.ca_certificate)
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
