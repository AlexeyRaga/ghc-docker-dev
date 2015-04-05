# A docker container for hacking on GHC

This is on the docker registry as `ghc-docker-dev`.
To use, mount your GHC source code into /home/ghc

    sudo docker run --rm -i -t -v `pwd`:/home/ghc alexeyraga/ghc-docker-dev /bin/bash

You are now ready to compile GHC!
There is one final setup step to run once you have the image up:

