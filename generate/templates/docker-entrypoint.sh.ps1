@'
#!/bin/sh
set -eu

# This makes environment variables available to everyone, including crond and its crons
env > /etc/environment

output() {
    echo -e "[$( date -u '+%Y-%m-%dT%H:%M:%S%z' )] $1"
}

error() {
    echo -e "[$( date -u '+%Y-%m-%dT%H:%M:%S%z' )] $1" >&2
}

# Default to root as the cron user
CRON_USER=${CRON_USER:-root}
CRON=${CRON:-}
output "Will use user $CRON_USER for crons."

# Check if the cron user exists
id "$CRON_USER" >/dev/null 2>&1
if [ ! $? = 0 ]; then
    error "User '$CRON_USER' specified by \$CRON_USER environment variable does not exist on the system!"
    exit 1
fi

# NOTE: On alpine, /var/spool/cron/crontabs/ points to /etc/crontabs/
CRONTAB="/var/spool/cron/crontabs/$CRON_USER"

# Create our crontab from the env var if present
if [ -n "$CRON" ]; then
    output "Creating crontab $CRONTAB"
    echo -e "$CRON" > "$CRONTAB"
    output "Setting owner and permissions on crontab: $CRONTAB"
    chown "$CRON_USER:$CRON_USER" "$CRONTAB"
    chmod 600 "$CRONTAB"
else
    echo "Not creating crontab because CRON environment variable is empty"
fi

exec "$@"
'@
