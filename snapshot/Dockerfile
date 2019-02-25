###############################
# Build the FFmpeg-build image.
FROM alpine:3.8 as build

ARG FFMPEG_VERSION=ffmpeg-snapshot.tar.bz2
ARG AOM_VERSION=master

ARG PREFIX=/opt/ffmpeg
ARG PKG_CONFIG_PATH=/opt/ffmpeg/lib64/pkgconfig
ARG LD_LIBRARY_PATH=/opt/ffmpeg/lib
ARG MAKEFLAGS="-j4"

# FFmpeg build dependencies.
RUN apk add --update \
  build-base \
  cmake \
  freetype-dev \
  lame-dev \
  libogg-dev \
  libass \
  libass-dev \
  libvpx-dev \
  libvorbis-dev \
  libwebp-dev \
  libtheora-dev \
  libtool \
  opus-dev \
  perl \
  pkgconf \
  pkgconfig \
  python \
  rtmpdump-dev \
  wget \
  x264-dev \
  x265-dev \
  yasm

# Install fdk-aac from testing.
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
  apk add --update fdk-aac-dev

# Build libaom for av1.
RUN mkdir -p /tmp/aom && cd /tmp/ && \
  wget https://aomedia.googlesource.com/aom/+archive/${AOM_VERSION}.tar.gz && \
  tar zxf ${AOM_VERSION}.tar.gz && rm ${AOM_VERSION}.tar.gz && \
  rm -rf CMakeCache.txt CMakeFiles && \
  mkdir -p ./aom_build && \
  cd ./aom_build && \
  cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}" -DBUILD_SHARED_LIBS=1 .. && \
  make && make install

# Get ffmpeg source.
RUN cd /tmp/ && \
  wget https://ffmpeg.org/releases/${FFMPEG_VERSION} && \
  tar xjvf ${FFMPEG_VERSION} && rm ${FFMPEG_VERSION}

# Compile ffmpeg.
RUN cd /tmp/ffmpeg && \
  ./configure \
  --enable-version3 \
  --enable-gpl \
  --enable-nonfree \
  --enable-small \
  --enable-libaom \
  --enable-libmp3lame \
  --enable-libx264 \
  --enable-libx265 \
  --enable-libvpx \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libopus \
  --enable-libfdk-aac \
  --enable-libass \
  --enable-libwebp \
  --enable-librtmp \
  --enable-postproc \
  --enable-avresample \
  --enable-libfreetype \
  --enable-openssl \
  --disable-debug \
  --disable-doc \
  --disable-ffplay \
  --extra-cflags="-I${PREFIX}/include" \
  --extra-ldflags="-L${PREFIX}/lib" \
  --extra-libs="-lpthread -lm" \
  --prefix="${PREFIX}" && \
  make && make install && make distclean

# Cleanup.
RUN rm -rf /var/cache/apk/* /tmp/*

##########################
# Build the release image.
FROM alpine:3.8
LABEL MAINTAINER Alfred Gutierrez <alf.g.jr@gmail.com>
ENV PATH=/opt/ffmpeg/bin:$PATH

RUN apk add --update \
  ca-certificates \
  openssl \
  pcre \
  lame \
  libogg \
  libass \
  libvpx \
  libvorbis \
  libwebp \
  libtheora \
  opus \
  rtmpdump \
  x264-dev \
  x265-dev

COPY --from=build /opt/ffmpeg /opt/ffmpeg
COPY --from=build /opt/ffmpeg/lib64/libaom.so.0 /usr/lib/libaom.so.0
COPY --from=build /usr/lib/libfdk-aac.so.2 /usr/lib/libfdk-aac.so.2

CMD ["/opt/ffmpeg/bin/ffmpeg"]
