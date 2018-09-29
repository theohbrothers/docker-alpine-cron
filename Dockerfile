FROM alpine

MAINTAINER The Oh Brothers

RUN apk add --update curl wget && rm -rf /var/cache/apk/*

# This is the only signal from the docker host that appears to stop crond
STOPSIGNAL SIGKILL

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

VOLUME ["/cronscripts"]

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["crond", "-f"]
