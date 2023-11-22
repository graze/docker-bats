FROM alpine:3.18

ARG VERSION=1.10.0

LABEL maintainer="developers@graze.com" \
    license="MIT" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.vendor="graze" \
    org.label-schema.name="bats" \
    org.label-schema.version="${VERSION}" \
    org.label-schema.description="alpine image for testing with bats" \
    org.label-schema.vcs-url="https://github.com/graze/docker-bats" \
    org.label-schema.docker.cmd="docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/app graze/bats"

RUN apk add --no-cache --update bash curl docker make jq git && \
      curl -o "/tmp/v${VERSION}.tar.gz" -L "https://github.com/bats-core/bats-core/archive/v${VERSION}.tar.gz" && \
      tar -x -z -f "/tmp/v${VERSION}.tar.gz" -C /tmp/ && \
      bash "/tmp/bats-core-${VERSION}/install.sh" /usr/local && \
      rm -rf /tmp/*

VOLUME /app
WORKDIR /app

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.build-date=$BUILD_DATE

ENTRYPOINT ["/usr/local/bin/bats"]
CMD ["-h"]
