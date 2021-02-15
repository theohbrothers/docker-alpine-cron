# docker-alpine-cron

[![github-actions](https://github.com/theohbrothers/docker-alpine-cron/workflows/ci-master-pr/badge.svg)](https://github.com/theohbrothers/docker-alpine-cron/actions)
[![github-tag](https://img.shields.io/github/tag/theohbrothers/docker-alpine-cron)](https://github.com/theohbrothers/docker-alpine-cron/releases/)
[![docker-image-size](https://img.shields.io/microbadger/image-size/theohbrothers/docker-alpine-cron/latest)](https://hub.docker.com/r/theohbrothers/docker-alpine-cron)
[![docker-image-layers](https://img.shields.io/microbadger/layers/theohbrothers/docker-alpine-cron/latest)](https://hub.docker.com/r/theohbrothers/docker-alpine-cron)

Dockerized alpine with busybox crond and useful tools.

Packages included for all images: `curl`, `wget`

| Tags |
|:-------:|
| `:3.12`, `:latest` |
| `:3.12-mysqlclient` |
| `:3.12-openssl` |
| `:3.12-mysqlclient-openssl` |
| `:3.11`, `:latest` |
| `:3.11-mysqlclient` |
| `:3.11-openssl` |
| `:3.11-mysqlclient-openssl` |
| `:3.10`, `:latest` |
| `:3.10-mysqlclient` |
| `:3.10-openssl` |
| `:3.10-mysqlclient-openssl` |
| `:3.9`, `:latest` |
| `:3.9-mysqlclient` |
| `:3.9-openssl` |
| `:3.9-mysqlclient-openssl` |
| `:3.8`, `:latest` |
| `:3.8-mysqlclient` |
| `:3.8-openssl` |
| `:3.8-mysqlclient-openssl` |


## Steps

1. Declare the contents of the crontab in `CRON` environment variable. Alternatively, mount crontab on `/var/spool/cron/crontabs/<user>`.
2. If the crons refer to any scripts, you may mount a folder containing those scripts on `/cronscripts` or whereever you want
3. Run the container. If no errors are shown, your cron should be ready.

## Example

Create a crontab with 2 crons

```sh
#!/bin/sh
docker run -d \
    -e CRON='* * * * * /bin/echo "hello"\n* * * * * /bin/echo "world"'
    -v /path/to/cronscripts/:/cronscripts/ \
    theohbrothers/docker-alpine-cron:bare
```

## Environment variables

| Name | Default value | Description
|:-------:|:---------------:|:---------:|
| `CRON_USER` | `root` | Sets the user that the crontab will run under (E.g. for user `nobody`, the crontab should be mounted at `/var/spool/cron/crontabs/nobody`.). In most cases, you should just use `root`
| `CRON` | `''` | Optional. If value is non-empty, it will be set as the content of the crontab at `/var/spool/cron/crontabs/$CRON_USER`

## Notes

- By default, a `/etc/environment` file is created at the beginning of the entrypoint script, which makes environment variables available to everyone, including crond.
- The crontab at `/var/spool/cron/crontabs/<$CRON_USER>` is set to user-write-only permissions: `600`, and owned by `$CRON_USER`
- The mountpoint /cronscripts/ is recursively set to have executable permissions at entrypoint: `u+x`

## Docker Secrets

- Since a `/etc/environment` file is created automatically to make environment variables available to every cron, any sensitive environment variables will get written to the disk. To avoid that, you may try adding [two shell functions like this](https://gitlab.com/theohbrothers/hlstatsxce-perl/blob/master/variants/alpine/cron/docker-entrypoint.sh) to the begining of each of your cron-called scripts to automatically populate env var(s) with secrets. Then, pass in environment variables to the Docker container using the syntax `MY_ENV_VAR=DOCKER-SECRET:your_docket_secret_name`, along with the secret `your_docket_secret_name` -- the result is that when the cron is run, the env var `MY_ENV_VAR` gets populated with the value of the secret. (Mine is a slightly modified version for a cleaner syntax; props to the [original author](https://gist.github.com/bvis/b78c1e0841cfd2437f03e20c1ee059fe#file-env_secrets_expand-sh)).

## FAQ

### My cron is not running!

- Ensure your mounted crontab's filename matches the `$CRON_USER` environment variable.
- Ensure your crontab has a newline at the end of the file.
- Use `docker logs` to check whether `crond` has spit out any messages about the syntax of your cron
