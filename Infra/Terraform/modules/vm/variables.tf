variable "name" {
  description = "Name of the VM"
  type        = string
}

variable "on_boot" {
  description = "Start the VM on Proxmox host boot"
  type        = bool
  default     = false
}

variable "node_name" {
  description = "Proxmox node name where the VM will be created"
  type        = string

  validation {
    condition     = length(var.node_name) > 0
    error_message = "Node name must not be empty."
  }
}

variable "vm_id" {
  description = "Proxmox VM ID"
  type        = number

  validation {
    condition     = var.vm_id >= 100 && var.vm_id <= 9999
    error_message = "VM ID must be a positive integer."
  }
}

variable "clone_vm_id" {
  description = "Proxmox VM ID to clone"
  type        = number
}

variable "cores" {
  description = "Number of CPU cores for the VM"
  type        = number
  default     = 2
}

variable "memory_mb" {
  description = "Amount of memory (in MB) for the VM. Must be a multiple of 512."
  type        = number
  default     = 4096

  validation {
    condition     = var.memory_mb >= 512 && var.memory_mb % 512 == 0
    error_message = "memory_mb must be at least 512 and a multiple of 512."
  }
}

variable "disk_size" {
  description = "Size of the disk (in GB) for the VM. Must be at least 8."
  type        = number
  default     = 32

  validation {
    condition     = var.disk_size >= 8
    error_message = "disk_size must be at least 8 GB."
  }
}

variable "datastore_id" {
  description = "Proxmox datastore ID where the VM will be created"
  type        = string
  default     = "vm-storage"
}

variable "vlan_id" {
  description = "VLAN ID for the VM's network interface"
  type        = number
}

variable "bridge" {
  description = "Proxmox bridge for the VM's network interface"
  type        = string
}

variable "ip_address" {
  description = "IPv4 address with CIDR prefix for the VM, e.g. 10.20.0.10/24"
  type        = string

  validation {
    condition     = can(cidrhost(var.ip_address, 0))
    error_message = "ip_address must be a valid CIDR notation address, e.g. 10.20.0.10/24."
  }
}

variable "gateway" {
  description = "Default gateway IP address for the VM's network interface"
  type        = string

  validation {
    condition     = can(regex("^(\\d{1,3}\\.){3}\\d{1,3}$", var.gateway))
    error_message = "gateway must be a valid IPv4 address, e.g. 10.20.0.1."
  }
}

variable "vm_username" {
  description = "Username to create on the VM via cloud-init"
  type        = string
  sensitive   = true
}

variable "vm_password" {
  description = "Password for the VM user"
  type        = string
  sensitive   = true
}
