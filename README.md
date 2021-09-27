Cross Compile GHC for iOS
=========================

Here are notes and scripts on cross compiling GHC for iOS, 
with the intent of developing iOS apps using Haskell.

### Broad Strokes

1. Install base deps
   1. `brew install ghc llvm cabal-install`
2. Build libffi for iOS
3. Build GHC
    1. Setup build tool aliases for autotools

### Base Deps

* Mac with xcode
* GHC (to bootstrap with)
* llvm

Questions

* alex
* happy
* patch 
  * `execToWritable`
  * `clock_getcpuclockid`
  * `llvm_targets`

### Links

References:

* https://medium.com/@zw3rk/a-haskell-cross-compiler-for-ios-7cc009abe208
* https://github.com/nanotech/swift-haskell-tutorial/blob/master/README.md
* https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/shared_libs.html
* https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/9.0.1-notes.html#highlights
* https://github.com/zw3rk/toolchain-wrapper
