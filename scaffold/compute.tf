module "nodes" {
  for_each       = merge(local.controlplanes, local.workers)
  source         = "github.com/narwhl/blueprint//modules/proxmox"
  name           = each.key
  node           = var.node_name
  vcpus          = var.cluster[each.value.role].vcpus
  memory         = var.cluster[each.value.role].memory
  disk_size      = var.cluster[each.value.role].disk_size
  storage_pool   = var.storage_pool
  use_iso        = true
  os_template_id = proxmox_virtual_environment_download_file.talos.id
  provisioning_config = {
    type    = "talos"
    payload = ""
  }
}
