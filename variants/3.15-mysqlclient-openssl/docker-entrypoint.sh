#!/bin/sh
set -eu

# This makes environment variables available to everyone, including crond and its crons
env > /etc/environment

# Configuration
CRON=${CRON:-}
CRON_UID=${CRON_UID:-0} # Default is 'root' user
CRON_GID=${CRON_GID:-0} # Default is 'root' user
CRON_USER=$( (getent passwd "$CRON_UID" || echo 'cronuser') | cut -d ':' -f1 )
if [ "$CRON_UID" = "$CRON_GID" ]; then
    CRON_GROUP="$CRON_USER"
else
    CRON_GROUP=$( (getent group "$CRON_GID" || echo 'crongroup') | cut -d ':' -f1 )
fi
echo "Crons will run under user '$CRON_USER' of UID '$CRON_UID' and group '$CRON_GROUP' of GID '$CRON_GID'"

# Validation
if [ -z "$CRON" ]; then
    echo "CRON is empty."
    exit 1
fi

# Create user, group, and add membership
if ! getent passwd "$CRON_UID" ; then
    echo "Creating user '$CRON_USER' of UID '$CRON_UID'"
    adduser -D -u "$CRON_UID" "$CRON_USER"
else
    echo "No need to create user '$CRON_USER' of UID '$CRON_UID' since it already exists"
fi
if ! getent group "$CRON_GID" > /dev/null 2>&1; then
    echo "Creating group '$CRON_GROUP' of GID '$CRON_GID'"
    addgroup -g "$CRON_GID" "$CRON_GROUP"
else
    echo "No need to create group '$CRON_GROUP' of GID '$CRON_GID' since it already exists"
fi
if ! groups "$CRON_USER" 2> /dev/null | grep "\b$CRON_GROUP\b" > /dev/null; then
    echo "Adding user '$CRON_USER' to group '$CRON_GROUP'"
    adduser "$CRON_USER" "$CRON_GROUP"
else
    echo "No need to add user '$CRON_USER' to group '$CRON_GROUP' since membership exists"
fi

# Create the crontab. On alpine, /var/spool/cron/crontabs/ points to /etc/crontabs/
# For crons to run, crontab(s) must be owned by root with 0600 permissions. See: https://unix.stackexchange.com/questions/642827/how-to-run-a-cronjob-as-a-non-root-user-in-a-docker-container-for-alpine-linux
CRONTAB="/etc/crontabs/$CRON_USER"
echo "Creating crontab: $CRONTAB"
echo -e "$CRON" > "$CRONTAB"
chown "root:root" "$CRONTAB"
chmod 0600 "$CRONTAB"
ls -al "$CRONTAB"

echo "Running crond"
exec "$@"