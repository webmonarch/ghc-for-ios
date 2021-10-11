Cross Compile GHC for iOS
=========================

Here are notes and scripts on cross compiling GHC for iOS, 
with the intent of developing iOS apps using Haskell.

### TODO

- [ ] Build and run on device
- [ ] How to clear allocated memory

### Broad Strokes

1. Install base deps
   1. xcode
   2. `brew install ghc llvm cabal-install`
2. Build libffi for iOS
3. Build GHC
    1. Setup build tool aliases for autotools

### Base Deps

* Mac with xcode
* GHC (to bootstrap with)
* llvm
* cabal-install

Questions

* alex
  * provided with source distributions, if we used GIT, we would need to install these
* happy
  * provided with source distributions, if we used GIT, we would need to install these
* Patched 
  * `execToWritable`
  * `clock_getcpuclockid`
  * `llvm_targets`

### Compiling Haskell Library

```bash
mkdir -p build/hs-libs/x86_64
./build/dist/x86_64-apple-ios/bin/x86_64-apple-ios-ghc \
  -odir build/hs-libs/x86_64/ \
  -hidir build/hs-libs/x86_64/ \
  -stubdir build/hs-libs/x86_64/ \
  -lffi -Lbuild/dist/x86_64-apple-ios/lib \
  -staticlib -o build/hs-libs/x86_64/libhs.a \
  test/haskell-project/Lib.hs
```

### Setup XCode Project

* add library
* add `libiconv.tbd`

### Links

References:

* https://medium.com/@zw3rk/a-haskell-cross-compiler-for-ios-7cc009abe208
* https://github.com/nanotech/swift-haskell-tutorial/blob/master/README.md
* https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/shared_libs.html
* https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/9.0.1-notes.html#highlights
* https://github.com/zw3rk/toolchain-wrapper
