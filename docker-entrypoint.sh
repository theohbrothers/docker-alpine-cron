#!/bin/sh

# This gives everyone, including crond, access to environment variables you can use in crons, or cron-called s$
env > /etc/environment

# Default to root as the cron user
[ -z "$CRON_USER" ] && CRON_USER=root
echo "$( date )[ENTRYPOINT]: Will use user $CRON_USER for crons."

# Check if the cron user exists
if [ ! id test ]; then
    echo "user exists on the system!"
else
    echo "$( date )[ENTRYPOINT]: User '$CRON_USER' specified by \$CRON_USER environment variable does not exist on the system!"
    exit 1
fi

# Ensure our crontab doesn't have write permissions
# NOTE: On alpine, /var/spool/cron/crontabs/ points to /etc/crontabs/
CRONTAB="/var/spool/cron/crontabs/$CRON_USER"
echo "$( date )[ENTRYPOINT]: Setting permissions on crontab: $CRONTAB"
if [ -f "$CRONTAB" ]; then
    chmod 440 "$CRONTAB"
else
    echo "$( date )[ENTRYPOINT]: No such crontab: $CRONTAB"
fi

# Any mounted scripts should have execute permissions
CRONSCRIPTS_DIR=/cronscripts
echo "$( date )[ENTRYPOINT]: Setting permissions on cron scripts directory: $CRONSCRIPTS_DIR"
if [ -d "$CRONSCRIPTS_DIR" ]; then
    chown "$CRON_USER:$CRON_USER" "$CRONSCRIPTS_DIR"
    chmod -R 750 "$CRONSCRIPTS_DIR"
fi

exec "$@"
