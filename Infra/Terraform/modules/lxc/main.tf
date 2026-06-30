terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}


resource "proxmox_virtual_environment_container" "this" {
  node_name     = var.node_name
  vm_id         = var.vm_id
  started       = var.started
  start_on_boot = var.start_on_boot

  unprivileged = var.unprivileged

  operating_system {
    template_file_id = var.template_file_id
    type             = var.os_type
  }

  cpu {
    cores = var.cores
  }

  memory {
    dedicated = var.memory_mb
  }

  disk {
    datastore_id = var.datastore_id
    size         = var.disk_size
  }

  network_interface {
    name    = "eth0"
    bridge  = var.bridge
    vlan_id = var.vlan_id
  }

  initialization {
    hostname = var.hostname
    ip_config {
      ipv4 {
        address = var.ip_address
        gateway = var.gateway
      }
    }
    user_account {
      password = var.lxc_password
      keys = var.ssh_keys
    }

  }
  features {
    nesting = var.nesting
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      private_key = file("~/.ssh/id_ed25519")
      password = var.lxc_password
      host     = split("/", var.ip_address)[0]
    }

    inline = [
      "useradd -m -s /bin/bash dev",
      "usermod -aG sudo dev",
      "mkdir -p /home/dev/.ssh",
      "echo '${join("\n", var.ssh_keys)}' >> /home/dev/.ssh/authorized_keys",
      "chown -R dev:dev /home/dev/.ssh",
      "chmod 700 /home/dev/.ssh",
      "chmod 600 /home/dev/.ssh/authorized_keys",
      "echo 'dev ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/dev",
    ]
  }

 lifecycle {
  ignore_changes = [disk]
  # prevent_destroy = true
  }
}