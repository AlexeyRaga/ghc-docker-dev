# mount the GHC source code into /home/ghc
#
#    sudo docker run --rm -i -t -v `pwd`:/home/ghc alexeyraga/ghc-cross-arm-distributed-process /bin/bash
#

FROM alexeyraga/ghc-docker-cross-arm:latest
MAINTAINER Alexey Raga

## disable prompts from apt
ENV DEBIAN_FRONTEND noninteractive

RUN cabal update

RUN cabal-arm install "data-accessor" 
RUN cabal-arm install "text" 
RUN cabal-arm install "rank1dynamic" 
RUN cabal-arm install "random" 
RUN cabal-arm install "hashable" 
RUN cabal-arm install "network-transport" 
RUN cabal-arm install "transformers" 
RUN cabal-arm install "mtl" 
RUN cabal-arm install "stm" 
RUN cabal-arm install "syb" 
RUN cabal-arm install "distributed-static" 
RUN cabal-arm install "distributed-process" 
RUN cabal-arm install "network"
RUN cabal-arm install "network-transport-tcp"
