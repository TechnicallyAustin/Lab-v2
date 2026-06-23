variable "hostname" {
  description = "Name of the LXC"
  type        = string
}

variable "start_on_boot" {
  description = "Start the LXC on Proxmox host boot"
  type        = bool
  default     = true
}

variable "node_name" {
  description = "Proxmox node name where the LXC will be created"
  type        = string

  validation {
    condition     = length(var.node_name) > 0
    error_message = "Node name must not be empty."
  }
}

variable "vm_id" {
  description = "Proxmox LXC ID"
  type        = number

  validation {
    condition     = var.vm_id >= 100 && var.vm_id <= 9999
    error_message = "LXC ID must be between 100 and 9999."
  }
}

variable "template_file_id" {
  description = "File Id of the Template to build from"
  type        = string
}

variable "os_type" {
  description = "the Operating system type for the LXC"
  type        = string
  default     = "ubuntu"
}

variable "unprivileged" {
  description = "Create unprivileged container"
  type        = bool
  default     = true
}

variable "nesting" {
  description = "Enable nesting support"
  type        = bool
  default     = true
}

variable "started" {
  description = "Start container after creation"
  type        = bool
  default     = true
}

variable "cores" {
  description = "Number of CPU cores for the LXC"
  type        = number
  default     = 2
}

variable "memory_mb" {
  description = "Amount of memory (in MB) for the LXC. Must be a multiple of 512."
  type        = number
  default     = 4096

  validation {
    condition     = var.memory_mb >= 512 && var.memory_mb % 512 == 0
    error_message = "memory_mb must be at least 512 and a multiple of 512."
  }
}

variable "disk_size" {
  description = "Size of the disk (in GB) for the LXC. Must be at least 8."
  type        = number
  default     = 32

  validation {
    condition     = var.disk_size >= 8
    error_message = "disk_size must be at least 8 GB."
  }
}

variable "datastore_id" {
  description = "Proxmox datastore ID where the LXC will be created"
  type        = string
  default     = "vm-storage"
}

variable "vlan_id" {
  description = "Optional VLAN ID for the LXC network interface"
  type        = number
  default     = null
}

variable "bridge" {
  description = "Proxmox bridge for the LXC network interface"
  type        = string
}

variable "ip_address" {
  description = "IPv4 address with CIDR prefix for the LXC, e.g. 10.20.0.10/24"
  type        = string

  validation {
    condition     = can(cidrhost(var.ip_address, 0))
    error_message = "ip_address must be a valid CIDR notation address, e.g. 10.20.0.10/24."
  }
}

variable "gateway" {
  description = "Default gateway IP address for the LXC network interface"
  type        = string

  validation {
    condition     = can(regex("^(\\d{1,3}\\.){3}\\d{1,3}$", var.gateway))
    error_message = "gateway must be a valid IPv4 address, e.g. 10.20.0.1."
  }
}

variable "lxc_password" {
  description = "Password for the LXC user"
  type        = string
  sensitive   = true
}
