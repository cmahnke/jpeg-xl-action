# syntax=docker/dockerfile:experimental

FROM alpine:3.16.1

LABEL maintainer="cmahnke@gmail.com"
LABEL "com.github.actions.name"="GitHub Actions JPEG XL conversion"
LABEL "com.github.actions.description"="This is a simple GitHub Action to convert images from and to JPEG-XL"
LABEL org.opencontainers.image.source https://github.com/cmahnke/jpeg-xl-action

ARG GIT_TAG=""

ENV BUILD_DEPS="cmake git gcc g++ make libc-dev libgcc binutils pkgconfig giflib-dev libavif-dev libjpeg-turbo-dev libpng-dev libwebp-dev brotli-dev openexr-dev" \
    RUN_DEPS="busybox libpng libwebp giflib libavif libjpeg-turbo brotli-libs libstdc++ openexr" \
    BUILD_DIR=/tmp/build \
    GIT_URL="https://github.com/libjxl/libjxl.git"

RUN apk --update upgrade && \
    apk add --no-cache $RUN_DEPS $BUILD_DEPS && \
    mkdir -p $BUILD_DIR && \
    cd $BUILD_DIR && \
    git clone --recursive $GIT_URL && \
    cd libjxl && \
    if [ -n "GIT_TAG" ] ; then \
        git checkout $GIT_TAG ; \
    fi && \
    mkdir build && cd build && \
    cmake -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF -DCMAKE_INSTALL_PREFIX=/usr .. && \
    cmake --build . -- -j$(nproc) && \
    cmake --install . && \
# Fix some installation issues, see https://gitlab.com/wg1/jpeg-xl/-/issues/200
    ln -s /usr/lib64/pkgconfig/* /usr/lib/pkgconfig/ && \
    rm -rf /usr/include/contrib/image /usr/include/contrib/math /usr/include/hwy && \
    ln -s /usr/lib64/libjxl* /usr/lib/ && \
# Cleanup
    cd / && \
    apk del $BUILD_DEPS libjpeg && \
    rm -rf $BUILD_DIR /var/cache/apk/* /root/.cache /usr/bin/benchmark_xl
