#!/bin/bash

#
# Need:
# - base install of GHC (to bootstrap)
# - wrapper commands generated
#

pushd ghc-*

export PATH=$PWD/../wrapper:$PATH
export PATH=/usr/local/opt/llvm/bin:$PATH
export LIBFFI=/Users/ewebb/src/build-ghc/libffi/build/Release-iphoneos

make clean
make distclean

sed -E "s/^#(BuildFlavour[ ]+= quick-cross)$/\1/" \
    mk/build.mk.sample > mk/build.mk

./boot

./configure --target=aarch64-apple-ios \
              --disable-large-address-space \
              --with-ffi-includes=$LIBFFI/include \
              --with-ffi-libraries=$LIBFFI

read -p 'Press Enter:'

make -j

