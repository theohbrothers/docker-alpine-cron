@"
FROM $( $VARIANT['_metadata']['distro'] ):$( $VARIANT['_metadata']['distro_version'] )

RUN apk add --no-cache ca-certificates curl wget


"@

$VARIANT['_metadata']['components'] | % {
    $component = $_

    switch( $component ) {

        'mysqlclient' {
            @'
RUN apk add --no-cache mysql-client


'@
        }

        'openssl' {
            @'
RUN apk add --no-cache openssl


'@
        }

        default {
            throw "No such component: $component"
        }
    }
}

@"
# This is the only signal from the docker host that appears to stop crond
STOPSIGNAL SIGKILL

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["crond", "-f"]

"@
