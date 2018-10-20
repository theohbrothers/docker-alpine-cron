FROM alpine:3.8

RUN apk update \
    && apk add --no-cache curl wget

RUN apk update \
    && apk add --no-cache openssl

# Cleanup
RUN rm -rf /usr/src/php \
    && rm -rf /var/cache/apk/*

# This is the only signal from the docker host that appears to stop crond
STOPSIGNAL SIGKILL

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

VOLUME ["/cronscripts"]

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["crond", "-f"]