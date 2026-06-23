module "platform" {
  source   = "../../modules/vm"
  for_each = var.platform

  name        = each.value.name
  node_name   = each.value.node_name
  vm_id       = each.value.vm_id
  clone_vm_id = each.value.clone_vm_id

  on_boot = each.value.on_boot

  cores        = each.value.cores
  memory_mb    = each.value.memory_mb
  disk_size    = each.value.disk_size
  datastore_id = each.value.datastore_id
  vlan_id      = try(each.value.vlan_id, null)
  bridge       = each.value.bridge
  ip_address   = each.value.ip_address
  gateway      = each.value.gateway

  vm_username = var.vm_username
  vm_password = var.vm_password
}


module "infrastructure" {
  source   = "../../modules/lxc"
  for_each = var.infrastructure

  hostname         = each.value.hostname
  node_name        = each.value.node_name
  vm_id            = each.value.vm_id
  template_file_id = each.value.template_file_id
  os_type          = each.value.os_type
  unprivileged     = each.value.unprivileged
  nesting          = each.value.nesting
  started          = each.value.started

  start_on_boot = each.value.start_on_boot

  cores        = each.value.cores
  memory_mb    = each.value.memory_mb
  disk_size    = each.value.disk_size
  datastore_id = each.value.datastore_id
  vlan_id      = try(each.value.vlan_id, null)
  bridge       = each.value.bridge
  ip_address   = each.value.ip_address
  gateway      = each.value.gateway

  lxc_password = var.lxc_password
}














