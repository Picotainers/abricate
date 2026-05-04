# syntax=docker/dockerfile:1

FROM debian:bookworm-slim AS builder

ARG ABRICATE_VERSION=v1.0.1

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates git \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch "${ABRICATE_VERSION}" https://github.com/tseemann/abricate.git /src

FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        ncbi-blast+ \
        emboss \
        perl \
        bioperl \
        git \
        gzip \
        unzip \
        libjson-perl \
        libtext-csv-perl \
        libpath-tiny-perl \
        liblwp-protocol-https-perl \
        libwww-perl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /src /opt/abricate

RUN install -m 0755 /opt/abricate/bin/abricate /usr/local/bin/abricate \
    && install -m 0755 /opt/abricate/bin/abricate-get_db /usr/local/bin/abricate-get_db \
    && mkdir -p /usr/local/share/abricate \
    && cp -r /opt/abricate/db /usr/local/share/abricate/db

ENV ABRICATE_DB=/usr/local/share/abricate/db
WORKDIR /data
CMD ["abricate", "--help"]
