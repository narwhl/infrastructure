provider "kubernetes" {
  host = data.talos_cluster_kubeconfig.this.kubernetes_client_configuration.host

  client_certificate     = terraform_data.kubernetes_credentials.output.client_certificate
  client_key             = terraform_data.kubernetes_credentials.output.client_key
  cluster_ca_certificate = terraform_data.kubernetes_credentials.output.cluster_ca_certificate
  insecure               = true
}

resource "kubernetes_cluster_role_binding_v1" "oidc_viewer" {
  metadata {
    name = "oidc-viewer"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:service-account-issuer-discovery"
  }
  subject {
    kind      = "Group"
    name      = "system:unauthenticated"
    api_group = "rbac.authorization.k8s.io"
  }
}
