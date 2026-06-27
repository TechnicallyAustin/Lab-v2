ansible-role-vaultwarden-docker
=========

Ansible docker vaultwarden role

<img src="https://github.com/foi/ansible-role-vaultwarden-docker/actions/workflows/ci.yml/badge.svg?branch=main">


Compatibility
--------------

python: 3.12, 3.13, 3.14
ansible: 12, 13

Install
--------------

`ansible-galaxy role install foi.vaultwarden_docker`

or add it in `requirements.yml`

```
roles:
  - name: foi.vaultwarden_docker
```

and run `ansible-galaxy install -r requirements.yml`

Role Variables
--------------
role defaults:
```yml
vaultwarden_docker_version: '1.36.0'
vaultwarden_docker_container_name: vaultwarden
vaultwarden_docker_root_folder: "/opt/{{ vaultwarden_docker_container_name }}"
vaultwarden_docker_root_folder_owner: root
vaultwarden_docker_root_folder_group: root
vaultwarden_docker_root_folder_mode: '0750'
vaultwarden_docker_compose_service_params:
  restart: unless-stopped
vaultwarden_docker_compose_environment_params:
  DOMAIN: https://changeit.com
vaultwarden_docker_compose_out_of_service_template:
  volumes:
    vaultwarden-data: {}
vaultwarden_docker_compose_ports:
  - "8080:80"
vaultwarden_docker_compose_volumes:
  - vaultwarden-data:/data/
vaultwarden_docker_compose_template: |
  services:
    {{ vaultwarden_docker_container_name }}:
      image: vaultwarden/server:{{ vaultwarden_docker_version }}
      container_name: {{ vaultwarden_docker_container_name }}
  {% for k, v in vaultwarden_docker_compose_service_params.items() %}
      {{ k }}: {{ v }}
  {% endfor %}
      environment:
  {% for k, v in vaultwarden_docker_compose_environment_params.items() %}
        {{ k }}: {{ v }}
  {% endfor %}
      volumes:
  {% for volume in vaultwarden_docker_compose_volumes %}
        - {{ volume }}
  {% endfor %}
      ports:
  {% for port in vaultwarden_docker_compose_ports %}
        - {{ port }}
  {% endfor %}
  {% if vaultwarden_docker_compose_out_of_service_template is not none %}
  {{ vaultwarden_docker_compose_out_of_service_template | to_nice_yaml(indent=2) }}
  {% endif %}
```

Example Playbook
----------------
```yml
# inventory
[servers]
yourhost
# playbook.yml
- hosts: servers
  roles:
    - role: foi.vaultwarden_docker
  become: true
# host_vars/yourhost.yml
vaultwarden_docker_compose_environment_params:
  DOMAIN: https://yourdomain.com
```
License
-------

MIT
