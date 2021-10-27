FROM nvidia/cuda:11.4.2-devel-ubuntu20.04 AS ffmpeg-build
ENV DEBIAN_FRONTEND=noninteractive
ENV CCACHE_DIR=/opt/.ccache
ENV USE_CCACHE=1
ENV DEV="make gcc git g++ automake curl wget autoconf build-essential libtool libva-dev libvdpau-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev ccache"
RUN mkdir /opt/.ccache
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
# Prep
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get update && \
    apt-get -y install $DEV && \
    apt-get update && \
    apt-get -y install yasm libx264-dev libmp3lame-dev libopus-dev libvpx-dev libaribb24-dev libx265-dev libnuma-dev \
    libass-dev libfreetype6-dev libsdl1.2-dev libvorbis-dev libtheora-dev

SHELL ["/bin/bash", "-c"]

# FFMpeg version
ENV FFMPEG_VERSION=4.4.1
# https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/index.html#virtual-architecture-feature-list
ENV CUDA_CC="35 37 50 52 53 60 61 62 70 72 75 80 86 87" 

RUN --mount=type=cache,target=/opt/.ccache \
#nvenc build
    GIT_SSL_NO_VERIFY=1 \
    git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git --depth=1 && \
    cd nv-codec-headers && make install && cd .. && \
    rm -rf nv-codec-headers && \
\
#ffmpeg build
    mkdir /tmp/ffmpeg_sources && \
    cd /tmp/ffmpeg_sources && \
    ary=(`echo $CUDA_CC`) && \
    for i in `seq 1 ${#ary[@]}`;  do    gencode="-gencode arch=compute_${ary[$i-1]},code=sm_${ary[$i-1]} $gencode"; done && \
    CUDA_OPTION="-arch sm_52 ${gencode} -O2" && \
    curl -fsSL http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2 | tar -xj --strip-components=1 && \
    sed -i -e 's/$nvccflags -ptx/$nvccflags/g' ./configure && \
    ./configure \
      --prefix=/ffmpeg \
      --disable-shared \
      --pkg-config-flags=--static \
      --enable-gpl \
      --enable-libass \
      --enable-libfreetype \
      --enable-libmp3lame \
      --enable-libopus \
      --enable-libtheora \
      --enable-libvorbis \
      --enable-libvpx \
      --enable-libx264 \
      --enable-libx265 \
      --enable-version3 \
      --enable-libaribb24 \
      --enable-nonfree \
      --disable-debug \
      --disable-doc \
# ccache有効
      --cc="ccache cc" --cxx="ccache c++" \
# CUDA Toolkit
      --enable-cuda-nvcc --extra-cflags=-I/usr/local/cuda/include \
      --extra-ldflags=-L/usr/local/cuda/lib64 \
# CC指定フラグ追加 (https://github.com/NVIDIA/cuda-samples/issues/46#issuecomment-863835984 より)
      --nvccflags="${CUDA_OPTION}" \
&& \
    make -j$(nproc) && \
    make install


FROM nvidia/cuda:11.4.2-base-ubuntu20.04

ENV NODE_VERSION 16
ENV DEBIAN_FRONTEND=noninteractive
ENV RUNTIME="libasound2 libass9 libvdpau1 libva-x11-2 libva-drm2 libxcb-shm0 libxcb-xfixes0 libxcb-shape0 libvorbisenc2 libtheora0 libx264-155 libx265-179 libmp3lame0 libopus0 libvpx6 libaribb24-0"

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt update && \
    apt install -y wget gcc g++ make && \
    wget https://deb.nodesource.com/setup_${NODE_VERSION}.x -O - | bash - && \
    apt -y install nodejs && \
    apt install -y $RUNTIME && \
    apt purge -y wget gcc g++ make
    
COPY --from=l3tnun/epgstation:master-debian /app /app/
COPY --from=l3tnun/epgstation:master-debian /app/client /app/client/
COPY --from=ffmpeg-build /ffmpeg /usr/local/
RUN chmod 444 /app/src -R

# dry run
RUN ffmpeg -codecs 

LABEL maintainer="maleicacid"
EXPOSE 8888
WORKDIR /app
ENTRYPOINT ["npm"]
CMD ["start"]
