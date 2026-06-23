Infrastructure
├-- Network
│   ├-- DNS - AdGuard Home
│   ├-- DHCP - OPNsense *
│   ├-- Reverse Proxy - Caddy
│   ├-- VPN - Tailscale
│   ├-- TLS - Let's Encrypt *
│   └-- Firewall - OPNsense
│
├-- Compute
│   ├--Hypervisor - Proxmox
│   ├-- VM Provisioning - Terraform
│   ├-- OS Bootstrap - Cloud-init
│   └-- Configuration - Ansible
│
├-- Storage
│   ├-- Storage Pool - ZFS
│   ├-- VM Storage - ZFS Datasets
│   ├-- Object Storage - MinIO
│   ├-- Snapshots - ZFS
│   └-- Backups - Proxmox Backup Server
│
└-- Identity
    ├-- SSO - Authentik
    ├-- MFA - Authentik
    ├-- Password Vault - Vaultwarden
    ├-- Secrets - External Secrets Operator
    ├-- Certificates - cert-manager
    └-- OIDC - Authentik

Platform
│
├-- Kubernetes
│   ├-- Cluster - k3s
│   ├-- Container Runtime - containerd
│   ├-- Ingress - Traefik
│   ├-- Networking - Cilium *
│   ├-- Storage - Longhorn *
│   ├-- Namespaces - Kubernetes
│   ├-- RBAC - Kubernetes
│   └-- Package Management - Helm
│
├-- GitOps
│   ├-- Application Sync - ArgoCD
│   ├-- Deployments - ArgoCD
│   ├-- Drift Detection - ArgoCD
│   ├-- Helm Releases - ArgoCD
│   └-- Environment Management - Kustomize *
│
├-- CI/CD
│   ├-- Source Control - GitHub
│   ├-- Infrastructure CI - GitHub Actions
│   ├-- Application CI - GitHub Actions
│   ├-- Container Builds - GitHub Actions
│   ├-- Image Registry - GHCR *
│   └-- Release Automation - GitHub Actions
│
├-- Observability
│   ├-- Metrics - Prometheus
│   ├-- Dashboards - Grafana
│   ├-- Logs - Loki *
│   ├-- Tracing - Tempo *
│   ├-- Telemetry - OpenTelemetry *
│   └-- Alerting - Alertmanager *
│
├── Automation
│   ├-- Workflows - n8n
│   ├-- Scheduling - Kubernetes CronJobs
│   ├-- Webhooks - n8n
│   ├-- Event Processing - NATS *
│   └-- Internal APIs - FastAPI
│
└── Developer Platform
    ├── Documentation - MkDocs *
    ├── Runbooks - Git Repository
    ├── Templates - GitHub Templates
    ├── Development Environments - Dev Containers
    └── Service Catalog - Backstage (Future)

Data

AI

Applications