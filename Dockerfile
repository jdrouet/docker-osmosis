FROM alpine:3.11 AS fetcher

ARG OSMOSIS_VERSION=0.47

WORKDIR /osmosis

ADD https://bretth.dev.openstreetmap.org/osmosis-build/osmosis-${OSMOSIS_VERSION}.tgz /osmosis/osmosis.tgz

RUN tar xvf /osmosis/osmosis.tgz \
  && rm /osmosis/osmosis.tgz

FROM alpine:3.11

LABEL org.opencontainers.image.authors="Jeremie Drouet <jeremie.drouet@gmail.com>" \
  org.opencontainers.image.title="Osmosis" \
  org.opencontainers.image.description="Osmosis in a container" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.url="https://hub.docker.com/r/jdrouet/osmosis" \
  org.opencontainers.image.source="https://github.com/jdrouet/docker-osmosis"

RUN apk add --no-cache openjdk8-jre-base

COPY --from=fetcher /osmosis /osmosis
WORKDIR /osmosis

ENTRYPOINT [ "/osmosis/bin/osmosis" ]
CMD ["--help"]
