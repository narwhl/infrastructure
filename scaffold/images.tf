resource "vsphere_content_library_item" "flatcar" {
  name        = "flatcar"
  description = "Flatcar Linux OVF Template"
  file_url    = local.distros.flatcar.ova.url
  library_id  = vsphere_content_library.local.id

  lifecycle {
    replace_triggered_by = [terraform_data.flatcar_release]
  }
}
