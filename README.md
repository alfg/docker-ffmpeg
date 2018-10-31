# docker-ffmpeg
An FFmpeg Dockerfile built from source. Built on Alpine Linux.

* ffmpeg 4.0.2 (compiled from source)

[![Docker Stars](https://img.shields.io/docker/stars/alfg/ffmpeg.svg)](https://hub.docker.com/r/alfg/ffmpeg/)
[![Docker Pulls](https://img.shields.io/docker/pulls/alfg/ffmpeg.svg)](https://hub.docker.com/r/alfg/ffmpeg/)
[![Docker Automated build](https://img.shields.io/docker/automated/alfg/ffmpeg.svg)](https://hub.docker.com/r/alfg/ffmpeg/builds/)
[![Build Status](https://travis-ci.org/alfg/docker-ffmpeg.svg?branch=master)](https://travis-ci.org/alfg/docker-ffmpeg)

## Usage

* Pull Docker image and run:
```
docker pull alfg/ffmpeg
docker run -it --rm alfg/ffmpeg ffmpeg -buildconf
```

* or build and run container from source:

```
docker build -t ffmpeg .
docker run -it ffmpeg ffmpeg -buildconf
```

* or use as a base image in your Dockerfile:
```
FROM alfg/ffmpeg:latest
```

## FFmpeg Snapshot Builds
For building ffmpeg from snapshot, see [snapshot/Dockerfile](/snapshot/Dockerfile) for FFmpeg snapshot builds including support for AV1 (libaom).

Or pull from the Docker tag:
```
docker pull alfg/ffmpeg:snapshot
```

### FFmpeg Build
```
 # ffmpeg -buildconf
ffmpeg version 4.0.2 Copyright (c) 2000-2018 the FFmpeg developers
  built with gcc 6.4.0 (Alpine 6.4.0)
  configuration: --enable-version3 --enable-gpl --enable-nonfree --enable-small --enable-libmp3lame --enable-libx264 --enable-libx265 --enable-libvpx --enable-libtheora --enable-libvorbis --enable-libopus --enable-libfdk-aac --enable-libass --enable-libwebp --enable-librtmp --enable-postproc --enable-avresample --enable-libfreetype --enable-openssl --disable-debug
  libavutil      56. 14.100 / 56. 14.100
  libavcodec     58. 18.100 / 58. 18.100
  libavformat    58. 12.100 / 58. 12.100
  libavdevice    58.  3.100 / 58.  3.100
  libavfilter     7. 16.100 /  7. 16.100
  libavresample   4.  0.  0 /  4.  0.  0
  libswscale      5.  1.100 /  5.  1.100
  libswresample   3.  1.100 /  3.  1.100
  libpostproc    55.  1.100 / 55.  1.100

  configuration:
    --enable-version3
    --enable-gpl
    --enable-nonfree
    --enable-small
    --enable-libmp3lame
    --enable-libx264
    --enable-libx265
    --enable-libvpx
    --enable-libtheora
    --enable-libvorbis
    --enable-libopus
    --enable-libfdk-aac
    --enable-libass
    --enable-libwebp
    --enable-librtmp
    --enable-postproc
    --enable-avresample
    --enable-libfreetype
    --enable-openssl
    --disable-debug
```

## Resources
* https://alpinelinux.org/
* https://www.ffmpeg.org

## License
MIT
