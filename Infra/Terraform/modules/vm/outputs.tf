output "vm_id" {
  description = "Proxmox VM ID"
  value       = proxmox_virtual_environment_vm.this.vm_id
}

output "name" {
  description = "VM name as set in Proxmox"
  value       = proxmox_virtual_environment_vm.this.name
}

output "ip_address" {
  description = "Configured IP address of the VM"
  value       = var.ip_address
}