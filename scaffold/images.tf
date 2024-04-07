resource "vsphere_content_library_item" "flatcar" {
  name        = "flatcar"
  description = "Flatcar Linux OVF Template"
  file_url    = "https://stable.release.flatcar-linux.net/amd64-usr/current/flatcar_production_vmware_ova.ova"
  library_id  = vsphere_content_library.local.id

  lifecycle {
    replace_triggered_by = [terraform_data.flatcar_release]
  }
}
