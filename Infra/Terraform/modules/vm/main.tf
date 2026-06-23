terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

resource "proxmox_virtual_environment_vm" "this" {
  name            = var.name
  node_name       = var.node_name
  vm_id           = var.vm_id
  on_boot         = var.on_boot
  stop_on_destroy = true

  # lifecycle {
  #     prevent_destroy = true
  #     ignore_changes = [clone]
  # }

  clone { vm_id = var.clone_vm_id }

  cpu { cores = var.cores }
  memory { dedicated = var.memory_mb }

  disk {
    datastore_id = var.datastore_id
    interface    = "virtio0"
    size         = var.disk_size
    discard      = "on"
    ssd          = true
  }

  network_device {
    model   = "virtio"
    bridge  = var.bridge
    vlan_id = var.vlan_id
  }

  initialization {
    ip_config {
      ipv4 {
        address = var.ip_address
        gateway = var.gateway
      }
    }

    user_account {
      username = var.vm_username
      password = var.vm_password
    }
  }












}