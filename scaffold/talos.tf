locals {
  cluster_name = data.external.env.result.GITHUB_REPOSITORY_OWNER
  controlplanes = {
    for controlplane in range(var.cluster.controlplane.count) : "k8s-c${controlplane}" => {
      role = "controlplane"
      idx  = controlplane
    }
  }
  workers = {
    for worker in range(var.cluster.worker.count) : "k8s-w${worker}" => {
      role = "worker"
      idx  = worker
    }
  }
}

data "http" "talos_customization" {
  url    = "https://factory.talos.dev/schematics"
  method = "POST"

  request_headers = {
    "Accept"       = "application/json"
    "Content-Type" = "application/octet-stream"
  }

  request_body = yamlencode({
    customization = {
      systemExtensions = {
        officialExtensions = [
          "siderolabs/qemu-guest-agent"
        ]
      }
    }
  })
}

resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "machines" {
  for_each         = merge(local.controlplanes, local.workers)
  cluster_name     = local.cluster_name
  cluster_endpoint = var.cluster_endpoint
  machine_type     = each.value.role
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  config_patches = [
    yamlencode({
      machine = {
        install = {
          extensions = [
            {
              image = "ghcr.io/siderolabs/qemu-guest-agent:8.2.2"
            }
          ]
        }
        network = {
          interfaces = [
            {
              interface = module.nodes[each.key].interface_name
              addresses = [
                format(
                  "%s/%s",
                  "${cidrhost("${var.network.block}/${var.network.suffix}", var.cluster[each.value.role].address_start + each.value.idx)}",
                  var.network.suffix
                )
              ]
              routes = [
                {
                  network = "0.0.0.0/0"
                  gateway = cidrhost("${var.network.block}/${var.network.suffix}", 1)
                }
              ]
            }
          ]
        }
      }
      cluster = {
        apiServer = {
          extraArgs = {
            "anonymous-auth" = true
          }
        }
        network = {
          cni = {
            name = "none"
          }
        }
        proxy = {
          disabled = true
        }
        inlineManifests = [
          {
            name     = "cilium"
            contents = data.helm_template.cilium.manifest
          },
          {
            name = "oidc-viewer"
            contents = yamlencode({
              apiVersion = "rbac.authorization.k8s.io/v1"
              kind       = "ClusterRoleBinding"
              metadata = {
                name = "oidc-viewer"
              }
              roleRef = {
                apiGroup = "rbac.authorization.k8s.io"
                kind     = "ClusterRole"
                name     = "system:service-account-issuer-discovery"
              }
              subjects = [
                {
                  kind = "Group"
                  name = "system:unauthenticated"
                }
              ]
            })
          }
        ]
      }
    })
  ]
}

resource "talos_machine_configuration_apply" "this" {
  for_each                    = merge(local.controlplanes, local.workers)
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.machines[each.key].machine_configuration
  node                        = module.nodes[each.key].ip_address
}

resource "talos_machine_bootstrap" "this" {
  depends_on           = [talos_machine_configuration_apply.this]
  node                 = cidrhost("${var.network.block}/${var.network.suffix}", var.cluster.controlplane.address_start)
  client_configuration = talos_machine_secrets.this.client_configuration
}
# TODO: Remove this when a proper health check of the cluster is implemented
resource "time_sleep" "wait_for_cluster_convergence" {
  depends_on = [talos_machine_bootstrap.this]

  create_duration = "4m"
}

data "talos_cluster_kubeconfig" "this" {
  depends_on = [
    talos_machine_bootstrap.this
  ]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = cidrhost("${var.network.block}/${var.network.suffix}", var.cluster.controlplane.address_start)
}
