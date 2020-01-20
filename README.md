OSX
---

1. install brew
2. install ansible latest/2.7+ with brew
3. load your SSH keys into the ssh-agent (with ssh-add)
4. ready*
5. note: when building a production environment, append -e active=yes to ansible
6. not so fast*, you need to feed your certbot/ssh/tarsnap keys to make it work!
7. see the README in files/, and your SSH (public) keys must go to public-keys/
8. and you need to update your DNS records, see https://wiki.debian.org/opendkim
9. while OSX is not actually required, it could make your life more beautiful 🤓

---


Running It
---

### deploying all web apps on the target or group of servers called "minus"
---
```bash
ansible-playbook deploy.yml -i inventory.yml -e target=minus -e active=yes
```

### deploying *only* certain web apps on the target which match the filter
---
```bash
ansible-playbook deploy.yml -i inventory.yml -e target=minus -e filter=tacsi -e active=yes
```

### deploying *only* certain web apps on the target and *force* recreating their SSL certificates
---
```bash
ansible-playbook deploy.yml -i inventory.yml -e target=minus -e filter=tacsi -e active=yes -e certforce=yes
```

### deploying *only* the rails web apps on the target
---
```bash
ansible-playbook rails.yml -i inventory.yml -e target=minus -e active=yes
```

### deploying *only* the rails web apps on the target, without restoring backups
---
```bash
ansible-playbook rails.yml -i inventory.yml -e target=minus -e backup=no -e active=yes
```

### deploying *only* the middleman sites on the target
---
```bash
ansible-playbook middleman.yml -i inventory.yml -e target=minus
```

### deploying *only* the static/plain/html sites on the target
---
```bash
ansible-playbook static.yml -i inventory.yml -e target=minus
```

### creating/updating *only* the SSL certs & nginx site configs for all web apps
---
```bash
ansible-playbook certs.yml -i inventory.yml -e target=minus
```

### deploying all web apps on the target w/o installing SSL certs
---
```bash
ansible-playbook deploy.yml -i inventory.yml -e target=minus -e usessl=no
```

### deploying *only* nginx sites configs on the target w/o installing SSL certs
---
```bash
ansible-playbook domains.yml -i inventory.yml -e target=minus -e usessl=no
```
