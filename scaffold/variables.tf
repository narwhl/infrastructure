variable "node_name" {
  type        = string
  default     = "pve"
  description = "Name of the Proxmox Host"
}

variable "storage_pool" {
  type    = string
  default = "vmpool"
}

variable "cluster_endpoint" {
  type    = string
  default = "https://cluster.k8s.narwhl.dev:6443"
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
  type = map(object({
    count         = number
    memory        = number
    vcpus         = number
    disk_size     = number
    address_start = number
  }))
  default = {
    "controlplane" = {
      count         = 3
      memory        = 4096
      vcpus         = 4
      disk_size     = 48
      address_start = 30
    }
    "worker" = {
      count         = 3
      memory        = 16384
      vcpus         = 8
      disk_size     = 64
      address_start = 40
    }
  }
}
