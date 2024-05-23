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
