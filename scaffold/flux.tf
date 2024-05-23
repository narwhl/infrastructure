resource "tls_private_key" "flux" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "github_repository_deploy_key" "this" {
  title = "Flux"
  repository = replace(
    data.external.env.result.GITHUB_REPOSITORY,
    "${data.external.env.result.GITHUB_REPOSITORY_OWNER}/",
    ""
  )
  key       = tls_private_key.flux.public_key_openssh
  read_only = "false"
}
