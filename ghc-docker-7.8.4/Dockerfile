# mount the GHC source code into /home/ghc
#
#    sudo docker run --rm -i -t -v `pwd`:/home/ghc alexeyraga/ghc-docker-dev /bin/bash
#
# darinmorrison/haskell
# Look here on how to kick off your first build:
# https://ghc.haskell.org/trac/ghc/wiki/Building/Hacking

FROM debian:testing
MAINTAINER Alexey Raga

## disable prompts from apt
ENV DEBIAN_FRONTEND noninteractive

## custom apt-get install options
ENV OPTS_APT        -y --force-yes --no-install-recommends

ADD ./01_nodoc /etc/dpkg/dpkg.cfg.d/01_nodoc
ADD ./02nocache /etc/apt/apt.conf.d/02nocache
ADD ./clean.sh /usr/local/bin/clean.sh
RUN chown root.root /usr/local/bin/clean.sh && chmod 700 /usr/local/bin/clean.sh

## add ppa for ubuntu trusty haskell packages
# from darinmorrison/haskell
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F6F88286 \
 && echo 'deb     http://ppa.launchpad.net/hvr/ghc/ubuntu trusty main' >> /etc/apt/sources.list.d/haskell.list \
 && echo 'deb-src http://ppa.launchpad.net/hvr/ghc/ubuntu trusty main' >> /etc/apt/sources.list.d/haskell.list

RUN apt-get update \
 && apt-get install ${OPTS_APT} \
 			wget xz-utils git \
 			libtinfo5 libgmp-dev ncurses-dev \
 			autoconf automake libtool make g++ llvm-3.4-dev python bzip2 ca-certificates \
 			ghc-7.8.4 \
 			alex \
 			cabal-install-1.22 \
 			happy \
 			sudo xutils-dev \
 && apt-get clean \
 && /usr/local/bin/clean.sh

# arc tool
# It makes a lot more sense to run this from your host
# RUN apt-get update \
#  && apt-get install ${OPTS_APT} \
#  	git php5-cli php5-curl libssl-dev vim-tiny \
#  && apt-get clean

# RUN mkdir /php && cd /php \
#  && git clone https://github.com/phacility/libphutil.git \
#  && git clone https://github.com/phacility/arcanist.git

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

ENV PATH /opt/ghc/7.8.4/bin:$PATH 
