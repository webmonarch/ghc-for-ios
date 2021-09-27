#!/bin/bash

set -e
set -x

# build libffi

git clone https://github.com/libffi/libffi.git


GHC_SRC_URL=https://downloads.haskell.org/~ghc/8.10.7/ghc-8.10.7-src.tar.xz
GHC_SRC_DIR=$(basename ${GHC_SRC_URL} -src.tar.xz)

#wget -c ${GHC_SRC_URL}
#tar xvf $(basename ${GHC_SRC_URL})

pushd ${GHC_SRC_DIR}