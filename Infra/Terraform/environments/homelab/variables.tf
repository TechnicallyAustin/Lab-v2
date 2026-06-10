# =============================================================================
# variables.tf — Input variable declarations
# =============================================================================
# This file DECLARES variables — it does not assign values.
# Values are assigned in terraform.tfvars.
# Reference a variable anywhere with: var.<name>
#
# Variable block syntax:
#   variable "<name>" {
#     description = "What this is for"           # always include this
#     type        = string | number | bool        # always include this
#     default     = "value"                       # omit to make it required
#   }
# =============================================================================


# VARIABLE 1
# Declare a variable for the Proxmox node name.
#   name        : proxmox_node
#   type        : string
#   description : the hostname of your Proxmox node (shown in the PVE web UI)
#   default     : give it a sensible default so it isn't required every time
#
# Write your variable block here:



# VARIABLE 2
# Declare a variable for the SSH public key file path.
#   name        : ssh_public_key_path
#   type        : string
#   description : path to the .pub key file on your local machine
#   default     : omit — this should be required (set in terraform.tfvars)
#
# Write your variable block here:
