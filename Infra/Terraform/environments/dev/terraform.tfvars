infra = {
  data-01 = {
    role         = "Lab Data Infrastructure"
    description  = "Lab Database Infrastructure VM Hosting Data and Storage Services."
    on_boot      = true
    name         = "data-01"
    node_name    = "platform-01"
    vm_id        = 102
    clone_vm_id  = 9000
    cores        = 4
    memory_mb    = 16384
    disk_size    = 100
    datastore_id = "vm-storage"
    bridge       = "vmbr0"
    ip_address   = "192.168.0.213/24"
    gateway      = "192.168.0.1"
  }
  k8s-control-01 = {
    role         = "K8s control plane node"
    description  = "K8s control plane node VM Hosting Kubernetes Control Plane Services."
    on_boot      = true
    name         = "k8s-control-01"
    node_name    = "platform-01"
    vm_id        = 103
    clone_vm_id  = 9000
    cores        = 4
    memory_mb    = 8192
    disk_size    = 50
    datastore_id = "vm-storage"
    bridge       = "vmbr0"
    ip_address   = "192.168.0.214/24"
    gateway      = "192.168.0.1"
  }
  k8s-worker-01 = {
    role         = "K8s Worker Node"
    description  = "K8s Worker Node VM Hosting Kubernetes Worker Services. - Apps, Automation and Observability"
    on_boot      = true
    name         = "k8s-worker-01"
    node_name    = "platform-01"
    vm_id        = 104
    clone_vm_id  = 9000
    cores        = 6
    memory_mb    = 24576
    disk_size    = 150
    datastore_id = "vm-storage"
    bridge       = "vmbr0"
    ip_address   = "192.168.0.215/24"
    gateway      = "192.168.0.1"
  }
  k8s-worker-02 = {
    role         = "K8s Worker Node"
    description  = "K8s Worker Node VM Hosting Kubernetes Worker Services. - AI and Dev Platform"
    on_boot      = true
    name         = "k8s-worker-02"
    node_name    = "platform-01"
    vm_id        = 105
    clone_vm_id  = 9000
    cores        = 6
    memory_mb    = 49152
    disk_size    = 150
    datastore_id = "vm-storage"
    bridge       = "vmbr0"
    ip_address   = "192.168.0.216/24"
    gateway      = "192.168.0.1"
  }

  ## HP Mini Proxmox VM's

  ansible-01 = {
    role         = "Ansible Node"
    description  = "Ansible Node VM Hosting Ansible Services."
    on_boot      = true
    name         = "ansible-01"
    node_name    = "infra-01"
    vm_id        = 106
    clone_vm_id  = 9001
    cores        = 2
    memory_mb    = 2048
    disk_size    = 32
    datastore_id = "local-lvm"
    bridge       = "vmbr0"
    ip_address   = "192.168.0.210/24"
    gateway      = "192.168.0.1"
  }
  network-01 = {
    role         = "Network Node"
    description  = "Network Node VM Hosting Core Network Services."
    on_boot      = true
    name         = "network-01"
    node_name    = "infra-01"
    vm_id        = 107
    clone_vm_id  = 9001
    cores        = 2
    memory_mb    = 2048
    disk_size    = 32
    datastore_id = "local-lvm"
    bridge       = "vmbr0"
    ip_address   = "192.168.0.211/24"
    gateway      = "192.168.0.1"
  }
  core-infra-01 = {
    role         = "Core Infrastructure Node"
    description  = "Core Infrastructure Node VM Hosting Core Infrastructure Services."
    on_boot      = true
    name         = "core-infra-01"
    node_name    = "infra-01"
    vm_id        = 108
    clone_vm_id  = 9001
    cores        = 1
    memory_mb    = 2048
    disk_size    = 32
    datastore_id = "local-lvm"
    bridge       = "vmbr0"
    ip_address   = "192.168.0.212/24"
    gateway      = "192.168.0.1"
  }
}