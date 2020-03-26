@"
$(
($VARIANT['_metadata']['components'] | % {
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
}) -join ''
)
"@
