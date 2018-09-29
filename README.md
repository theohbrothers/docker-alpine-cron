# alpine-cron

Packages included: `curl`, `wget`

## Steps
1. Mount crontab on `/var/spool/cron/crontabs/<user>`
2. If the crons refer to any scripts, also mount the folder containing those scripts on /cronscripts

## Example

```
docker run -d \
    -v /path/to/root:/var/spool/cron/crontabs/root \
    -v /path/to/cronscripts/:/cronscripts/ \
    wonderous/alpine-con
```

## Environment variables

| Name | Default value | Description
|:-------:|:---------------:|:---------:|
| `CRON_USER` | `root` | Sets the user that the crontab will run under (E.g. for user `nobody`, the crontab should be mounted at `/var/spool/cron/crontabs/nobody`.). In most cases, you should just use `root`


## Notes
- By default, a `/etc/environment` file is created at the beginning of the entrypoint script, which makes environment variables available to everyone, including crond.

## Tags
Separate builds are included with certain tools:
 - `:openssl`
 - `:mysql-client`:
 - `:openssl-mysql-client`: