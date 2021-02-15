# docker-alpine-cron

[![github-actions](https://github.com/theohbrothers/docker-alpine-cron/workflows/ci-master-pr/badge.svg)](https://github.com/theohbrothers/docker-alpine-cron/actions)
[![github-tag](https://img.shields.io/github/tag/theohbrothers/docker-alpine-cron)](https://github.com/theohbrothers/docker-alpine-cron/releases/)
[![docker-image-size](https://img.shields.io/microbadger/image-size/theohbrothers/docker-alpine-cron/latest)](https://hub.docker.com/r/theohbrothers/docker-alpine-cron)
[![docker-image-layers](https://img.shields.io/microbadger/layers/theohbrothers/docker-alpine-cron/latest)](https://hub.docker.com/r/theohbrothers/docker-alpine-cron)

Dockerized alpine with busybox crond and useful tools.

Packages included for all images: `curl`, `wget`

| Tag | Dockerfile Build Context |
|:-------:|:---------:|
| `:3.12`, `:latest` | [View](variants/3.12 ) |
| `:3.12-mysqlclient` | [View](variants/3.12-mysqlclient ) |
| `:3.12-openssl` | [View](variants/3.12-openssl ) |
| `:3.12-mysqlclient-openssl` | [View](variants/3.12-mysqlclient-openssl ) |
| `:3.11`, `:latest` | [View](variants/3.11 ) |
| `:3.11-mysqlclient` | [View](variants/3.11-mysqlclient ) |
| `:3.11-openssl` | [View](variants/3.11-openssl ) |
| `:3.11-mysqlclient-openssl` | [View](variants/3.11-mysqlclient-openssl ) |
| `:3.10`, `:latest` | [View](variants/3.10 ) |
| `:3.10-mysqlclient` | [View](variants/3.10-mysqlclient ) |
| `:3.10-openssl` | [View](variants/3.10-openssl ) |
| `:3.10-mysqlclient-openssl` | [View](variants/3.10-mysqlclient-openssl ) |
| `:3.9`, `:latest` | [View](variants/3.9 ) |
| `:3.9-mysqlclient` | [View](variants/3.9-mysqlclient ) |
| `:3.9-openssl` | [View](variants/3.9-openssl ) |
| `:3.9-mysqlclient-openssl` | [View](variants/3.9-mysqlclient-openssl ) |
| `:3.8`, `:latest` | [View](variants/3.8 ) |
| `:3.8-mysqlclient` | [View](variants/3.8-mysqlclient ) |
| `:3.8-openssl` | [View](variants/3.8-openssl ) |
| `:3.8-mysqlclient-openssl` | [View](variants/3.8-mysqlclient-openssl ) |

## Example

Create a crontab with 2 crons

```sh
#!/bin/sh
docker run -d \
    -e CRON='* * * * * /bin/echo "hello"\n* * * * * /bin/echo "world"'
    -v /path/to/cronscripts/:/cronscripts/ \
    theohbrothers/docker-alpine-cron:3.12
```

## Usage

1. Declare the contents of the crontab in `CRON` environment variable. Alternatively, mount crontab on `/var/spool/cron/crontabs/<user>`.
2. If the crons refer to any scripts, you may mount a folder containing those scripts on `/cronscripts` or whereever you want
3. Run the container. If no errors are shown, your cron should be ready.

## Environment variables

| Name | Default value | Description
|:-------:|:---------------:|:---------:|
| `CRON_USER` | `root` | Sets the user that the crontab will run under (E.g. for user `nobody`, the crontab should be mounted at `/var/spool/cron/crontabs/nobody`.). In most cases, you should just use `root`
| `CRON` | `''` | Optional. If value is non-empty, it will be set as the content of the crontab at `/var/spool/cron/crontabs/$CRON_USER`

## Entrypoint: `docker-entrypoint.sh`

- A `/etc/environment` file is created at the beginning of the entrypoint script, which makes environment variables available to everyone, including crond.
- The crontab at `/var/spool/cron/crontabs/<$CRON_USER>` is set to user-write-only permissions: `600`, and owned by `$CRON_USER`
- The mountpoint /cronscripts/ is recursively set to have executable permissions at entrypoint: `u+x`

## Secrets

Since a `/etc/environment` file is created automatically to make environment variables available to every cron, any sensitive environment variables will get written to the disk. To avoid that:

- Add [shell functions like this](https://github.com/startersclan/docker-hlstatsxce-daemon/blob/v1.6.19/variants/alpine/cron/docker-entrypoint.sh#L7-L58) at the beginning of your cron-called script
- Optional: Specify the secrets folder by using environment variable `ENV_SECRETS_DIR`. By default, its value is `/run/secrets`
- Declare environment variables using syntax `MY_ENV_VAR=DOCKER-SECRET:my_docker_secret_name`, where `my_docker_secret_name` is the secret mounted on `$ENV_SECRETS_DIR/my_docker_secret_name`
- When the cron script is run, the env var `MY_ENV_VAR` gets populated with the contents of the secret file `$ENV_SECRETS_DIR/my_docker_secret_name`

## FAQ

### Q: My cron is not running!

- Ensure your mounted crontab's filename matches the `$CRON_USER` environment variable.
- Ensure your crontab has a newline at the end of the file.
- Use `docker logs` to check whether `crond` has spit out any messages about the syntax of your cron
