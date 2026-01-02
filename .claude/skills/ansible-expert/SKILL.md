---
name: ansible-expert
description: Expert in Ansible playbooks, roles, tasks, and automation. Use when working with Ansible configurations, playbooks, inventories, roles, or when the user asks about Ansible, automation, or infrastructure as code.
allowed-tools: Read, Grep, Glob, Bash
---

# Ansible Expert

An expert skill for working with Ansible playbooks, roles, tasks, and infrastructure automation.

## When to use this skill

Use this skill when:
- Writing or modifying Ansible playbooks
- Creating or updating Ansible roles
- Working with inventories and host configurations
- Debugging Ansible tasks and playbooks
- Optimizing Ansible performance
- Implementing best practices for Ansible automation

## Core concepts

### Playbook structure
```yaml
---
- name: Playbook name
  hosts: target_hosts
  become: yes
  vars:
    variable_name: value

  tasks:
    - name: Task description
      module_name:
        parameter: value
      tags: [tag1, tag2]
```

### Role structure
```
roles/
  role_name/
    tasks/
      main.yml
    handlers/
      main.yml
    templates/
      template.j2
    files/
      static_file
    vars/
      main.yml
    defaults/
      main.yml
    meta/
      main.yml
```

## Best practices

### Idempotency
Always write tasks that can be run multiple times without causing issues:
```yaml
- name: Ensure package is installed
  apt:
    name: nginx
    state: present
  # Good: uses 'present', not 'latest' for predictability
```

### Variables and defaults
- Use `defaults/` for variables users should override
- Use `vars/` for variables that shouldn't change
- Use descriptive variable names with prefixes: `nginx_port`, not just `port`

### Task naming
Always name your tasks clearly:
```yaml
- name: Install nginx web server
  apt:
    name: nginx
    state: present
```

### Handler usage
Use handlers for restart operations:
```yaml
tasks:
  - name: Update nginx config
    template:
      src: nginx.conf.j2
      dest: /etc/nginx/nginx.conf
    notify: restart nginx

handlers:
  - name: restart nginx
    service:
      name: nginx
      state: restarted
```

### Tags
Use tags for selective execution:
```yaml
- name: Install packages
  apt:
    name: "{{ item }}"
  loop: "{{ packages }}"
  tags: [install, packages]
```

### Error handling
```yaml
- name: Attempt risky operation
  command: /usr/bin/risky_command
  register: result
  failed_when: result.rc not in [0, 2]
  changed_when: result.rc == 0
  ignore_errors: yes
```

## Common modules

### Package management
```yaml
- name: Install package (Debian/Ubuntu)
  apt:
    name: package_name
    state: present
    update_cache: yes

- name: Install package (RHEL/CentOS)
  yum:
    name: package_name
    state: present
```

### File operations
```yaml
- name: Copy file
  copy:
    src: files/config.conf
    dest: /etc/app/config.conf
    owner: root
    group: root
    mode: '0644'
    backup: yes

- name: Create from template
  template:
    src: templates/config.j2
    dest: /etc/app/config.conf
```

### Service management
```yaml
- name: Ensure service is running
  service:
    name: nginx
    state: started
    enabled: yes
```

### Shell commands
```yaml
- name: Run command
  command: /usr/bin/command arg1 arg2
  args:
    creates: /path/to/file  # Skip if file exists

- name: Run shell command
  shell: |
    complex command with pipes |
    and multiple lines
  args:
    executable: /bin/bash
```

## Advanced patterns

### Loops
```yaml
- name: Install multiple packages
  apt:
    name: "{{ item }}"
  loop:
    - nginx
    - git
    - vim

- name: Loop with dict
  user:
    name: "{{ item.name }}"
    groups: "{{ item.groups }}"
  loop:
    - { name: 'alice', groups: 'admin' }
    - { name: 'bob', groups: 'users' }
```

### Conditionals
```yaml
- name: Install on Debian
  apt:
    name: nginx
  when: ansible_os_family == "Debian"

- name: Multiple conditions
  service:
    name: httpd
    state: started
  when:
    - ansible_os_family == "RedHat"
    - ansible_distribution_major_version == "7"
```

### Blocks
```yaml
- name: Handle errors with block
  block:
    - name: Risky task
      command: /usr/bin/risky
  rescue:
    - name: Handle failure
      debug:
        msg: "Task failed, running recovery"
  always:
    - name: Always runs
      debug:
        msg: "Cleanup actions"
```

### Vault for secrets
```bash
# Encrypt a file
ansible-vault encrypt secrets.yml

# Edit encrypted file
ansible-vault edit secrets.yml

# Run playbook with vault
ansible-playbook playbook.yml --ask-vault-pass
```

## Testing and debugging

### Syntax check
```bash
ansible-playbook playbook.yml --syntax-check
```

### Dry run
```bash
ansible-playbook playbook.yml --check
```

### Debug tasks
```yaml
- name: Show variable
  debug:
    var: my_variable

- name: Show message
  debug:
    msg: "Value is {{ my_variable }}"
```

### Verbose output
```bash
ansible-playbook playbook.yml -v   # verbose
ansible-playbook playbook.yml -vvv # very verbose
```

## Performance optimization

### Pipelining
```ini
# ansible.cfg
[defaults]
pipelining = True
```

### Fact caching
```ini
[defaults]
gathering = smart
fact_caching = jsonfile
fact_caching_connection = /tmp/ansible_facts
fact_caching_timeout = 86400
```

### Parallel execution
```ini
[defaults]
forks = 20
```

### Disable fact gathering when not needed
```yaml
- hosts: all
  gather_facts: no
  tasks:
    - name: Quick task
      ping:
```

## Directory layout for projects

```
ansible-project/
  ansible.cfg
  inventory/
    production/
      hosts
      group_vars/
        all.yml
        webservers.yml
      host_vars/
        server1.yml
    staging/
      hosts
  playbooks/
    site.yml
    webservers.yml
    dbservers.yml
  roles/
    common/
    nginx/
    postgresql/
  group_vars/
    all.yml
  host_vars/
  files/
  templates/
```

## Common troubleshooting

### Connection issues
- Check SSH connectivity: `ansible all -m ping`
- Verify inventory: `ansible-inventory --list`
- Check sudo/become: Ensure user has proper privileges

### Module failures
- Check module documentation: `ansible-doc module_name`
- Verify required parameters are provided
- Check for proper YAML indentation

### Variable precedence
From lowest to highest:
1. role defaults
2. inventory file/script group vars
3. playbook group_vars/all
4. playbook group_vars/*
5. playbook host_vars/*
6. host facts
7. play vars
8. task vars
9. extra vars (-e on command line)

## Security best practices

1. **Never commit secrets**: Use Ansible Vault
2. **Use become judiciously**: Only escalate when needed
3. **Validate user input**: Use `assert` module
4. **Pin versions**: Specify exact package versions in production
5. **Use SSH keys**: Avoid password authentication
6. **Audit logs**: Enable logging in ansible.cfg

## Resources

When helping with Ansible:
- Follow idempotency principles
- Suggest appropriate modules over shell commands
- Recommend proper error handling
- Consider cross-platform compatibility
- Encourage role-based organization for complex setups
- Suggest testing strategies (molecule, kitchen, etc.)
