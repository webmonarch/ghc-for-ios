#!/bin/bash

set -e

WRAPPER_DIR=./wrapper
WRAPPER_SH=wrapper

rm -rf ${WRAPPER_DIR} || true
mkdir ${WRAPPER_DIR} || true

pushd ${WRAPPER_DIR}

cat << 'EOF' > ${WRAPPER_SH}
#!/bin/bash
name=${0##*/}
cmd=${name##*-}
target=${name%-*}
case $name in
 *-cabal)
  fcommon="--builddir=dist/${target}"
  fcompile=" --with-ghc=${target}-ghc"
  fcompile+=" --with-ghc-pkg=${target}-ghc-pkg"
  fcompile+=" --with-gcc=${target}-clang"
  fcompile+=" --with-ld=${target}-ld"
  fcompile+=" --hsc2hs-options=--cross-compile"
  fconfig="--disable-shared --configure-option=--host=${target}"
  case $1 in
   configure|install) flags="${fcommon} ${fcompile} ${fconfig}" ;;
   build)             flags="${fcommon} ${fcompile}" ;;
   list|info|update)  flags="" ;;
   "")                flags="" ;;
   *)                 flags=$fcommon ;;
  esac
  ;;
 aarch64-apple-ios-clang|aarch64-apple-ios-ld)
  flags="--sdk iphoneos ${cmd} -arch arm64"
  cmd="xcrun"
  ;;
 aarch64-apple-ios-*|aarch64-apple-ios-*)
  flags="--sdk iphoneos ${cmd}"
  cmd="xcrun"
  ;;
 x86_64-apple-ios-clang|x86_64-apple-ios-ld)
  flags="--sdk iphonesimulator ${cmd} -arch x86_64"
  cmd="xcrun"
  ;;
 x86_64-apple-ios-*)
  flags="--sdk iphonesimulator ${cmd}"
  cmd="xcrun"
  ;;
 # default
 *-nm|*-ar|*-ranlib) ;;
 *) echo "Unknown command: ${0##*/}" >&2; exit 1;;
esac
exec $cmd $flags "$@"
EOF

chmod +x ${WRAPPER_SH}

for target in aarch64-apple-ios x86_64-apple-ios; do
  for command in clang ld ld.gold nm ar ranlib cabal; do
    ln -s ${WRAPPER_SH} $target-$command
  done
done
