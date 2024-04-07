data "vsphere_datacenter" "this" {
  name = "compute"
}

data "vsphere_datastore" "boot" {
  name          = "boot"
  datacenter_id = data.vsphere_datacenter.this.id
}

resource "vsphere_content_library" "local" {
  name            = "ami"
  description     = "Content library for VM templates"
  storage_backing = [data.vsphere_datastore.boot.id]
}

resource "vsphere_content_library_item" "flatcar" {
  name        = "flatcar"
  description = "Flatcar Linux OVF Template"
  file_url    = "https://stable.release.flatcar-linux.net/amd64-usr/current/flatcar_production_vmware_ova.ova"
  library_id  = vsphere_content_library.local.id
}
