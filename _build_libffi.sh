#!/bin/bash

git clone https://github.com/libffi/libffi.git

pushd libffi

#xcodebuild -configuration Debug -target libffi-iOS -arch x86_64 -sdk iphonesimulator
xcodebuild -configuration Release -target libffi-iOS -arch arm64 -sdk iphoneos
