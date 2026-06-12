# Ansible Learning And Implementation Guide

This guide is for learning Ansible in the context of this lab and for turning
the current `Infra/Ansible` scaffold into a working automation layer for the
Terraform-managed VMs.

It is written for the environment currently managed by Terraform:

- `ansible-01` at `192.168.0.210`
- `network-01` at `192.168.0.211`
- `core-infra-01` at `192.168.0.212`
- `data-01` at `192.168.0.213`
- `k8s-control-01` at `192.168.0.214`
- `k8s-worker-01` at `192.168.0.215`
- `k8s-worker-02` at `192.168.0.216`

The goal is not just to run Ansible commands. The goal is to build a repeatable
workflow where:

- Terraform creates hosts
- SSH keys provide access
- Ansible bootstraps and configures those hosts
- roles stay reusable
- playbooks stay readable
- reruns are safe and idempotent

## 1. What Ansible Should Do In This Lab

Use Terraform for provisioning and Ansible for configuration.

Terraform should own:

- VM creation
- CPU, memory, disk, network, and IPs
- clone source and boot behavior
- first-boot user and SSH key injection

Ansible should own:

- package installation
- OS hardening and baseline config
- SSH policy and user setup after first boot
- qemu guest agent, time sync, and utilities
- Kubernetes node preparation
- application and service configuration

Keep that boundary clear. If Terraform starts managing package state and OS
configuration, the workflow becomes harder to maintain.

## 2. Current Repo Structure

The current Ansible structure is a good starting scaffold:

```text
Infra/Ansible/
  ansible.cfg
  inventory.yml
  makefile
  inventory/
    hosts.yml
    group_vars/
      infra_host/
  playbooks/
    provision-node.yml
    site.yml
  roles/
    common/
    k3s-node/
```

Recommended responsibility for each path:

- `ansible.cfg`: local project defaults
- `inventory/hosts.yml`: source of truth for hosts and groups
- `inventory/group_vars/`: variables by group
- `playbooks/provision-node.yml`: bootstrap a new host to baseline state
- `playbooks/site.yml`: full desired-state convergence
- `roles/common/`: shared baseline for all nodes
- `roles/k3s-node/`: Kubernetes-specific setup
- `makefile`: standard commands for lint, ping, bootstrap, and site runs

## 3. Learning Path

Learn and implement in this order:

1. Inventory and connectivity
2. Ad hoc commands
3. Variables and grouping
4. Simple playbooks
5. Roles
6. Idempotence
7. Tags and selective runs
8. Safe day-2 operations

If you skip the first three, the rest becomes noisy and fragile.

## 4. Prerequisites

Before writing serious playbooks, make sure these are true:

- every VM is reachable over SSH
- the SSH user exists on every VM
- your public key is present on every VM
- Python 3 is installed on every target host
- package manager access works on every host
- hostnames are correct and stable

Check from your control machine:

```bash
ssh dev@192.168.0.210
ssh dev@192.168.0.214
python3 --version
```

If Python is missing on a host, Ansible modules will fail until you bootstrap
it with raw shell commands.

## 5. Recommended Inventory Design

Start with a YAML inventory in `inventory/hosts.yml`.

Example structure for this lab:

```yaml
all:
  vars:
    ansible_user: dev
    ansible_python_interpreter: /usr/bin/python3

  children:
    infra_host:
      hosts:
        ansible-01:
          ansible_host: 192.168.0.210
        network-01:
          ansible_host: 192.168.0.211
        core-infra-01:
          ansible_host: 192.168.0.212
        data-01:
          ansible_host: 192.168.0.213

    k3s_control:
      hosts:
        k8s-control-01:
          ansible_host: 192.168.0.214

    k3s_workers:
      hosts:
        k8s-worker-01:
          ansible_host: 192.168.0.215
        k8s-worker-02:
          ansible_host: 192.168.0.216

    k3s_cluster:
      children:
        k3s_control:
        k3s_workers:
```

Why this grouping works:

- `infra_host` covers shared infrastructure nodes
- `k3s_control` separates control-plane logic
- `k3s_workers` separates worker logic
- `k3s_cluster` lets you target the full cluster cleanly

## 6. Recommended ansible.cfg

Keep `ansible.cfg` local to the repo so commands behave consistently.

Suggested baseline:

