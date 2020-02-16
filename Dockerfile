FROM debian:buster AS fetcher

ARG OSMOSIS_VERSION=0.47

WORKDIR /osmosis

ADD https://bretth.dev.openstreetmap.org/osmosis-build/osmosis-${OSMOSIS_VERSION}.tgz /osmosis/osmosis.tgz

RUN tar xvf /osmosis/osmosis.tgz \
  && rm /osmosis/osmosis.tgz

FROM openjdk:8-jre-slim-buster

LABEL org.opencontainers.image.authors="Jeremie Drouet <jeremie.drouet@gmail.com>" \
  org.opencontainers.image.title="Osmosis" \
  org.opencontainers.image.description="Osmosis in a container" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.url="https://hub.docker.com/r/jdrouet/osmosis" \
  org.opencontainers.image.source="https://github.com/jdrouet/docker-osmosis"

COPY --from=fetcher /osmosis /osmosis
WORKDIR /osmosis

ENTRYPOINT [ "/osmosis/bin/osmosis" ]