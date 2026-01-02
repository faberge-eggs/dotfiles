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

## macOS-Specific Best Practices (Lessons Learned)

### osx_defaults Type Mismatches

macOS defaults can have unexpected types. Always check the current type:

```bash
# Check current type and value
defaults read com.apple.dock tilesize
# Output: 48.0 (float)

# ❌ WRONG - type mismatch error
- name: Set Dock icon size
  community.general.osx_defaults:
    domain: com.apple.dock
    key: tilesize
    type: int        # ← Will fail if current value is float
    value: 48

# ✅ CORRECT - match the existing type
- name: Set Dock icon size
  community.general.osx_defaults:
    domain: com.apple.dock
    key: tilesize
    type: float
    value: 48.0
```

### Safari and App Sandboxing

Modern macOS apps (especially Safari) use sandboxed preferences that can't be modified via `defaults`:

```yaml
# ❌ WILL FAIL - Safari is sandboxed
- name: Enable Safari develop menu
  community.general.osx_defaults:
    domain: com.apple.Safari
    key: IncludeDevelopMenu
    type: bool
    value: true
# Error: Could not write domain .../com.apple.Safari

# ✅ SOLUTION - Comment out or document manual configuration
# Safari Configuration (Manual)
# These settings must be configured through Safari > Settings
# - Enable Develop menu: Safari > Settings > Advanced > Show Develop menu
```

Apps affected by sandboxing:
- Safari
- Mail
- Messages
- Photos
- Other Mac App Store apps

### Deprecation Warnings

Handle `ansible_env` deprecation warnings:

```yaml
# ⚠️ DEPRECATED (still works but shows warnings)
- name: Create directory
  file:
    path: "{{ ansible_env.HOME }}/.config"
    state: directory

# ✅ PREFERRED - use ansible_facts
- name: Create directory
  file:
    path: "{{ ansible_facts.env.HOME }}/.config"
    state: directory

# Or disable the warning in ansible.cfg
[defaults]
inject_facts_as_vars = False
```

### Non-Interactive Execution

When running playbooks from automation scripts:

```bash
# ❌ WILL HANG - waiting for password
ansible-playbook playbook.yml --ask-become-pass

# ✅ OPTIONS:
# 1. Run without become (if not needed)
ansible-playbook playbook.yml

# 2. Use NOPASSWD in sudoers
# /etc/sudoers.d/ansible:
# username ALL=(ALL) NOPASSWD: ALL

# 3. Provide password via variable (less secure)
ansible-playbook playbook.yml -e ansible_become_pass=password
```

### macOS System Integrity Protection (SIP)

Some system modifications require SIP to be disabled:

```yaml
# This may fail with SIP enabled
- name: Modify system directory
  file:
    path: /System/Library/Something
    state: directory
  # Solution: Document that SIP must be disabled or use approved methods
```

### Testing macOS Playbooks

Always test on a fresh system or VM:

```bash
# Test without making changes
ansible-playbook --check playbook.yml

# Test with verbose output
ansible-playbook -vvv playbook.yml

# Test specific tags
ansible-playbook --tags dock,finder playbook.yml
```

### Common macOS Modules

```yaml
# ✅ Preferred modules for macOS
community.general.osx_defaults     # System preferences
community.general.homebrew         # Package installation
community.general.homebrew_cask    # Application installation
community.general.mas              # Mac App Store (with limitations)

# Restart services after changes
handlers:
  - name: Restart Dock
    command: killall Dock

  - name: Restart Finder
    command: killall Finder
```

## Resources

When helping with Ansible:
- Follow idempotency principles
- Suggest appropriate modules over shell commands
- Recommend proper error handling
- Consider cross-platform compatibility
- Encourage role-based organization for complex setups
- Suggest testing strategies (molecule, kitchen, etc.)
- **For macOS**: Always verify `osx_defaults` types with `defaults read`
- **For macOS**: Document sandboxed apps that need manual configuration
- **For macOS**: Test on multiple macOS versions (Ventura, Sonoma, Sequoia)
