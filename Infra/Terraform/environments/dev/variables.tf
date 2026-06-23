
variable "proxmox_api_token_id" {
  description = "Proxmox API token ID"
  type        = string
  sensitive   = true
}

variable "proxmox_api_token_secret" {
  description = "Proxmox API token secret"
  type        = string
  sensitive   = true
}

variable "proxmox_endpoint" {
  description = "Proxmox API endpoint"
  type        = string
  sensitive   = true
}

variable "proxmox_ssh_user" {
  description = "Proxmox SSH username"
  type        = string
  sensitive   = true
}

variable "proxmox_ssh_password" {
  description = "Proxmox SSH password"
  type        = string
  sensitive   = true
}

variable "proxmox_tls_insecure" {
  description = "Allow self-signed TLS certificates (set true for home labs)"
  type        = bool
  default     = true
}

variable "vm_username" {
  description = "Username to create on the VM via cloud-init"
  type        = string
  sensitive   = true
}

variable "vm_password" {
  description = "Password for the VM user account"
  type        = string
  sensitive   = true
}

variable "lxc_password" {
  description = "Password for the LXC user account"
  type        = string
  sensitive   = true
}

variable "platform" {
  type = map(object({
    role         = string
    description  = string
    on_boot      = bool
    name         = string
    node_name    = string
    vm_id        = number
    clone_vm_id  = number
    cores        = number
    memory_mb    = number
    disk_size    = number
    datastore_id = string
    vlan_id      = optional(number)
    bridge       = string
    ip_address   = string
    gateway      = string
  }))
}

variable "infrastructure" {
  type = map(object({
    role             = string
    description      = string
    start_on_boot    = bool
    hostname         = string
    node_name        = string
    vm_id            = number
    template_file_id = string
    os_type          = string
    unprivileged     = bool
    nesting          = bool
    started          = bool
    cores            = number
    memory_mb        = number
    disk_size        = number
    datastore_id     = string
    vlan_id          = optional(number)
    bridge           = string
    ip_address       = string
    gateway          = string
  }))
}