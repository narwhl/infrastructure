provider "kubernetes" {
  host = data.talos_cluster_kubeconfig.this.kubernetes_client_configuration.host

  client_certificate     = base64decode(data.talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_certificate)
  client_key             = base64decode(data.talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_key)
  cluster_ca_certificate = base64decode(data.talos_cluster_kubeconfig.this.kubernetes_client_configuration.ca_certificate)
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
  depends_on = [time_sleep.wait_for_cluster_convergence]
}
