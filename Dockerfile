# mount the GHC source code into /home/ghc
#
#    sudo docker run --rm -i -t -v `pwd`:/home/ghc alexeyraga/ghc-dev /bin/bash
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


RUN apt-get update \
 && apt-get install ${OPTS_APT} \
            wget bzip2 xz-utils git \
            patch less \
            make ghc llvm \
            alex cabal-install happy \
            sudo \
 && apt-get clean \
 && /usr/local/bin/clean.sh

ENV LANG     C.UTF-8
ENV LC_ALL   C.UTF-8
ENV LANGUAGE C.UTF-8

RUN useradd -m -d /home/ghc -s /bin/bash ghc
RUN echo "ghc ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ghc && chmod 0440 /etc/sudoers.d/ghc
ENV HOME /home/ghc
WORKDIR /home/ghc
USER ghc

