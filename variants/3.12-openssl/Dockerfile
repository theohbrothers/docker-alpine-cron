FROM alpine:3.12

RUN apk add --no-cache curl wget

RUN apk add --no-cache openssl

# This is the only signal from the docker host that appears to stop crond
STOPSIGNAL SIGKILL

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

VOLUME ["/cronscripts"]

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["crond", "-f"]
