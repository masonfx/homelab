module "talos" {
  source = "./talos"

  providers = {
    proxmox = proxmox
  }

  # disk_owner = var.disk_owner
  # storage_pool = var.storage_pool

  image = {
    version        = var.image.version
    update_version = var.image.update_version
    schematic      = file("${path.module}/talos/image/schematic.yaml")
  }

  cilium = {
    values  = file("${path.module}/../k8s/infrastructure/network/cilium/values.yaml")
    install = file("${path.module}/talos/inline-manifests/cilium-install.yaml")
  }

  coredns = {
    install = file("${path.module}/talos/inline-manifests/coredns-install.yaml")
  }

  cluster = {
    name               = "talos"
    endpoint           = "api.dev.masonfox.me"
    gateway            = "192.168.10.1"
    vip                = "192.168.10.20"
    talos_version      = var.image.version
    proxmox_cluster    = var.proxmox.cluster_name
    kubernetes_version = "1.33.1"
  }

  nodes = {
    "ctrl-01" = {
      host_node     = "pve1"
      machine_type  = "controlplane"
      datastore_id  = "local-lvm"
      ip            = "192.168.10.21"
      mac_address   = "bc:24:11:e6:ba:21"
      vm_id         = 8101
      cpu           = 2
      ram_dedicated = 4096
      update        = false
      igpu          = false
    }
    "ctrl-02" = {
      host_node     = "pve1" # this needs to change
      machine_type  = "controlplane"
      datastore_id  = "local-lvm"
      ip            = "192.168.10.22"
      mac_address   = "bc:24:11:e6:ba:22"
      vm_id         = 8102
      cpu           = 2
      ram_dedicated = 4096
      update        = false
      igpu          = false
    }
    "ctrl-03" = {
      host_node     = "pve3"
      machine_type  = "controlplane"
      datastore_id  = "local-lvm"
      ip            = "192.168.10.23"
      mac_address   = "bc:24:11:e6:ba:23"
      vm_id         = 8103
      cpu           = 2
      ram_dedicated = 4096
      update        = false
      igpu          = false
    }
    "work-01" = {
      host_node     = "pve1"
      machine_type  = "worker"
      datastore_id  = "local-lvm"
      ip            = "192.168.10.31"
      mac_address   = "bc:24:11:e6:ba:31"
      vm_id         = 8201
      cpu           = 8
      ram_dedicated = 10240
      igpu          = false
      update        = false
      disks = {
        longhorn = {
          device     = "/dev/sdb"
          size       = "180G"
          type       = "scsi"
          mountpoint = "/var/lib/longhorn"
        }
      }
    }
    # "work-02" = {
    #   host_node     = "pve2"
    #   machine_type  = "worker"
    #   datastore_id  = "local-lvm"
    #   ip            = "192.168.10.32"
    #   mac_address   = "bc:24:11:e6:ba:32"
    #   vm_id         = 8202
    #   cpu           = 6
    #   ram_dedicated = 10240
    #   igpu          = false
    #   update        = false
    #   disks = {
    #     longhorn = {
    #       device     = "/dev/sdb"
    #       size       = "180G"
    #       type       = "scsi"
    #       mountpoint = "/var/lib/longhorn"
    #     }
    #   }
    # }
    # "work-03" = {
    #   host_node     = "pve3"
    #   machine_type  = "worker"
    #   datastore_id  = "local-lvm"
    #   ip            = "192.168.10.33"
    #   mac_address   = "bc:24:11:e6:ba:33"
    #   vm_id         = 8202
    #   cpu           = 6
    #   ram_dedicated = 10240
    #   igpu          = false
    #   update        = false
    #   disks = {
    #     longhorn = {
    #       device     = "/dev/sdb"
    #       size       = "180G"
    #       type       = "scsi"
    #       mountpoint = "/var/lib/longhorn"
    #     }
    #   }
    # }
  }
}

