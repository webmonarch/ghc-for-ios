#!/bin/bash

#
# Need:
# - base install of GHC (to bootstrap)
#

cd ghc-*

./boot

export LIBFFI=/Users/ewebb/src/build-ghc/libffi/build/Release-iphoneos

./configure --target=aarch64-apple-ios \
              --disable-large-address-space \
              --with-system-libffi \
              --with-ffi-includes=$LIBFFI/include \
              --with-ffi-libraries=$LIBFFI