```ini
[defaults]
inventory = inventory/hosts.yml
roles_path = roles
host_key_checking = False
retry_files_enabled = False
stdout_callback = yaml
interpreter_python = auto_silent
forks = 10

[ssh_connection]
pipelining = True
```

Notes:

- `host_key_checking = False` is acceptable in an early homelab, but later you
  should tighten it.
- `pipelining = True` speeds up SSH-based runs.
- `stdout_callback = yaml` makes results easier to read.

## 7. Group Variables Strategy

Use group vars for shared behavior instead of repeating values in inventory.

Suggested layout:

```text
inventory/group_vars/
  all.yml
  infra_host.yml
  k3s_control.yml
  k3s_workers.yml
```

Example `inventory/group_vars/all.yml`:

```yaml
timezone: UTC
base_packages:
  - curl
  - git
  - unzip
  - qemu-guest-agent
  - python3
  - python3-apt
```

Example `inventory/group_vars/k3s_node.yml` if you later create a shared group:

```yaml
k3s_disable:
  - traefik
  - servicelb
```

Guideline:

- inventory defines who the hosts are
- group vars define how groups behave
- roles define what gets done

## 8. First Commands To Learn

These commands matter more than jumping straight into playbooks.

Connectivity check:

```bash
ansible all -m ping
```

Gather facts:

```bash
ansible all -m gather_facts
```

Run a command across all hosts:

```bash
ansible all -a "hostnamectl"
```

Target a group:

```bash
ansible k3s_cluster -a "ip a"
```

These commands teach three things quickly:

- inventory resolution
- SSH/key health
- whether Python and privilege escalation are working

## 9. Bootstrap Playbook Design

Use `playbooks/provision-node.yml` for first-pass baseline tasks.

This playbook should do only safe, foundational work:

- update package cache
- install baseline packages
- enable qemu guest agent
- configure timezone
- ensure sudo access and shell defaults
- ensure SSH service is enabled

Example structure:

```yaml
---
- name: Bootstrap new nodes
  hosts: all
  become: true
  roles:
    - common
```

Keep bootstrap focused. Do not install the whole platform here.

## 10. Site Playbook Design

Use `playbooks/site.yml` as the main desired-state entrypoint.

Example structure:

```yaml
---
- name: Configure infrastructure nodes
  hosts: infra_host
  become: true
  roles:
    - common

- name: Configure Kubernetes control plane
  hosts: k3s_control
  become: true
  roles:
    - common
    - k3s-node

- name: Configure Kubernetes workers
  hosts: k3s_workers
  become: true
  roles:
    - common
    - k3s-node
```

This makes it obvious which roles apply to which hosts.

## 11. Role Design Guidance

Start small.

### common role

The `common` role should handle:

- package updates
- base packages
- qemu-guest-agent
- timezone
- motd or shell basics if you care
- baseline security settings

### k3s-node role

The `k3s-node` role should handle:

- container and kernel prerequisites
- sysctl settings
- swap handling if required
- control-plane versus worker logic via variables

Do not pack unrelated concerns into one role. If a role becomes hard to name,
it is too broad.

## 12. Idempotence Rules

Ansible is only trustworthy when reruns are safe.

Rules:

- prefer modules over shell commands
- avoid `command` and `shell` unless necessary
- use handlers for service restarts
- do not use tasks that always report changed without reason
- test a playbook twice in a row and expect the second run to show minimal or
  zero changes

Good:

```yaml
- name: Ensure qemu guest agent is installed
  ansible.builtin.apt:
    name: qemu-guest-agent
    state: present
    update_cache: true
```

Less good:

```yaml
- name: Install qemu guest agent
  ansible.builtin.shell: apt-get install -y qemu-guest-agent
```

## 13. Privilege Escalation

Most system configuration tasks need privilege escalation.

Set this at the play level when most tasks need root:

```yaml
become: true
```

Avoid setting `become: true` on every single task unless only a few tasks need
it.

## 14. Recommended Makefile Commands

Your `makefile` should standardize common operations.

Suggested contents:

```make
.PHONY: ping facts bootstrap site infra k3s

ping:
	ansible all -m ping

facts:
	ansible all -m gather_facts

bootstrap:
	ansible-playbook playbooks/provision-node.yml

site:
	ansible-playbook playbooks/site.yml

infra:
	ansible-playbook playbooks/site.yml --limit infra_host

k3s:
	ansible-playbook playbooks/site.yml --limit k3s_cluster
```

Use commands like these to reduce friction and keep your workflow consistent.

