ARG LIBJXL_VERSION="latest"

FROM ghcr.io/cmahnke/jpeg-xl-action:${LIBJXL_VERSION}

LABEL maintainer="cmahnke@gmail.com"
LABEL "com.github.actions.name"="ImageMAgick with JPEG XL conversion"
LABEL org.opencontainers.image.source https://github.com/cmahnke/jpeg-xl-action

ARG IMAGEMAGICK_GIT_TAG=7.1.1-39

ENV BUILD_DEPS="git wget cmake make automake autoconf libtool clang-dev g++ zlib-dev libjpeg-turbo-dev libpng-dev libavif-dev libwebp-dev openexr-dev libheif-dev libzip-dev libxml2-dev lcms2-dev freetype-dev fontconfig-dev tiff-dev patch gsl-dev" \
    RUN_DEPS="zlib jpeg libjpeg-turbo libpng openexr-libopenexr libavif libwebp libheif libzip libxml2 libwebpdecoder libwebpdemux libwebpmux openexr-libopenexrutil openexr-libopenexrcore brotli lcms2 freetype fontconfig ffmpeg libjxl-tools tiff libavif-apps exiv2 gsl" \
    IM_GIT_REPO="https://github.com/ImageMagick/ImageMagick.git" \
    BUILD_DIR=/tmp/build

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk --update upgrade &&\
    apk add --no-cache $RUN_DEPS $BUILD_DEPS $ADDITIONAL_DEPS && \
    mkdir -p $BUILD_DIR $DATA_DIR && \
    export CC=clang CXX=clang++ && \
    cd $BUILD_DIR && \
# ImageMagick
    git clone --depth 1 --branch $IMAGEMAGICK_GIT_TAG $IM_GIT_REPO && \
    cd ImageMagick && \
    ./configure --with-uhdr=yes --with-webp=yes --with-jpeg=yes --with-jxl=yes --with-openexr=yes	--with-xml=yes --with-zip=yes --with-zlib=yes --enable-hdri=yes --with-freetype=yes --with-tiff=yes --prefix=/usr && \
    make && make install && \
# Cleanup
    rm -rf $BUILD_DIR  && \
    apk del $BUILD_DEPS && \
    rm -rf /var/cache/apk/* /root/.cache
