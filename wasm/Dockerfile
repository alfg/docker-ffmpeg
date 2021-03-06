FROM emscripten/emsdk as build

ARG FFMPEG_VERSION=4.3.1
ARG X264_VERSION=master

ARG PREFIX=/opt/ffmpeg
ARG MAKEFLAGS="-j4"

RUN apt-get update && apt-get install -y autoconf libtool build-essential

# libx264
RUN cd /tmp/ && \
  wget https://code.videolan.org/videolan/x264/-/archive/master/x264-master.tar.gz && \
  tar zxf x264-${X264_VERSION}.tar.gz

RUN cd /tmp/x264-${X264_VERSION} && \
  emconfigure ./configure \
  --prefix=${PREFIX} \
  --host=i686-gnu \
  --enable-static \
  --disable-cli \
  --disable-asm \
  --extra-cflags="-s USE_PTHREADS=1"

RUN cd /tmp/x264-${X264_VERSION} && \
  emmake make install-lib-static -j4

# Get ffmpeg source.
RUN cd /tmp/ && \
  wget http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz && \
  tar zxf ffmpeg-${FFMPEG_VERSION}.tar.gz && rm ffmpeg-${FFMPEG_VERSION}.tar.gz

RUN emcc -v

ARG CFLAGS="-s USE_PTHREADS -O3 -I${PREFIX}/include"
ARG LDFLAGS="$CFLAGS -L${PREFIX}/lib -s INITIAL_MEMORY=33554432"

# Compile ffmpeg.
RUN cd /tmp/ffmpeg-${FFMPEG_VERSION} && \
  emconfigure ./configure \
  --prefix=${PREFIX} \
  --target-os=none \
  --arch=x86_32 \
  --enable-cross-compile \
  --disable-x86asm \
  --disable-inline-asm \
  --disable-stripping \
  --disable-programs \
  --disable-doc \
  --enable-gpl \
  --enable-libx264 \
  --extra-cflags="$CFLAGS" \
  --extra-cxxflags="$CFLAGS" \
  --extra-ldflags="$LDFLAGS" \
  --nm="llvm-nm -g" \
  --ar=emar \
  --as=llvm-as \
  --ranlib=llvm-ranlib \
  --cc=emcc \
  --cxx=em++ \
  --objcc=emcc \
  --dep-cc=emcc

RUN cd /tmp/ffmpeg-${FFMPEG_VERSION} && \
  emmake make -j4

RUN mkdir -p /tmp/ffmpeg-${FFMPEG_VERSION}/wasm/dist

RUN cd /tmp/ffmpeg-${FFMPEG_VERSION} && \
  emcc \
  -I. -I./fftools -I${PREFIX}/include \
  -Llibavcodec \
  -Llibavdevice \
  -Llibavfilter \
  -Llibavformat \
  -Llibavresample \
  -Llibavutil \
  -Llibpostproc \
  -Llibswscale \
  -Llibswresample \
  -L${PREFIX}/lib \
  -Qunused-arguments \
  -o wasm/dist/ffmpeg.js \
  fftools/ffmpeg_opt.c \
  fftools/ffmpeg_filter.c \
  fftools/ffmpeg_hw.c \
  fftools/cmdutils.c \
  fftools/ffmpeg.c \
  -lavdevice -lavfilter -lavformat -lavcodec -lswresample -lswscale -lavutil -lpostproc -lm -lx264 -pthread \
  -O3 \
  -s USE_SDL=2 \
  -s USE_PTHREADS=1 \
  -s PROXY_TO_PTHREAD=1 \
  -s INVOKE_RUN=0 \
  -s EXPORTED_FUNCTIONS="[_main, _proxy_main]" \
  -s EXTRA_EXPORTED_RUNTIME_METHODS="[FS, cwrap, setValue, writeAsciiToMemory]" \
  -s ALLOW_MEMORY_GROWTH=1 \
  -s INITIAL_MEMORY=268435456

COPY wasm/basic.html /tmp/ffmpeg-${FFMPEG_VERSION}/wasm/basic.html
COPY wasm/transcode.html /tmp/ffmpeg-${FFMPEG_VERSION}/wasm/transcode.html
