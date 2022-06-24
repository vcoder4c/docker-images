#!/usr/local/bin/dumb-init /bin/bash
set -e

cp "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
echo $TIMEZONE > /etc/timezone

if [ $1 = "cron" ]; then
  crontab -l | { cat; echo "$CRON_PATTERN backup.sh"; } |  crontab -
  crond -f
elif [ $1 = "backup" ]; then
  backup.sh
elif [ $1 = "restore" ]; then
  restore.sh
else
  exec "$@"
fi
