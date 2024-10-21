data "http" "supplychain" {
  url = "https://artifact.narwhl.dev/upstream/current.json"
  request_headers = {
    Accept = "application/json"
  }
}

locals {
  distros = jsondecode(data.http.supplychain.response_body).distros
}

