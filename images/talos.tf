resource "terraform_data" "talos_release" {
  input = local.distros.talos.version
}

resource "proxmox_virtual_environment_download_file" "talos" {
  content_type = "iso"
  datastore_id = "local"
  file_name    = "talos.img"
  node_name    = "pve"
  url          = local.distros.talos.qemu.url
}
