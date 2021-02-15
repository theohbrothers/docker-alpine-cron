@"
FROM $( $VARIANT['_metadata']['distro'] ):$( $VARIANT['_metadata']['distro_version'] )

RUN apk add --no-cache curl wget
"@
