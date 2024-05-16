resource "terraform_data" "flatcar_release" {
  input = local.distros.flatcar.version
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
