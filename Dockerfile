FROM ubuntu:20.04

ENV GOPATH=/go \
    PATH=/go/bin:/usr/lib/go-1.14/bin:$PATH \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get -y install \
        bc \
        build-essential \
        cmake \
        device-tree-compiler \
        gcc-aarch64-linux-gnu \
        g++-aarch64-linux-gnu \
        git \
        unzip \
        qemu-user-static \
        multistrap \
        zip \
        wget \
        dosfstools \
        kpartx \
        golang-1.14-go \
        rsync \
        flex bison libssl-dev gnupg2 curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && go get \
        github.com/aktau/github-release \
        github.com/cheggaaa/pb \
        golang.org/x/crypto/openpgp

WORKDIR $GOPATH/src/github.com/bamarni/pi64

COPY . $GOPATH/src/github.com/bamarni/pi64

RUN go install github.com/bamarni/pi64/cmd/pi64-build
