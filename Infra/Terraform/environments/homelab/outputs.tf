# =============================================================================
# outputs.tf — Output value declarations
# =============================================================================
# Outputs are printed after `terraform apply` and readable with `terraform output`.
# Useful for seeing IPs, IDs, and other values that Proxmox assigns at runtime.
#
# Output block syntax:
#   output "<name>" {
#     description = "What this value represents"
#     value       = <reference to a resource attribute>
#   }
#
# Resource attributes are referenced as:
#   resource_type.local_name.attribute
#   e.g.  proxmox_virtual_environment_vm.core_infra_01.ipv4_addresses
# =============================================================================


# Add output blocks here once you have resources defined in main.tf.
# Good starting outputs:
#   - The VM's assigned IP address  (.ipv4_addresses)
#   - The VM's numeric ID           (.vm_id)
#   - The downloaded image file ID  (.id)
