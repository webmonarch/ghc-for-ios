Cross Compile GHC for iOS
=========================

Scripts and notes on cross-compiling [The Glasgow Haskell Compiler](https://www.haskell.org/ghc/) targeting iOS
(device [aarch64/arm64] and simulator [x86_64]) with the goal of writing iOS applications in (largely) Haskell.

## Why

As Apple goes farther and farther into custom silicon, LLVM/bitcode, Swift and other requirements for iOS applications,
GHC's built-in support for iOS is getting weaker and weaker. There seems to have been a flurry of interest around using 
Haskell on iOS around 2017, but I had a hard time finding more recent resources.

I am trying to see if I can create a non-trivial application in (largely) Haskell that Apple will accept on the iOS 
App Store.

The landscape will likely change very soon with the M1 chip and everything needing to support the LLVM/Clang/aarch64 
toolchain if they want to run on new Macs.

## Why Haskell

The farther into my career I get, the more I appreciate typed programming languages. 
Also, working with more and more programming languages, they are all kinda doing the same thing in different ways.
Let's just use one language.

## Getting Started

Overall, we are:

1. Installing dependencies
2. Setup toolchain wrappers for use by GHC's autotools/make
3. Cross-compiling GHC for device (aarch64/arm64) and iOS simulator (x86_64)
4. Building Haskell lib for use by XCode/Swift iOS app
5. Setup Xcode/Swift project to use build Haskell library
6. Run on simulator!
7. Run on device!

### Dependencies

* Need Xcode (developed on Xcode 13.0 / macOS Big Sur)
* Install Homebrew deps

```bash
# llvm toolchain (opt, llc) used by GHC. Any modern version should work
brew install llvm

# base GHC installation to bootstrap the cross-compilation of GHC
brew install ghc cabal-install
```

### Setup Toolchain

We create a set of specially named wrapper scripts (naming convention used by autotools) which delegates to Xcode's 
`xcrun`.

```bash
# create wrapper scripts and soft-links
./start toolchain

# add toolchain wrappers to PATH
# export PATH=$PWD/build/toolchain:$PATH
eval "$(./start bash)"
```

### Build GHC

```bash
./start ghc download
./start ghc patch
./start ghc prepare 2>&1 | tee prepare.$(date +%F_%T).log
./start ghc build 2>&1 | tee build.$(date +%F_%T).log
```

### Build Haskell Library

```bash
./start haskell all
```

### Setup Xcode Project

1. Create Swift/SwiftUI iOS App
2. Add bridging header
3. Add external references to bridging header
4. Init Haskell in `App.init`
5. Add "Other Linker Flags": `-lhs`
6. Add "Library Search Paths": `$(SRCROOT)/<PATH>/build/hs-libs/$(CURRENT_ARCH)`
7. Add `libiconv.tbd` to Frameworks

### Run!

Press play!


## Links

References:

* https://medium.com/@zw3rk/a-haskell-cross-compiler-for-ios-7cc009abe208
* https://github.com/nanotech/swift-haskell-tutorial/blob/master/README.md
* https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/shared_libs.html
* https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/9.0.1-notes.html#highlights
* https://github.com/zw3rk/toolchain-wrapper
* https://medium.com/@zw3rk/ghcs-cross-compilation-pipeline-ac88972466ec
* [Rust on iOS](https://medium.com/visly/rust-on-ios-39f799b3c1dd)

## TODO

- [x] Build and run on simulator
- [x] Build and run on device
- [ ] How to clear allocated memory
- [ ] Parameterize which version to build (x86_64 vs aarch64)
- [ ] Will Apple accept an Haskell project?
- [ ] Create 'all' targets to do everything
- [ ] Do we need libffi anymore?
- [ ] Add test suite
- [ ] explain aarch64 and arm64

Debugging afterwards

```bash
pushd build/ghc-8.10.7
make -kj
make -j1 2>&1 | subl
```

-----

# 

## Open Questions

* alex
  * provided with source distributions, if we used GIT, we would need to install these
* happy
  * provided with source distributions, if we used GIT, we would need to install these
* Patched 
  * `execToWritable`
  * `clock_getcpuclockid`
  * `llvm_targets`


### Debugging Bitcode

Trying to figure out where to put bitcode flags in this massive Makefile situation...

# utils/hp2ps/dist-install/build/AreaBelow.o w/o Bitcode

command rm utils/hp2ps/dist-install/build/AreaBelow.o
make -pdC utils/hp2ps 2>&1 | tee debug.log

> #  commands to execute (from `utils/hp2ps/ghc.mk', line 44):
> 	$(call cmd,utils/hp2ps_dist-install_CC) $(utils/hp2ps_dist-install_$(utils/hp2ps_dist-install_PROGRAM_WAY)_ALL_CC_OPTS) -c $< -o $@

$(utils/hp2ps_dist-install_CC) = $(CC_STAGE1)
$(CC_STAGE1) = $(CC)

$(utils/hp2ps_dist-install_$(utils/hp2ps_dist-install_PROGRAM_WAY)_ALL_CC_OPTS)

$(utils/hp2ps_dist-install_PROGRAM_WAY) = v

utils/hp2ps_dist-install_v_ALL_CC_OPTS = 
    $(WAY_$(utils/hp2ps_dist-install_PROGRAM_WAY)_CC_OPTS) 
    $(utils/hp2ps_dist-install_DIST_GCC_CC_OPTS) 
    $(utils/hp2ps_dist-install_$(utils/hp2ps_dist-install_PROGRAM_WAY)_CC_OPTS) 
    $($(basename $<)_CC_OPTS) 
    $(utils/hp2ps_dist-install_EXTRA_CC_OPTS) 
    $(EXTRA_CC_OPTS) 
    $(if $(findstring YES,$(utils/hp2ps_dist-install_SplitSections)),-ffunction-sections -fdata-sections)

utils/hp2ps_dist-install_$(utils/hp2ps_dist-install_PROGRAM_WAY)_CC_OPTS 
    = utils/hp2ps_dist-install_v_CC_OPTS
    = 

WAY_$(utils/hp2ps_dist-install_PROGRAM_WAY)_CC_OPTS =
    WAY_v_CC_OPTS =



# utils/unlit/dist-install/build/unlit.o w/o Bitcode

$(call cmd,utils/unlit_dist-install_CC) 
    $(utils/unlit_dist-install_$(utils/unlit_dist-install_PROGRAM_WAY)_ALL_CC_OPTS) 
    -c $< -o $@


utils/unlit_dist-install_$(utils/unlit_dist-install_PROGRAM_WAY)_ALL_CC_OPTS 
    = utils/unlit_dist-install_v_ALL_CC_OPTS
    = $(WAY_$(utils/unlit_dist-install_PROGRAM_WAY)_CC_OPTS) 
      $(utils/unlit_dist-install_DIST_GCC_CC_OPTS) 
      $(utils/unlit_dist-install_$(utils/unlit_dist-install_PROGRAM_WAY)_CC_OPTS) 
      $($(basename $<)_CC_OPTS) 
      $(utils/unlit_dist-install_EXTRA_CC_OPTS) 
      $(EXTRA_CC_OPTS) 
      $(if $(findstring YES,$(utils/unlit_dist-install_SplitSections)),-ffunction-sections -fdata-sections)

$(utils/unlit_dist-install_$(utils/unlit_dist-install_PROGRAM_WAY)_CC_OPTS) 
    = utils/unlit_dist-install_v_CC_OPTS


# utils/hsc2hs/dist-install/build/cbits/utils.o w/o Bitcode



utils/hsc2hs_dist-install_$(utils/hsc2hs_dist-install_PROGRAM_WAY)_ALL_CC_OPTS
    = utils/hsc2hs_dist-install_v_ALL_CC_OPTS

# libraries/base/dist-install/build/libHSbase-4.14.3.0.a(IO.o) w/o Bitcode

"inplace/bin/ghc-stage1" 
    -o utils/hsc2hs/dist-install/build/tmp/hsc2hs 
    -hisuf hi -osuf  o -hcsuf hc -static  -O0 -H64m -Wall      
    -hide-all-packages -package-env - 
    -i -iutils/hsc2hs/. -iutils/hsc2hs/dist-install/build -Iutils/hsc2hs/dist-install/build -iutils/hsc2hs/dist-install/build/hsc2hs/autogen -Iutils/hsc2hs/dist-install/build/hsc2hs/autogen     -optP-include -optPutils/hsc2hs/dist-install/build/hsc2hs/autogen/cabal_macros.h 
    -package-id base-4.14.3.0 
    -package-id containers-0.6.5.1 
    -package-id directory-1.3.6.0 
    -package-id filepath-1.4.2.1 
    -package-id process-1.6.13.2 
    -Wall -XHaskell2010  -no-user-package-db -rtsopts       -Wnoncanonical-monad-instances  -outputdir utils/hsc2hs/dist-install/build    -static  -O0 -H64m -Wall      -hide-all-packages -package-env - -i -iutils/hsc2hs/. -iutils/hsc2hs/dist-install/build -Iutils/hsc2hs/dist-install/build -iutils/hsc2hs/dist-install/build/hsc2hs/autogen -Iutils/hsc2hs/dist-install/build/hsc2hs/autogen     -optP-include -optPutils/hsc2hs/dist-install/build/hsc2hs/autogen/cabal_macros.h -package-id base-4.14.3.0 -package-id containers-0.6.5.1 -package-id directory-1.3.6.0 -package-id filepath-1.4.2.1 -package-id process-1.6.13.2 -Wall -XHaskell2010  -no-user-package-db -rtsopts       -Wnoncanonical-monad-instances  utils/hsc2hs/dist-install/build/Main.o utils/hsc2hs/dist-install/build/C.o utils/hsc2hs/dist-install/build/Common.o utils/hsc2hs/dist-install/build/CrossCodegen.o utils/hsc2hs/dist-install/build/DirectCodegen.o utils/hsc2hs/dist-install/build/Flags.o utils/hsc2hs/dist-install/build/HSCParser.o utils/hsc2hs/dist-install/build/ATTParser.o utils/hsc2hs/dist-install/build/UtilsCodegen.o utils/hsc2hs/dist-install/build/Compat/ResponseFile.o utils/hsc2hs/dist-install/build/Compat/TempFile.o utils/hsc2hs/dist-install/build/Paths_hsc2hs.o utils/hsc2hs/dist-install/build/cbits/utils.o   

libraries/base/dist-install/build/libHSbase-4.14.3.0.a.contents
command rm \
    libraries/base/dist-install/build/GHC/Conc/IO.o \
    libraries/base/dist-install/build/GHC/IO.o \
    libraries/base/dist-install/build/System/IO.o

"inplace/bin/ghc-stage1" -hisuf hi -osuf  o -hcsuf hc -static  -O0 -H64m -Wall      -this-unit-id base-4.14.3.0 -hide-all-packages -package-env - -i -ilibraries/base/. -ilibraries/base/dist-install/build -Ilibraries/base/dist-install/build -ilibraries/base/dist-install/build/./autogen -Ilibraries/base/dist-install/build/./autogen -Ilibraries/base/include -Ilibraries/base/dist-install/build/include    -optP-include -optPlibraries/base/dist-install/build/./autogen/cabal_macros.h -package-id ghc-prim-0.6.1 -package-id integer-simple-0.1.2.0 -package-id rts -this-unit-id base -Wcompat -Wnoncanonical-monad-instances -XHaskell2010 -O -fllvm  -no-user-package-db -rtsopts  -Wno-trustworthy-safe -Wno-deprecated-flags     -Wnoncanonical-monad-instances  -outputdir libraries/base/dist-install/build   -c libraries/base/./GHC/IO.hs -v -o libraries/base/dist-install/build/GHC/IO.o 

"inplace/bin/ghc-stage1" -hisuf hi -osuf  o -hcsuf hc -static  -O0 -H64m -Wall      -this-unit-id base-4.14.3.0 -hide-all-packages -package-env - -i -ilibraries/base/. -ilibraries/base/dist-install/build -Ilibraries/base/dist-install/build -ilibraries/base/dist-install/build/./autogen -Ilibraries/base/dist-install/build/./autogen -Ilibraries/base/include -Ilibraries/base/dist-install/build/include    -optP-include -optPlibraries/base/dist-install/build/./autogen/cabal_macros.h -package-id ghc-prim-0.6.1 -package-id integer-simple-0.1.2.0 -package-id rts -this-unit-id base -Wcompat -Wnoncanonical-monad-instances -XHaskell2010 -O -fllvm  -no-user-package-db -rtsopts  -Wno-trustworthy-safe -Wno-deprecated-flags     -Wnoncanonical-monad-instances  -outputdir libraries/base/dist-install/build   -c libraries/base/./GHC/Conc/IO.hs -v -o libraries/base/dist-install/build/GHC/Conc/IO.o 

"inplace/bin/ghc-stage1" -hisuf hi -osuf  o -hcsuf hc -static  -O0 -H64m -Wall      -this-unit-id base-4.14.3.0 -hide-all-packages -package-env - -i -ilibraries/base/. -ilibraries/base/dist-install/build -Ilibraries/base/dist-install/build -ilibraries/base/dist-install/build/./autogen -Ilibraries/base/dist-install/build/./autogen -Ilibraries/base/include -Ilibraries/base/dist-install/build/include    -optP-include -optPlibraries/base/dist-install/build/./autogen/cabal_macros.h -package-id ghc-prim-0.6.1 -package-id integer-simple-0.1.2.0 -package-id rts -this-unit-id base -Wcompat -Wnoncanonical-monad-instances -XHaskell2010 -O -fllvm  -no-user-package-db -rtsopts  -Wno-trustworthy-safe -Wno-deprecated-flags     -Wnoncanonical-monad-instances  -outputdir libraries/base/dist-install/build   -c libraries/base/./System/IO.hs -v -o libraries/base/dist-install/build/System/IO.o 


"inplace/bin/ghc-stage1" -hisuf hi -osuf  o -hcsuf hc -static  -O0 -H64m -Wall      -this-unit-id base-4.14.3.0 -hide-all-packages -package-env - -i -ilibraries/base/. -ilibraries/base/dist-install/build -Ilibraries/base/dist-install/build -ilibraries/base/dist-install/build/./autogen -Ilibraries/base/dist-install/build/./autogen -Ilibraries/base/include -Ilibraries/base/dist-install/build/include    -optP-include -optPlibraries/base/dist-install/build/./autogen/cabal_macros.h -package-id ghc-prim-0.6.1 -package-id integer-simple-0.1.2.0 -package-id rts -this-unit-id base -Wcompat -Wnoncanonical-monad-instances -XHaskell2010 -O -fllvm  -no-user-package-db -rtsopts  -Wno-trustworthy-safe -Wno-deprecated-flags     -Wnoncanonical-monad-instances  -outputdir libraries/base/dist-install/build   -c libraries/base/./GHC/Conc/IO.hs -v -o libraries/base/dist-install/build/GHC/Conc/IO.o 


command rm libraries/base/dist-install/build/GHC/Conc/IO.o
"inplace/bin/ghc-stage1" -hisuf hi -osuf  o -hcsuf hc -static  -O0 -H64m -Wall      -this-unit-id base-4.14.3.0 -hide-all-packages -package-env - -i -ilibraries/base/. -ilibraries/base/dist-install/build -Ilibraries/base/dist-install/build -ilibraries/base/dist-install/build/./autogen -Ilibraries/base/dist-install/build/./autogen -Ilibraries/base/include -Ilibraries/base/dist-install/build/include    -optP-include -optPlibraries/base/dist-install/build/./autogen/cabal_macros.h -package-id ghc-prim-0.6.1 -package-id integer-simple-0.1.2.0 -package-id rts -this-unit-id base -Wcompat -Wnoncanonical-monad-instances -XHaskell2010 -O -fllvm  -no-user-package-db -rtsopts  -Wno-trustworthy-safe -Wno-deprecated-flags     -Wnoncanonical-monad-instances  -outputdir libraries/base/dist-install/build   -c libraries/base/./GHC/Conc/IO.hs -v -o libraries/base/dist-install/build/GHC/Conc/IO.o 2>&1 | subl -w

# rts/dist/build/libCffi.a
# libffi/build/inst/lib/libffi.a

