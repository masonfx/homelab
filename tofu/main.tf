module "talos" {
  source = "./talos"

  providers = {
    proxmox = proxmox
  }

  # disk_owner = var.disk_owner
  # storage_pool = var.storage_pool


  image = {
    version        = "v1.10.2"
    update_version = "v1.10.2" # renovate: github-releases=siderolabs/talos
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
    gateway            = "192.168.20.1"  # Network gateway
    vip                = "192.168.20.20" # Control plane VIP
    talos_version      = "v1.10.2"
    proxmox_cluster    = "kube"
    kubernetes_version = "1.33.1" # renovate: github-releases=kubernetes/kubernetes
  }

  nodes = {
    "ctrl-01" = {
      host_node     = "pve0"
      machine_type  = "controlplane"
      ip            = "192.168.20.21"
      mac_address   = "bc:24:11:e6:ba:21"
      vm_id         = 8101
      cpu           = 2
      ram_dedicated = 4096
      update        = false
      igpu          = false
    }
    "ctrl-02" = {
      host_node     = "pve0"
      machine_type  = "controlplane"
      ip            = "192.168.20.22"
      mac_address   = "bc:24:11:e6:ba:22"
      vm_id         = 8102
      cpu           = 2
      ram_dedicated = 4096
      update        = false
      igpu          = false
    }
    "ctrl-03" = {
      host_node     = "pve0"
      machine_type  = "controlplane"
      ip            = "192.168.20.23"
      mac_address   = "bc:24:11:e6:ba:23"
      vm_id         = 8103
      cpu           = 2
      ram_dedicated = 4096
      update        = false
    }
    "work-01" = {
      host_node     = "pve0"
      machine_type  = "worker"
      ip            = "192.168.20.31"
      mac_address   = "bc:24:11:e6:ba:31"
      vm_id         = 8201
      cpu           = 6
      ram_dedicated = 10240
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
    "work-02" = {
      host_node     = "pve0"
      machine_type  = "worker"
      ip            = "192.168.20.32"
      mac_address   = "bc:24:11:e6:ba:32"
      vm_id         = 8202
      cpu           = 6
      ram_dedicated = 10240
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
  }
}

