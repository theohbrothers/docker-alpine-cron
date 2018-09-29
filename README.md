# alpine-cron

Packages included: `curl`, `wget`

## Steps
1. Mount crontab on `/var/spool/cron/crontabs/<user>`
2. If the crons refer to any scripts, also mount the folder containing those scripts on /cronscripts

## Example

```
docker run wonderous/alpine-con -d -v /path/to/root:/var/spool/cron/crontabs/root -v /path/to/cronscripts/:/cronscripts/
```

## Environment variables
- CRON_USER. If unset, this will be `root`.

## Notes
- By default, a `/etc/environment` file is created at the beginning of the entrypoint script, which makes environment variables available to everyone, including crond.

## Tags
Separate builds are included with certain tools:
 - `:openssl`
 - `:mysql-client`:
 - `:openssl-mysql-client`: