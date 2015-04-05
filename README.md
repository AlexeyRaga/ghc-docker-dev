# A docker container for hacking on GHC

This is on the docker registry as `ghc--dev`.
To use, mount your GHC source code into /home/ghc

    sudo docker run --rm -i -t -v `pwd`:/home/ghc alexeyraga/ghc-dev /bin/bash

You are now ready to compile GHC!

