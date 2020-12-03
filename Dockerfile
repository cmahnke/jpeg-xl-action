# syntax=docker/dockerfile:experimental

FROM alpine:3.12

LABEL maintainer="cmahnke@gmail.com"
LABEL "com.github.actions.name"="GitHub Actions JPEG XL conversion"
LABEL "com.github.actions.description"="This is a simple GitHub Action to convert imageges from and to JPEG-XL"

# clang lld openexr-dev

ENV BUILD_DEPS="cmake git gcc g++ make libc-dev libgcc binutils pkgconfig giflib-dev libjpeg-turbo-dev libpng-dev libwebp-dev brotli-dev" \
    RUN_DEPS="bash busybox libpng libwebp giflib libjpeg-turbo brotli-libs libstdc++" \
    BUILD_DIR=/tmp/build \
    GIT_URL="https://gitlab.com/wg1/jpeg-xl.git"
#    CC=clang-10 \
#    CXX=clang++


RUN apk --update upgrade && \
    apk add --no-cache $RUN_DEPS $BUILD_DEPS && \
#    ln -s /usr/bin/ld.lld /usr/bin/ld && \
    mkdir -p $BUILD_DIR && \
    cd $BUILD_DIR && \
    git clone --recursive $GIT_URL && \
    cd jpeg-xl && mkdir build && cd build && \
    cmake -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF .. && \
    cmake --build . -- -j 1 && \
    cmake --install . --prefix /usr && \
# Cleanup
    cd / && rm -rf $BUILD_DIR && \
#    rm /usr/bin/ld && \
    rm /usr/bin/benchmark_xl && \
    apk del $BUILD_DEPS libjpeg
