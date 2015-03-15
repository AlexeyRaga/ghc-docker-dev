#!/bin/bash

cd /opt/ghc-cross/ghc-7.8.4
sed -i 's/^PACKAGES_STAGE1 += terminfo$/\#\0/g' ghc.mk
sed -i 's/^PACKAGES_STAGE1 += haskeline$/\#\0/g' ghc.mk

cp mk/build.mk.sample mk/build.mk
sed -i 's/^#\(BuildFlavour *= *quick-cross\)$/\1/g' mk/build.mk

./configure --target=arm-linux-gnueabihf --with-gcc=arm-linux-gnueabihf-gcc --enable-unregistered
make

