# Changelog

All notable changes to this role will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-15

### Added
- Initial release of Authentik deployment role
- Docker Compose deployment with PostgreSQL, Server, and Worker
- Full API-driven configuration via Authentik REST API v3
- Identity management (users, groups, roles, tokens)
- Authentication flow configuration
- 20+ stage types support (identification, password, MFA, etc.)
- Policy configuration (password, expression, GeoIP, reputation)
- Flow and stage bindings
- Brand customization (logos, CSS, themes)
- Email template customization
- Invitation/enrollment support
- Health checks and readiness validation
- Custom CSS with dark theme and glassmorphism effects
- French email templates included
- Complete role documentation (README.md)
- Ansible Galaxy metadata (meta/main.yml)

### Security
- PostgreSQL isolated on internal network
- Password validation with regex patterns
- API token authentication for configuration
- Resource limits on all containers
- No new privileges flag enabled

---

## Change Types

- `Added` for new features
- `Changed` for changes in existing functionality
- `Deprecated` for soon-to-be removed features
- `Removed` for now removed features
- `Fixed` for any bug fixes
- `Security` for vulnerability fixes
