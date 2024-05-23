resource "terraform_data" "flatcar_release" {
  input = local.distros.flatcar.version
}

resource "terraform_data" "talos_release" {
  input = local.distros.talos.version
}

resource "proxmox_virtual_environment_download_file" "flatcar" {
  content_type       = "iso"
  datastore_id       = "local"
  node_name          = var.node_name
  file_name          = "flatcar.img"
  url                = local.distros.flatcar.qemu.url
  checksum           = local.distros.flatcar.qemu.checksum
  checksum_algorithm = "sha512"

  lifecycle {
    replace_triggered_by = [
      terraform_data.flatcar_release
    ]
  }
}

resource "proxmox_virtual_environment_download_file" "talos" {
  content_type = "iso"
  datastore_id = "local"
  file_name    = "talos.iso"
  node_name    = var.node_name
  url = format(
    "https://factory.talos.dev/image/%s/%s/metal-amd64.iso",
    jsondecode(data.http.talos_customization.response_body).id,
    local.distros.talos.version
  )

  lifecycle {
    replace_triggered_by = [
      terraform_data.talos_release
    ]
  }
}