## 15. Suggested Implementation Order In This Repo

Implement in this order:

1. Fill `ansible.cfg`
2. Fill `inventory/hosts.yml`
3. Add `inventory/group_vars/all.yml`
4. Build the `common` role first
5. Make `playbooks/provision-node.yml` call `common`
6. Verify `ansible all -m ping`
7. Verify `make bootstrap`
8. Build `k3s-node` role
9. Build `playbooks/site.yml`
10. Add tags and limits for partial runs

This order keeps feedback loops short.

## 16. First Tasks For The common Role

Good initial tasks for `roles/common/tasks/main.yml`:

- install base packages
- install and enable qemu guest agent
- install and enable chrony or systemd-timesyncd
- ensure sudo is present
- ensure SSH service is enabled
- set timezone
- optionally configure unattended upgrades later

Example task list:

```yaml
---
- name: Update apt cache
  ansible.builtin.apt:
    update_cache: true
    cache_valid_time: 3600

- name: Install base packages
  ansible.builtin.apt:
    name: "{{ base_packages }}"
    state: present

- name: Enable qemu guest agent
  ansible.builtin.service:
    name: qemu-guest-agent
    enabled: true
    state: started

- name: Ensure ssh is enabled
  ansible.builtin.service:
    name: ssh
    enabled: true
    state: started
```

## 17. Testing Strategy

Test in layers.

### Layer 1: access

```bash
ansible all -m ping
```

### Layer 2: facts

```bash
ansible all -m gather_facts
```

### Layer 3: bootstrap

```bash
ansible-playbook playbooks/provision-node.yml --check
ansible-playbook playbooks/provision-node.yml
```

### Layer 4: full convergence

```bash
ansible-playbook playbooks/site.yml --check
ansible-playbook playbooks/site.yml
```

### Layer 5: rerun for idempotence

```bash
ansible-playbook playbooks/site.yml
```

If the second full run still shows a lot of changes, fix the role behavior.

## 18. Checklist

Use this as the implementation checklist.

### Foundation

- [ ] SSH key auth works to every VM
- [ ] Python 3 exists on every VM
- [ ] `ansible all -m ping` succeeds
- [ ] `ansible all -m gather_facts` succeeds

### Repo setup

- [ ] `ansible.cfg` points to the project inventory
- [ ] `inventory/hosts.yml` contains all current VMs
- [ ] host groups match actual platform roles
- [ ] `inventory/group_vars/all.yml` exists
- [ ] `makefile` contains standard command targets

### Roles

- [ ] `common` role installs baseline packages
- [ ] `common` role enables qemu guest agent
- [ ] `common` role ensures SSH service is enabled
- [ ] `common` role is idempotent
- [ ] `k3s-node` role separates control-plane and worker behavior cleanly

### Playbooks

- [ ] `playbooks/provision-node.yml` bootstraps new hosts safely
- [ ] `playbooks/site.yml` applies full desired state
- [ ] playbooks use `become: true` where appropriate
- [ ] playbooks can be limited by host group

### Quality

- [ ] a second run of `site.yml` shows minimal changes
- [ ] variables are not duplicated across inventory and roles
- [ ] shell commands are minimized in favor of modules
- [ ] handlers are used for service restarts

### Operations

- [ ] you can bootstrap a newly created VM with one command
- [ ] you can converge the whole lab with one command
- [ ] you can target only infra nodes with one command
- [ ] you can target only k3s nodes with one command

## 19. Anti-Patterns To Avoid

Avoid these early:

- putting all logic in one giant playbook
- hardcoding repeated values in multiple files
- using shell for everything
- mixing Terraform provisioning logic into Ansible roles
- skipping rerun tests
- targeting hosts by raw IP instead of inventory names everywhere

## 20. Definition Of Done For Ansible In This Lab

Ansible is in a good state when all of these are true:

- Terraform creates the VM
- the VM becomes reachable via SSH key
- `make bootstrap` gets a host to baseline state
- `make site` converges the lab safely
- rerunning playbooks is safe
- host grouping maps cleanly to your architecture
- adding a new node means editing inventory and rerunning playbooks, not
  reinventing setup steps

## 21. Recommended Next Step

Do not build everything at once. The right immediate next step is:

1. populate `ansible.cfg`
2. populate `inventory/hosts.yml`
3. make `ansible all -m ping` work
4. build the `common` role

That is the first complete vertical slice. After that, expand into Kubernetes
automation.