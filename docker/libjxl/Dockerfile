FROM ubuntu:26.04

ARG LIBJXL_GIT_REPO="https://github.com/libjxl/libjxl.git"
ARG LIBJXL_GIT_TAG=v0.12.0

ENV DEBIAN_FRONTEND=noninteractive
ENV SKIP_TEST=1 

RUN apt-get update && apt-get install -y git build-essential git devscripts && \
    git clone --recurse-submodules --depth 1 --branch $LIBJXL_GIT_TAG $LIBJXL_GIT_REPO && \
    cd libjxl && \
    export HWY_PKG_OPTIONS= && \
    dch -M --distribution unstable --release '' && \
    apt build-dep -y ./third_party/highway && \
    ./ci.sh debian_build highway && \
    dpkg -i build/debs/libhwy-dev_*_*.deb && \
    apt build-dep -y . && \
    ./ci.sh debian_build jpeg-xl && \
    mkdir /debs && \
    find build -name "*.deb" -type f -exec cp {} /debs/* && \
    cd / rm -r -f /libjxl
