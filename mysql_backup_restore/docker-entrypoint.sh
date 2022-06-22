#!/usr/local/bin/dumb-init /bin/bash
set -e

if [ $1 = "backup" ]; then
  cp "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
  echo $TIMEZONE > /etc/timezone
  crontab -l | { cat; echo "$CRON_PATTERN sh /root/backup.sh"; } |  crontab -
  crond -f
elif [ $1 = "restore" ]; then
  sh /root/restore.sh
else
  echo "Only support backup and restore command"
  exit 1
fi
