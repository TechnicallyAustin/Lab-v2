output "vm_id" {
  description = "Proxmox LXC ID"
  value       = proxmox_virtual_environment_container.this.vm_id
}

output "node_name" {
  description = "Proxmox LXC Node Name"
  value       = var.node_name
}

output "hostname" {
  description = "LXC hostname as set in Proxmox"
  value       = var.hostname
}

output "ip_address" {
  description = "Configured IP address of the LXC"
  value       = var.ip_address
}