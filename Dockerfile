FROM ubuntu:20.04@sha256:8feb4d8ca5354def3d8fce243717141ce31e2c428701f6682bd2fafe15388214

ARG DEBIAN_FRONTEND=noninteractive
SHELL ["/usr/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bash \
    bc \
    binutils-aarch64-linux-gnu \
    bsdmainutils \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    default-jre \
    device-tree-compiler \
    diffutils \
    dos2unix \
    file \
    fonts-droid-fallback \
    gawk \
    gcc \
    git \
    gperf \
    libasound2-dev \
    libboost-all-dev \
    libc-dev-bin \
    libcurl4-openssl-dev \
    libfreeimage-dev \
    libfreetype6-dev \
    libgl1-mesa-dev \
    libjson-perl \
    libncurses5-dev \
    libparse-yapp-perl \
    libsdl2-dev \
    libsdl2-mixer-dev \
    libssl-dev \
    libvlc-dev \
    libvlccore-dev \
    libvpx-dev \
    libxml-parser-perl \
    locales \
    lzop \
    make \
    meson \
    patch \
    patchutils \
    patchelf \
    premake4 \
    p7zip \
    p7zip-full \
    python3 \
    python-is-python3 \
    rapidjson-dev \
    rdfind \
    rsync \
    texinfo \
    u-boot-tools \
    unrar \
    unzip \
    vlc-bin \
    wget \
    xfonts-utils \
    xmlstarlet \
    xsltproc \
    xz-utils \
    zip \
  && locale-gen en_US.UTF-8 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ARG GO_BOOTSTRAP_VERSION=1.20.14
ARG GO_BOOTSTRAP_SHA256=ff445e48af27f93f66bd949ae060d97991c83e11289009d311f25426258f9c44
RUN wget -O /tmp/go-bootstrap.tar.gz "https://go.dev/dl/go${GO_BOOTSTRAP_VERSION}.linux-amd64.tar.gz" \
  && printf '%s  %s\n' "${GO_BOOTSTRAP_SHA256}" /tmp/go-bootstrap.tar.gz | sha256sum -c - \
  && rm -rf /usr/lib/go /usr/lib/go-* \
  && tar -C /usr/lib -xzf /tmp/go-bootstrap.tar.gz \
  && ln -sf /usr/lib/go/bin/go /usr/local/bin/go \
  && ln -sf /usr/lib/go/bin/gofmt /usr/local/bin/gofmt \
  && /usr/lib/go/bin/go version \
  && rm -f /tmp/go-bootstrap.tar.gz

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV PYTHONNOUSERSITE=yes

WORKDIR /work/src
