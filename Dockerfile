FROM alpine:3.4
MAINTAINER Alfred Gutierrez <alf.g.jr@gmail.com>

ENV FFMPEG_VERSION 3.3.2

## Build dependencies.
RUN	apk update && apk add	\
  gcc	binutils-libs binutils build-base	libgcc make pkgconf pkgconfig \
  openssl openssl-dev ca-certificates pcre \
  musl-dev libc-dev pcre-dev zlib-dev

# FFmpeg dependencies.
RUN apk add nasm yasm-dev lame-dev libogg-dev x264-dev libvpx-dev libvorbis-dev \
  x265-dev freetype-dev libass-dev libwebp-dev rtmpdump-dev libtheora-dev opus-dev
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
RUN apk add --update fdk-aac-dev

# Get ffmpeg source.
RUN cd /tmp/ && wget http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz \
  && tar zxf ffmpeg-${FFMPEG_VERSION}.tar.gz && rm ffmpeg-${FFMPEG_VERSION}.tar.gz

# Compile ffmpeg.
RUN cd /tmp/ffmpeg-${FFMPEG_VERSION} && \
  ./configure \
  --enable-version3 \
  --enable-gpl \
  --enable-nonfree \
  --enable-small \
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
  && make && make install && make distclean

# Cleanup.
RUN rm -rf /var/cache/apk/* /tmp/*
