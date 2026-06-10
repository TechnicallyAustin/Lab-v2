# =============================================================================
# main.tf — Where your resources live
# =============================================================================
# Resources are the actual infrastructure (VMs, containers, downloads, etc.).
# Terraform merges all .tf files in this directory automatically.
#
# Resource block syntax:
#   resource "<PROVIDER_TYPE>" "<YOUR_LOCAL_NAME>" {
#     argument = value
#   }
#
# The combination of PROVIDER_TYPE + YOUR_LOCAL_NAME must be unique.
# Duplicate local names are a hard error — see GUIDE.md section 2.
# =============================================================================


# STEP 1 — Add a data source to read your SSH public key from disk.
#   Data source type : "local_file"  (from the hashicorp/local provider)
#   Give it the local name: ssh_public_key
#   It needs one argument: filename  →  use the variable you declared in variables.tf
#   Reference it elsewhere with: data.local_file.ssh_public_key.content
#   Hint: wrap the content in trimspace() to remove the trailing newline.
#
# Write your data block here:



# STEP 2 — Add a download resource to pull the Ubuntu cloud image onto Proxmox.
#   Resource type : "proxmox_virtual_environment_download_file"
#   Give it the local name: ubuntu_cloud_image
#   Required arguments:
#     content_type  → "iso"  (for cloud images — NOT "import")
#     datastore_id  → the Proxmox storage pool name (e.g. "local")
#     node_name     → use your proxmox_node variable
#     url           → https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
#     file_name     → what to save it as on Proxmox
#     overwrite     → false  (skip re-download if the file already exists)
#
# Write your resource block here:



# STEP 3 — Add a VM resource.
#   Resource type : "proxmox_virtual_environment_vm"
#   Give it a unique local name matching the VM's purpose (e.g. core_infra_01)
#   Required top-level arguments:
#     name            → display name shown in Proxmox UI
#     node_name       → use your variable
#     vm_id           → unique numeric ID (e.g. 100)
#     stop_on_destroy → true
#
#   Nested blocks to add (all are TOP-LEVEL on the VM, not inside each other):
#     cpu        { cores, type }
#     memory     { dedicated }       ← value is in MB
#     disk       { datastore_id, file_id, interface, size, discard, iothread }
#     network_device { bridge, model }
#     initialization {
#       ip_config { ipv4 { address } }   ← use "dhcp" or "x.x.x.x/24"
#       user_account { username, keys }  ← keys is a list: [ trimspace(...) ]
#     }
#
#   COMMON MISTAKE: disk and network_device belong on the VM, not inside initialization.
#
# Write your resource block here:









