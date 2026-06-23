# ---------- VMs (module.platform) ----------
output "vm_ids" {
  description = "IDs of the VMs"
  value       = { for k, v in module.platform : k => v.vm_id }
}

output "vm_names" {
  description = "Names of the VMs"
  value       = { for k, v in module.platform : k => v.name }
}

output "vm_ip_addresses" {
  description = "IP addresses of the VMs"
  value       = { for k, v in module.platform : k => v.ip_address }
}

# ---------- LXCs (module.infra) ----------
output "lxc_ids" {
  description = "IDs of the LXCs"
  value       = { for k, v in module.infrastructure : k => v.vm_id }
}

output "lxc_hostnames" {
  description = "LXC hostnames as set in Proxmox"
  value       = { for k, v in module.infrastructure : k => v.hostname }
}

output "lxc_ip_addresses" {
  description = "Configured IP addresses of the LXCs"
  value       = { for k, v in module.infrastructure : k => v.ip_address }
}

output "lxc_nodes" {
  description = "Proxmox node each LXC runs on"
  value       = { for k, v in module.infrastructure : k => v.node_name }
}