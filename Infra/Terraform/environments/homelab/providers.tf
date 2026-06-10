# =============================================================================
# providers.tf — Provider requirements and configuration
# =============================================================================
# This file does two things:
#   1. Declares which providers Terraform needs to download  (terraform block)
#   2. Configures how each provider connects               (provider block)
#
# Run `terraform init` after any change here to download new providers.
# =============================================================================


# STEP 1 — Declare required providers inside a terraform block.
#   The terraform block uses a required_providers map.
#   Each entry has: source and version.
#
#   You need two providers:
#     proxmox  →  source "bpg/proxmox",       version "0.107.0"
#     local    →  source "hashicorp/local",    version "~> 2.0"
#                 ("~> 2.0" means any 2.x version — used for reading local files)
#
# Write your terraform block here:



# STEP 2 — Configure the proxmox provider.
#   Credentials must NOT be hardcoded here.
#   The provider reads them from environment variables automatically:
#
#     export PROXMOX_VE_ENDPOINT="https://<proxmox-ip>:8006/"
#     export PROXMOX_VE_API_TOKEN="user@pam!tokenname=xxxxxxxx-..."
#
#   The only argument you need to set directly is:
#     insecure = true   (allows self-signed TLS certs, common in home labs)
#
# Write your provider block here:

