FROM alpine:3.8

RUN apk add --no-cache curl wget

# This is the only signal from the docker host that appears to stop crond
STOPSIGNAL SIGKILL

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["crond", "-f"]
