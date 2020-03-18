FROM alpine:3.11.3

LABEL maintainer="Sharapov A. <alexander@sharapov.biz>"

ENV FFMPEG_VERS_TAG=4.2.2

WORKDIR /tmp/ffmpeg

RUN apk add --update build-base curl nasm tar bzip2 zlib-dev libass-dev lame-dev \
libogg-dev x264-dev libvpx-dev libvorbis-dev x265-dev freetype-dev libass-dev \
libwebp-dev rtmpdump-dev libtheora-dev opus-dev openssl-dev yasm-dev

RUN DIR=$(mktemp -d) && \
cd ${DIR} && \
curl -s http://www.ffmpeg.org/releases/ffmpeg-${FFMPEG_VERS_TAG}.tar.gz | tar xzf - -C . && \
cd ffmpeg-${FFMPEG_VERS_TAG} && \
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
--enable-libass \
--enable-libwebp \
--enable-librtmp \
--enable-postproc \
--enable-avresample \
--enable-libfreetype \
--enable-openssl \
--disable-debug && \
make && \
make install && \
make distclean

RUN rm -rf ${DIR} && \
apk del build-base curl tar bzip2 x264 openssl nasm && \
rm -rf /var/cache/apk/*

ENTRYPOINT ["ffmpeg"]
