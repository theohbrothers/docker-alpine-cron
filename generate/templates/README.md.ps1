@"
# docker-alpine-cron

[![github-actions](https://github.com/theohbrothers/docker-alpine-cron/actions/workflows/ci-master-pr.yml/badge.svg?branch=master)](https://github.com/theohbrothers/docker-alpine-cron/actions/workflows/ci-master-pr.yml)
[![github-release](https://img.shields.io/github/v/release/theohbrothers/docker-alpine-cron?style=flat-square)](https://github.com/theohbrothers/docker-alpine-cron/releases/)
[![docker-image-size](https://img.shields.io/docker/image-size/theohbrothers/docker-alpine-cron/latest)](https://hub.docker.com/r/theohbrothers/docker-alpine-cron)

Dockerized alpine with busybox crond and useful tools.

Packages included for all images: ``curl``, ``wget``

## Tags

| Tag | Dockerfile Build Context |
|:-------:|:---------:|
$(
($VARIANTS | % {
    if ( $_['tag_as_latest'] ) {
@"
| ``:$( $_['tag'] )``, ``:latest`` | [View](variants/$( $_['tag'] )) |

"@
    }else {
@"
| ``:$( $_['tag'] )`` | [View](variants/$( $_['tag'] )) |

"@
    }
}) -join ''
)

"@

@"
## Usage

Example 1: Create one cron that runs as ``root``

``````sh
docker run -it \
    -e CRON='* * * * * /bin/echo "hello"' \
    theohbrothers/docker-alpine-cron:$( $VARIANTS | ? { $_['tag_as_latest'] } | Select -First 1 | % { $_['tag'] } )
``````

Example 2: Create two crons that run as ``root``

``````sh
docker run -it \
    -e CRON='* * * * * /bin/echo "hello"\n* * * * * /bin/echo "world"' \
    theohbrothers/docker-alpine-cron:$( $VARIANTS | ? { $_['tag_as_latest'] } | Select -First 1 | % { $_['tag'] } )
``````

Example 3: Create two crons that run as UID ``3000`` and GID ``4000``

``````sh
docker run -it \
    -e CRON='* * * * * /bin/echo "hello"\n* * * * * /bin/echo "world"' \
    -e CRON_UID=3000 \
    -e CRON_GID=4000 \
    theohbrothers/docker-alpine-cron:$( $VARIANTS | ? { $_['tag_as_latest'] } | Select -First 1 | % { $_['tag'] } )
``````


"@

@'
### Environment variables

| Name | Default value | Description
|:-------:|:---------------:|:---------:|
| `CRON` | '' | Required: The cron expression. For multiple cron expressions, use `\n`. Use [crontab.guru](https://crontab.guru/) to customize crons. This will be set as the content of the crontab at `/etc/crontabs/$CRON_USER`
| `CRON_UID` | `0` | Optional: The UID of the user that the cron should run under. Default is `0` which is `root`
| `CRON_GID` | `0` | Optional: The GID of the user that the cron should run under. Default is `0` which is `root`

### Entrypoint: `docker-entrypoint.sh`

1. A `/etc/environment` file is created at the beginning of the entrypoint script, which makes environment variables available to everyone, including crond.
1. A user of `CRON_UID` is created if it does not exist.
1. A group of `CRON_GID` is created if it does not exist.
1. The user of `CRON_UID` is added to the group of `CRON_GID` if membership does not exist.
1. Crontab is created in `/etc/crontabs/<CRON_USER>`

### Secrets

Since a `/etc/environment` file is created automatically to make environment variables available to every cron, any sensitive environment variables will get written to the disk. To avoid that:

1. Add [shell functions like this](https://github.com/startersclan/docker-hlstatsxce-daemon/blob/v1.6.19/variants/alpine/cron/docker-entrypoint.sh#L7-L58) at the beginning of your cron-called script
1. Optional: Specify the secrets folder by using environment variable `ENV_SECRETS_DIR`. By default, its value is `/run/secrets`
1. Declare environment variables using syntax `MY_ENV_VAR=DOCKER-SECRET:my_docker_secret_name`, where `my_docker_secret_name` is the secret mounted on `$ENV_SECRETS_DIR/my_docker_secret_name`
1. When the cron script is run, the env var `MY_ENV_VAR` gets populated with the contents of the secret file `$ENV_SECRETS_DIR/my_docker_secret_name`

## FAQ

### Q: Why use a cron container?

This image is only needed if there is no container orchestrator (E.g. Docker in standalone mode), or if there is a container orchestrator but without a cron scheduler (E.g. Docker in Swarm mode).

If your orchestrator already provides an external scheduler (E.g. Kubernetes via `CronJob`), there's no need to use this image.

### Q: Why use `CRON` environment variable? Just use `crontab -`

Right. If the cron command is complex, and there is no need for customizing `CRON_UID` and `CRON_GID`, it is better to skip this image altogether and simply write everything in the entrypoint of the container manifest. For example, in Compose:

```yaml
version: '2.2'
services:
  some-cron:
    image: alpine
    tty: true
    entrypoint:
      - /bin/sh
    command:
      - -c
      - |
          set -eu

          crontab - <<'EOF'
          * * * * * /bin/echo "My super 'complex' cron command with quotes is better written in shell"
          EOF

          exec crond -f
```

### Q: My cron is not running!

- Use `docker logs` to check whether `crond` has spit out any messages about the syntax of your cron
- If bind-mouting your own crontab in `/etc/crontabs`, ensure:
  - the crontab is owned by `root:root` with `0600` permissions. See [here](https://unix.stackexchange.com/questions/642827/how-to-run-a-cronjob-as-a-non-root-user-in-a-docker-container-for-alpine-linux)
  - the crontab has a newline at the end of the file

## Development

Requires Windows `powershell` or [`pwsh`](https://github.com/PowerShell/PowerShell).

```powershell
# Install Generate-DockerImageVariants module: https://github.com/theohbrothers/Generate-DockerImageVariants
Install-Module -Name Generate-DockerImageVariants -Repository PSGallery -Scope CurrentUser -Force -Verbose

# Edit ./generate templates

# Generate the variants
Generate-DockerImageVariants .
```
'@
