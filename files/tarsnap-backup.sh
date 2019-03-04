#!/bin/bash

mkdir -p "{{ backup_root }}/backup/cache"
mkdir -p "{{ backup_root }}/backup/{{ appshome }}"
# lets secure a bit this backup/dir structure
chmod 700 "{{ backup_root }}/backup"

DBALL=$(find /var/lib/mysql -maxdepth 1 -type d | xargs -n 1 basename | grep -vE '^(sys|mysql|performance_schema)$')

DUMP="{{ backup_root }}/backup/mysqldump"
FULL="{{ backup_root }}/backup/mysqldb/full"
# you might want to logrotate this someday
LOG=/var/log/tarsnap-backup.log

echo -n "cleaning up the old mysqldb (full) backup directory "
# yes, hopefully FULL path is correctly set, and won't be / :D
rm -rf "$FULL" && echo OK
echo
echo -n "dumping structure for databases: "
mkdir -p "$FULL"
for db in $DBALL; do
  mysqldump $db -d > "$FULL/struct.$db.sql" && echo -n $db,
done
echo
echo
echo -n "dumping all data for databases: "
mkdir -p "$DUMP"
for db in $DBALL; do
  mysqldump $db > "$DUMP/full.$db.sql" && echo -n $db,
done
echo
echo "*** using xtrabackup now *** restore is not done/documented yet ***"
echo -n "running (full) mysqldb backup live "
xtrabackup --backup --target-dir="$FULL" &>> "$LOG" && echo OK
echo
echo -n "preparing the mysqldb backup before archival "
xtrabackup --prepare --export --target-dir="$FULL" &>> "$LOG" && echo OK
echo
echo
echo -n "dumping all rails apps uploads to backup directory "
tar cf - "{{ appshome }}/*/shared/public/uploads/" | \
  tar xvf - -C "{{ backup_root }}/backup/" &>> "$LOG" && echo OK
echo
echo
echo -n "dumping all SSL certificates to backup directory "
tar cf - "{{ certroot }}" | \
  tar xvf - -C "{{ backup_root }}/backup/" &>> "$LOG" && echo OK
echo
echo running tarsnap/backup now
/usr/bin/tarsnap --print-stats --cachedir "{{ backup_root }}/backup/cache" \
  -c -f "$(uname -n)-$(date +%Y-%m-%d_%H-%M-%S)" \
  "{{ backup_root }}/backup" | tee -a "$LOG"
