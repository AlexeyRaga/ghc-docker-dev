# mount the GHC source code into /home/ghc
#
#    sudo docker run --rm -i -t -v `pwd`:/home/ghc alexeyraga/ghc-docker-cross-arm /bin/bash
#
# darinmorrison/haskell
# Look here on how to kick off your first build:
# https://ghc.haskell.org/trac/ghc/wiki/Building/Hacking

FROM alexeyraga/ghc-docker-dev:latest
MAINTAINER Alexey Raga

## disable prompts from apt
ENV DEBIAN_FRONTEND noninteractive

## custom apt-get install options
ENV OPTS_APT        -y --force-yes --no-install-recommends

RUN sudo apt-get update \
 && sudo apt-get install ${OPTS_APT} \
    libc6-i386 lib32stdc++6 zlib1g lib32gcc1 lib32z1 
    #\ lib32ncurses5

RUN \
    sudo mkdir -p /opt/toolchain \
    && wget http://dn.odroid.com/toolchains/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux.tar.xz \
    && sudo tar xJf gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux.tar.xz -C /opt/toolchain \
    && rm *.tar.xz \
    && sudo ln -s /opt/toolchain/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux /opt/toolchain/gcc-linaro-arm-linux-gnueabihf

# RUN \
#     export PATH=/opt/toolchain/gcc-linaro-arm-linux-gnueabihf/bin:$PATH \
#     && sudo mkdir -p /opt/toolchain/ncurses \
#     && wget http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.9.tar.gz \
#     && sudo tar zxf ncurses-5.9.tar.gz -C /opt/toolchain/ncurses/ \
#     && rm *.tar.gz \
#     && cd /opt/toolchain/ncurses/ncurses-5.9 \
#     && sudo ./configure --target=arm-linux-gnueabihf --with-gcc=arm-linux-gnueabihf-gcc --with-shared --host=arm-linux-gnueabihf --with-build-cpp=arm-linux-gnueabihf-g++ --prefix=/opt/arm \
#     && sudo make && sudo make install

ADD ./build-ghc.sh /opt/ghc-cross/build-ghc.sh

RUN \
    export PATH=/opt/toolchain/gcc-linaro-arm-linux-gnueabihf/bin:$PATH \
    && wget https://www.haskell.org/ghc/dist/7.8.4/ghc-7.8.4-src.tar.bz2 \
    && sudo tar xf ghc-7.8.4-src.tar.bz2 -C /opt/ghc-cross \
    && rm *.tar.bz2 \
    && sudo sh /opt/ghc-cross/build-ghc.sh

ENV PATH /opt/toolchain/gcc-linaro-arm-linux-gnueabihf/bin:$PATH 