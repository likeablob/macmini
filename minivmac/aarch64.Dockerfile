FROM alpine AS qemu

# Download QEMU, see https://github.com/docker/hub-feedback/issues/1261
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-aarch64.tar.gz
RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

FROM arm64v8/ubuntu:bionic as DEV

# Add QEMU
COPY --from=qemu qemu-*-static /usr/bin

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  xorg-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ARG t_arch=aarch64

# Build minivmac.320
WORKDIR /opt/minivmac-320
COPY minivmac-3.5.8-larm-320x240.tar.gz ./
RUN tar xvf minivmac-3.5.8-larm-320x240.tar.gz --strip-components=1 && make && mv minivmac /minivmac.${t_arch}.320

# Build minivmac.512
WORKDIR /opt/minivmac-512
COPY minivmac-3.5.8-larm-512x384.tar.gz ./
RUN tar xvf minivmac-3.5.8-larm-512x384.tar.gz --strip-components=1 && make && mv minivmac /minivmac.${t_arch}.512

