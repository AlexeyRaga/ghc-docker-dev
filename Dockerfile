# mount the GHC source code into /home/ghc
#
#    sudo docker run --rm -i -t -v `pwd`:/home/ghc alexeyraga/ghc-haskell-dev /bin/bash
#
# There is one final setup step to run once you have the image up:
#
#    arc install-certificate
#
# This places a .arcrc file (which is ignored) in your repo
# arc is a tool to interface with phabricator, the main ghc development tool.
# When you have a patch ready, run:
# 
#    arc diff
#
# Look here on how to kick off your first build:
# https://ghc.haskell.org/trac/ghc/wiki/Building/Hacking

FROM debian:testing
MAINTAINER Alexey Raga

ADD ./01_nodoc /etc/dpkg/dpkg.cfg.d/01_nodoc
ADD ./02nocache /etc/apt/apt.conf.d/02nocache
ADD ./clean.sh /usr/local/bin/clean.sh
RUN chown root.root /usr/local/bin/clean.sh && chmod 700 /usr/local/bin/clean.sh

## add ppa for ubuntu trusty haskell packages
# from darinmorrison/haskell
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F6F88286 \
 && echo 'deb     http://ppa.launchpad.net/hvr/ghc/ubuntu trusty main' >> /etc/apt/sources.list.d/haskell.list \
 && echo 'deb-src http://ppa.launchpad.net/hvr/ghc/ubuntu trusty main' >> /etc/apt/sources.list.d/haskell.list

RUN apt-get update && apt-get install -y \
 wget \
 xz-utils \
 # from darinmorrison/haskell, related to ncurses, not sure if it is needed
 libtinfo5 \
 # mentioned on the GHC wiki
 autoconf automake libtool make libgmp-dev ncurses-dev g++ llvm-3.4-dev python bzip2 ca-certificates \
 ## install minimal set of haskell packages
 # from darinmorrison/haskell
 ghc-7.8.4 \
 alex \
 cabal-install-1.22 \
 happy \
 # development conveniences
 sudo xutils-dev \
 && apt-get clean \
 && /usr/local/bin/clean.sh

 RUN \ 
 	mkdir -p /opt/toolchain \
 	&& wget http://dn.odroid.com/toolchains/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux.tar.xz \
 	&& tar xJf gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux.tar.xz -C /opt/toolchain \
 	&& rm *.tar.xz \
 	&& ln -s /opt/toolchain/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux /opt/toolchain/gcc-linaro-arm-linux-gnueabihf

RUN \
	export PATH=/opt/toolchain/gcc-linaro-arm-linux-gnueabihf/bin:$PATH \
	&& mkdir -p /opt/toolchain/ncurses \
	&& wget http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.9.tar.gz \
	&& tar zxf ncurses-5.9.tar.gz -C /opt/toolchain/ncurses/ \
	&& rm *.tar.gz \
	&& cd /opt/toolchain/ncurses/ncurses-5.9
	&& ./configure --target=arm-linux-gnueabihf --with-gcc=arm-linux-gnueabihf-gcc --with-shared --host=arm-linux-gnueabihf --with-build-cpp=arm-linux-gnueabihf-g++
	&& make



# arc tool
# It makes a lot more sense to run this from your host
RUN apt-get update && apt-get install -y \
 git php5-cli php5-curl libssl-dev vim-tiny \
 && apt-get clean
RUN mkdir /php && cd /php \
 && git clone https://github.com/phacility/libphutil.git \
 && git clone https://github.com/phacility/arcanist.git

# for building the ghc manual
#RUN apt-get update \
# && apt-get install -y dblatex docbook-xsl docbook-utils \
# && apt-get clean \
# && /usr/local/bin/clean.sh

ENV LANG     C.UTF-8
ENV LC_ALL   C.UTF-8
ENV LANGUAGE C.UTF-8

RUN useradd -m -d /home/ghc -s /bin/bash ghc
RUN echo "ghc ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ghc && chmod 0440 /etc/sudoers.d/ghc
ENV HOME /home/ghc
WORKDIR /home/ghc
USER ghc

ENV PATH /opt/toolchain/gcc-linaro-arm-linux-gnueabihf/bin:/opt/ghc/7.8.4/bin:/php/arcanist/bin:$PATH 
