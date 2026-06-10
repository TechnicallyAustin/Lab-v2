output "vm_ids" {
  description = "IDs of the VMs"
  value       = { for k, v in module.infra : k => v.vm_id }
}
output "vm_names" {
  description = "Names of the VMs"
  value       = { for k, v in module.infra : k => v.name }
}
output "vm_ip_addresses" {
  description = "IP Addresses of the VMs"
  value       = { for k, v in module.infra : k => v.ip_address }
}
