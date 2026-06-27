# Ansible Role: Authentik

Deploy and configure [Authentik](https://goauthentik.io/) identity provider via Docker Compose with full API-driven configuration.

## Description

This role provides a complete Authentik deployment and configuration solution:

- **Docker Compose deployment** with PostgreSQL, Server, and Worker containers
- **Full API configuration** for all Authentik features
- **Identity management**: users, groups, roles, tokens
- **Authentication flows**: customizable multi-step authentication
- **Policies**: password, expression, reputation, GeoIP
- **Stages**: identification, password, MFA (TOTP, WebAuthn, SMS, Email)
- **Branding**: custom logos, CSS, and themes
- **Email templates**: customizable notification emails

## Requirements

### Supported Operating Systems

- Debian 11 (Bullseye), 12 (Bookworm), 13 (Trixie)
- Ubuntu 22.04 (Jammy), 24.04 (Noble)

### Prerequisites

- Docker Engine installed and running
- Docker Compose v2 (CLI plugin)
- External proxy network (e.g., `proxy-network`)
- Ansible collection `community.docker` >= 3.0.0

```bash
ansible-galaxy collection install community.docker
```

## Role Variables

### Required Variables

| Variable | Description |
|----------|-------------|
| `authentik_subdomain` | Subdomain for Authentik (must match domain regex) |
| `authentik_base_domain` | Base domain name |
| `authentik_secret_key` | Secret key (50+ alphanumeric characters) |
| `authentik_postgres_user` | PostgreSQL username |
| `authentik_postgres_password` | PostgreSQL password (8-99 chars, no `/ @ "`) |
| `authentik_api_token` | API token for configuration tasks |

### Container Settings - Server

| Variable | Default | Description |
|----------|---------|-------------|
| `authentik_server_image` | `ghcr.io/goauthentik/server:2025.12.3` | Server Docker image |
| `authentik_server_container_name` | `authentik-server` | Container name |
| `authentik_server_memory_limit` | `1g` | Memory limit |
| `authentik_server_cpu_limit` | `1` | CPU limit |
| `authentik_server_restart_policy` | `unless-stopped` | Restart policy |

### Container Settings - Worker

| Variable | Default | Description |
|----------|---------|-------------|
| `authentik_worker_image` | Same as server | Worker Docker image |
| `authentik_worker_container_name` | `authentik-worker` | Container name |
| `authentik_worker_memory_limit` | `512m` | Memory limit |
| `authentik_worker_cpu_limit` | `0.5` | CPU limit |
| `authentik_worker_replicas` | `1` | Number of worker replicas |

### Container Settings - PostgreSQL

| Variable | Default | Description |
|----------|---------|-------------|
| `authentik_postgres_image` | `postgres:16-alpine` | PostgreSQL Docker image |
| `authentik_postgres_container_name` | `authentik-postgres` | Container name |
| `authentik_postgres_db` | `authentik` | Database name |
| `authentik_postgres_memory_limit` | `512m` | Memory limit |
| `authentik_postgres_cpu_limit` | `0.5` | CPU limit |

### Networks

| Variable | Default | Description |
|----------|---------|-------------|
| `authentik_managed_networks` | See defaults | Networks created by the role |
| `authentik_external_networks` | `[{name: "proxy-network"}]` | External networks to connect |

### Email Configuration (Optional)

| Variable | Default | Description |
|----------|---------|-------------|
| `authentik_email_enabled` | `true` | Enable email functionality |
| `authentik_email_host` | `""` | SMTP server hostname |
| `authentik_email_port` | `""` | SMTP server port |
| `authentik_email_username` | `""` | SMTP username |
| `authentik_email_password` | `""` | SMTP password |
| `authentik_email_use_tls` | `false` | Use TLS for SMTP |
| `authentik_email_from` | `""` | From email address |

### Bootstrap Configuration (Optional)

| Variable | Default | Description |
|----------|---------|-------------|
| `authentik_bootstrap_enabled` | `false` | Enable bootstrap mode |
| `authentik_bootstrap_password` | `""` | Initial admin password |
| `authentik_bootstrap_token` | `""` | Initial API token |
| `authentik_bootstrap_email` | `""` | Initial admin email |

### API Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `authentik_api_url` | Auto-generated | Authentik API URL |
| `authentik_api_validate_certs` | `false` | Validate SSL certificates |
| `authentik_api_call_timeout` | `15` | API call timeout (seconds) |
| `authentik_api_call_retries` | `10` | API call retries |

### Ports

| Variable | Default | Description |
|----------|---------|-------------|
| `authentik_http_port` | `9000` | HTTP port |
| `authentik_https_port` | `9443` | HTTPS port |
| `authentik_metrics_port` | `9300` | Prometheus metrics port |

### Configuration Structure

The `authentik_config` dictionary contains all configurable elements:

```yaml
authentik_config:
  licences: []
  settings: {}
  identities:
    roles: []
    groups: []
    users: []
    tokens: []
  prompts: []
  policies: {}
  flows: []
  stages: {}
  flow_bindings: []
  brands: []
  invitations: []
```

Use `authentik_config_override` to merge custom configurations.

## Dependencies

### Ansible Collections

```yaml
# requirements.yml
collections:
  - name: community.docker
    version: ">=3.0.0"
  - name: community.general
```

## Example Playbook

### Basic Installation

```yaml
---
- name: Deploy Authentik
  hosts: identity_servers
  become: true
  vars:
    authentik_subdomain: "auth"
    authentik_base_domain: "example.com"
    authentik_secret_key: "{{ vault_authentik_secret_key }}"
    authentik_postgres_user: "authentik"
    authentik_postgres_password: "{{ vault_postgres_password }}"
    authentik_api_token: "{{ vault_api_token }}"
  roles:
    - role: ax-bzh.authentik
```

### With Email and Custom Flows

```yaml
---
- name: Deploy Authentik with full configuration
  hosts: identity_servers
  become: true
  vars:
    authentik_subdomain: "auth"
    authentik_base_domain: "example.com"
    authentik_secret_key: "{{ vault_authentik_secret_key }}"
    authentik_postgres_user: "authentik"
    authentik_postgres_password: "{{ vault_postgres_password }}"
    authentik_api_token: "{{ vault_api_token }}"

    # Email configuration
    authentik_email_enabled: true
    authentik_email_host: "smtp.example.com"
    authentik_email_port: 587
    authentik_email_username: "{{ vault_smtp_user }}"
    authentik_email_password: "{{ vault_smtp_password }}"
    authentik_email_use_tls: true
    authentik_email_from: "auth@example.com"

    # Custom configuration
    authentik_config_override:
      identities:
        groups:
          - name: "admins"
            is_superuser: true
          - name: "users"
  roles:
    - role: ax-bzh.authentik
```

### Using Tags

```bash
# Full deployment
ansible-playbook playbook.yml --tags authentik

# Installation only (Docker Compose)
ansible-playbook playbook.yml --tags install

# Configuration only (API calls)
ansible-playbook playbook.yml --tags configure
```

## Role Structure

```
authentik/
├── defaults/
│   └── main.yml              # Default variables
├── files/
│   ├── media/public/branding/
│   │   ├── logo.svg          # Custom logo
│   │   └── logo.ico          # Custom favicon
│   ├── templates/
│   │   ├── base.html         # Base email template
│   │   ├── base.txt          # Text email template
│   │   ├── password_reset.html
│   │   └── password_reset.txt
│   └── custom.css            # Custom CSS styling
├── handlers/
│   └── main.yml              # Handlers
├── tasks/
│   ├── main.yml              # Entry point
│   ├── install.yml           # Docker Compose deployment
│   ├── configure.yml         # API configuration
│   ├── identities.yml        # Users, groups, roles
│   ├── flows.yml             # Authentication flows
│   ├── stages/               # Stage configurations
│   ├── policies/             # Policy configurations
│   ├── bindings/             # Flow/stage bindings
│   ├── brands.yml            # Branding configuration
│   └── ...
├── templates/
│   └── docker-compose.yml.j2 # Docker Compose template
├── meta/
│   └── main.yml              # Galaxy metadata
└── README.md
```

## Handlers

| Handler | Description |
|---------|-------------|
| `Restart Authentik` | Restarts entire Docker Compose stack |
| `Restart Authentik server` | Restarts server container only |
| `Restart Authentik worker` | Restarts worker container only |
| `Update Authentik roles` | Fetches current RBAC permissions |

## Networks Created

| Network | Type | Description |
|---------|------|-------------|
| `authentik-backend` | bridge (internal) | Database communication |
| `authentik-egress` | bridge | External connectivity |

## Volumes Created

| Volume | Description |
|--------|-------------|
| `authentik-postgres` | PostgreSQL data |
| `authentik-media` | Media files (logos, etc.) |
| `authentik-templates` | Email templates |
| `authentik-certs` | SSL certificates |

## Security

- PostgreSQL on internal network only
- Password validation with regex patterns
- API token authentication
- Custom AppArmor-compatible container setup
- No new privileges flag
- Resource limits on all containers

## License

MIT

## Author

- **ax-bzh** - *Maintainer*

## Links

- [Authentik Documentation](https://goauthentik.io/docs/)
- [Authentik API Reference](https://goauthentik.io/developer-docs/api/)
- [community.docker Collection](https://docs.ansible.com/ansible/latest/collections/community/docker/)
