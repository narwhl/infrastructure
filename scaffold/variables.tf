variable "node_name" {
  type        = string
  default     = "pve"
  description = "Name of the Proxmox Host"
}

variable "storage" {
  type    = string
  default = "vmpool"
}

variable "cluster_endpoint" {
  type = string
}

variable "network" {
  type = object({
    block  = string
    suffix = number
  })
  default = {
    block  = "172.27.1.0"
    suffix = 24
  }
}

variable "cluster" {
  type = object({
    controlplane_count = number
    worker_count       = number
  })
  default = {
    controlplane_count = 3
    worker_count       = 3
  }
}


variable "resource_alloc" {
  type = map(object({
    memory        = number
    vcpus         = number
    disk_size     = number
    address_start = number
  }))
  default = {
    "controlplane" = {
      memory        = 4096
      vcpus         = 4
      disk_size     = 48
      address_start = 30
    }
    "worker" = {
      memory        = 16384
      vcpus         = 8
      disk_size     = 64
      address_start = 40
    }
  }
}
