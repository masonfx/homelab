locals {
  cluster_domain = "dev.masonfox.me"
  cluster_subnet = "192.168.10"
  talos_current_version = "v1.10.2"
  talos_update_version = "v1.10.2"
  kube_current_version = "1.33.1"
}

module "talos" {
  source = "./talos"

  providers = {
    proxmox = proxmox
  }

  # disk_owner = var.disk_owner
  # storage_pool = var.storage_pool

  image = {
    version      	      = local.talos_current_version	# renovate: github-releases=siderolabs/talos
    update_version    	= local.talos_update_version	# Target Talos version for updates
    schematic           = file("${path.module}/talos/image/schematic.yaml")
    proxmox_datastore 	= "local"	# Your Proxmox datastore name
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
    domain             = local.cluster_domain
    endpoint           = "api.${local.cluster_domain}"
    gateway            = "${local.cluster_subnet}.1"
    vip                = "${local.cluster_subnet}.20"
    talos_version      = local.talos_current_version
    proxmox_cluster    = var.proxmox.cluster_name
    kubernetes_version = local.kube_current_version
  }

  nodes = {
    "ctrl-01" = {
      host_node     = "pve1"
      machine_type  = "controlplane"
      datastore_id  = "local-lvm"
      ip            = "${local.cluster_subnet}.21"
      mac_address   = "bc:24:11:e6:ba:21"
      vm_id         = 8101
      cpu           = 4
      ram_dedicated = 4096
      update        = false
      igpu          = false
    }
    "ctrl-02" = {
      host_node     = "pve1" # this needs to change
      machine_type  = "controlplane"
      datastore_id  = "local-lvm"
      ip            = "${local.cluster_subnet}.22"
      mac_address   = "bc:24:11:e6:ba:22"
      vm_id         = 8102
      cpu           = 4
      ram_dedicated = 4096
      update        = false
      igpu          = false
    }
    "ctrl-03" = {
      host_node     = "pve3"
      machine_type  = "controlplane"
      datastore_id  = "local-lvm"
      ip            = "${local.cluster_subnet}.23"
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
      ip            = "${local.cluster_subnet}.31"
      mac_address   = "bc:24:11:e6:ba:31"
      vm_id         = 8201
      cpu           = 6
      ram_dedicated = 8192
      igpu          = false
      update        = false
      disks = {
        longhorn = {
          device     = "/dev/sdb"
          size       = "1024G"
          type       = "scsi"
          mountpoint = "/var/lib/longhorn"
        }
      }
    }
    # "work-02" = {
    #   host_node     = "pve2"
    #   machine_type  = "worker"
    #   datastore_id  = "local-lvm"
    #   ip            = "${local.cluster_subnet}.32"
    #   mac_address   = "bc:24:11:e6:ba:32"
    #   vm_id         = 8202
    #   cpu           = 6
    #   ram_dedicated = 10240
    #   igpu          = false
    #   update        = false
    #   disks = {
    #     longhorn = {
    #       device     = "/dev/sdb"
    #       size       = "1024G"
    #       type       = "scsi"
    #       mountpoint = "/var/lib/longhorn"
    #     }
    #   }
    # }
    "work-03" = {
      host_node     = "pve3"
      machine_type  = "worker"
      datastore_id  = "local-lvm"
      ip            = "${local.cluster_subnet}.33"
      mac_address   = "bc:24:11:e6:ba:33"
      vm_id         = 8202
      cpu           = 2
      ram_dedicated = 8196
      igpu          = true
      update        = false
      disks = {
        longhorn = {
          device     = "/dev/sdb"
          size       = "1024G"
          type       = "scsi"
          mountpoint = "/var/lib/longhorn"
        }
      }
    }
  }
}

