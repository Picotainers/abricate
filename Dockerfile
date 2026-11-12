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
        any2fasta \
        ca-certificates \
        ncbi-blast+ \
        emboss \
        perl \
        bioperl \
        git \
        gzip \
        unzip \
        libjson-perl \
        liblist-moreutils-perl \
        libtext-csv-perl \
        libpath-tiny-perl \
        liblwp-protocol-https-perl \
        libwww-perl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /src /opt/abricate

RUN chmod +x /opt/abricate/bin/abricate /opt/abricate/bin/abricate-get_db \
    && ln -sf /opt/abricate/bin/abricate /usr/local/bin/abricate \
    && ln -sf /opt/abricate/bin/abricate-get_db /usr/local/bin/abricate-get_db \
    && abricate --setupdb

WORKDIR /data
CMD ["abricate", "--help"]
