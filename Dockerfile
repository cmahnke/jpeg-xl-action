# syntax=docker/dockerfile:experimental

FROM alpine:3.19

LABEL maintainer="cmahnke@gmail.com"
LABEL "com.github.actions.name"="GitHub Actions JPEG XL conversion"
LABEL "com.github.actions.description"="This is a simple GitHub Action to convert images from and to JPEG-XL"
LABEL org.opencontainers.image.source https://github.com/cmahnke/jpeg-xl-action

ARG GIT_TAG=""

ENV BUILD_DEPS="cmake git g++ clang-dev make libc-dev libgcc binutils pkgconfig giflib-dev libavif-dev libjpeg-turbo-dev libpng-dev \
                libwebp-dev brotli-dev openexr-dev linux-headers" \
    RUN_DEPS="busybox libstdc++ libpng libwebp giflib libavif libjpeg-turbo brotli-libs openexr libatomic" \
    BUILD_DIR=/tmp/build \
    GIT_URL="https://github.com/libjxl/libjxl.git" \
    DEFAULT_GIT_TAG="v0.10.2"

RUN apk --update upgrade && \
    apk add --no-cache $RUN_DEPS $BUILD_DEPS && \
    mkdir -p $BUILD_DIR && \
    cd $BUILD_DIR && \
    if [ -z "$GIT_TAG" ] ; then \
        GIT_TAG=$DEFAULT_GIT_TAG ; \
    fi && \
    git clone --depth 1 --recursive $GIT_URL --branch "$GIT_TAG" --shallow-submodules && \
    cd libjxl && \
    mkdir build && cd build && \
    export CC=clang CXX=clang++ && \
    cmake -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DCMAKE_BUILD_TYPE=Release -DJPEGXL_ENABLE_DOXYGEN:BOOL=OFF -DJPEGXL_ENABLE_BENCHMARK:BOOL=OFF -DJPEGXL_ENABLE_EXAMPLES:BOOL=OFF -DBUILD_TESTING=OFF -DCMAKE_INSTALL_PREFIX=/usr .. && \
    cmake --build . -- -j$(nproc) && \
    cmake --install . && \
# Cleanup
    cd / && \
    apk del $BUILD_DEPS libjpeg && \
    rm -rf $BUILD_DIR /var/cache/apk/* /root/.cache /usr/bin/benchmark_xl
