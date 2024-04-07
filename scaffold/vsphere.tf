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
