#!/usr/local/bin/dumb-init /bin/bash
set -e
printenv

if [ $1 = "backup" ]; then
  crontab -l | { cat; echo "$CRON_PATTERN sh /root/backup.sh"; } |  crontab -
  crond -f
elif [ $1 = "restore" ]; then
  sh /root/restore.sh
else
  echo "Only support backup and restore command"
  exit 1
fi
