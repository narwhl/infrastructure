resource "terraform_data" "flatcar_release" {
  input = local.distros.flatcar.version
}

resource "proxmox_virtual_environment_download_file" "flatcar" {
  content_type = "iso"
  datastore_id = "local"
  file_name    = "flatcar.img"
  node_name    = "pve"
  url          = local.distros.flatcar.qemu.url

  lifecycle {
    replace_triggered_by = [terraform_data.flatcar_release]
  }
}
