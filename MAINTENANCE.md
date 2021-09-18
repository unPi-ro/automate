
### tarsnap backup maintenance & cleanup
#### every few months run on all servers

```bash
bash tarsnap-rotate.sh -v
```

#### then add coins++ to www.tarsnap.com

#### in case: "Sequence number mismatch: Run --fsck"

```bash
tarsnap --fsck --cachedir /backup/cache
```
### rails apps logs

- nginx:
- - access_log **is at** {{ logroot }}/{{ app.name }}/access.log
- - error_log **is at** {{ logroot }}/{{ app.name }}/error.log
- - everything _else*_ **is still at** /var/log/nginx/
- passenger:
- - see {{ appshome }}/{{ app.name }}/shared/log/*.log

### rails apps maintenance

```bash
sudo su - deploy
cd {{ appshome }}/{{ app.name }}/current
bundle exec rails maintenance:start
# do your maintenance work here
bundle exec rails maintenance:end
```
