#!/bin/bash

set -e
set -x

# build libffi

git clone https://github.com/libffi/libffi.git


#tar xvf $(basename ${GHC_SRC_URL})

pushd ${GHC_SRC_DIR}
