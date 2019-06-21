# put in docker file
cd ~/ffmpeg_sources && \
wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
tar xjvf ffmpeg-snapshot.tar.bz2 && \
cd ffmpeg && \
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$HOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --disable-all \
  --disable-alsa \
  --disable-amf \
  --disable-appkit \
  --disable-audiotoolbox \
  --disable-autodetect \
  --disable-avfoundation \
  --disable-bzlib \
  --disable-coreimage \
  --disable-cuvid \
  --disable-d3d11va \
  --disable-dxva2 \
  --disable-ffnvcodec \
  --disable-iconv \
  --disable-libxcb \
  --disable-libxcb-shape \
  --disable-libxcb-shm \
  --disable-libxcb-xfixes \
  --disable-lzma \
  --disable-nvdec \
  --disable-nvenc \
  --disable-os2threads \
  --disable-schannel \
  --disable-sdl2 \
  --disable-securetransport \
  --disable-sndio \
  --disable-v4l2-m2m \
  --disable-vaapi \
  --disable-vdpau \
  --disable-videotoolbox \
  --disable-w32threads \
  --disable-xlib \
  --disable-zlib \
  --enable-avcodec \
  --enable-avfilter \
  --enable-avformat \
  --enable-decoder='h264,aac' \
  --enable-demuxer=mpegts \
  --enable-encoder=mjpeg \
  --enable-ffmpeg \
  --enable-ffprobe \
  --enable-filter='scale,fps' \
  --enable-gpl \
  --enable-libx264 \
  --enable-muxer=image2 \
  --enable-parser=h264 \
  --enable-protocol=file \
  --enable-pthreads \
  --enable-small \
  --enable-static \
  --enable-swresample \
  --enable-swscale \
  --extra-cflags=-I../x264 \
  --extra-cxxflags=-I../x264 \
  --extra-ldflags=-L../x264 \
  --extra-libs=-lpthread && \
PATH="$HOME/bin:$PATH" make && \
make install && \
hash -r
