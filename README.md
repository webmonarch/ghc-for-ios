Cross Compile GHC for iOS
=========================

Here are notes and scripts on cross compiling GHC for iOS, 
with the intent of developing iOS apps using Haskell.

### TODO

- [x] Build and run on simulator
- [ ] Build and run on device
- [ ] How to clear allocated memory
- [ ] Parameterize which version to build (x86_64 vs aarch64)
- [ ] Will Apple accept an Haskell project?
- [ ] create 'all' targets to do everything
- [ ] do we need libffi anymore?
- 

### Broad Strokes

1. Install base deps
   1. xcode
   2. `brew install ghc llvm cabal-install`
2. Build libffi for iOS
3. Build GHC
    1. Setup build tool aliases for autotools

To build

```bash
./start ghc download
./start ghc patch
./start ghc prepare 2>&1 | tee prepare.$(date +%F_%T).log
./start ghc build 2>&1 | tee build.$(date +%F_%T).log
```

Debugging afterwards

```bash
pushd build/ghc-8.10.7
make -kj
make -j1 2>&1 | subl
```

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
BUILD_OUT=build/hs-libs/x86_64 && \
command rm -rf build/hs-libs/x86_64 && \
mkdir -p ${BUILD_OUT} && \
./build/dist/x86_64-apple-ios/bin/x86_64-apple-ios-ghc \
  -odir build/hs-libs/x86_64/ \
  -hidir build/hs-libs/x86_64/ \
  -stubdir build/hs-libs/x86_64/ \
  -lffi -Lbuild/dist/x86_64-apple-ios/lib \
  -staticlib -o build/hs-libs/x86_64/libhs.a \
  test/haskell-project/Lib.hs

BUILD_OUT=build/hs-libs/arm64 && \
command rm -rf build/hs-libs/arm64 && \
mkdir -p ${BUILD_OUT} && \
./build/dist/aarch64-apple-ios/bin/aarch64-apple-ios-ghc \
  -v \
  -odir ${BUILD_OUT} \
  -hidir ${BUILD_OUT} \
  -stubdir ${BUILD_OUT} \
  -lffi -Lbuild/dist/aarch64-apple-ios/lib \
  -staticlib -o ${BUILD_OUT}/libhs.a \
  test/haskell-project/Lib.hs 2>&1 | subl -w
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
* https://medium.com/@zw3rk/ghcs-cross-compilation-pipeline-ac88972466ec


-----

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

