#!/bin/sh
echo "Testing for CMake"
which cmake
if test "$?" -ne 0; then
    echo "[error]: Not found: cmake"
    echo "[error]: Please install CMake"
    exit 1
fi

THIS_DIR=`pwd`
WORKING_DIR=$1
if [ -z $WORKING_DIR ]; then
    echo "[error]: Please set working directory"
    echo "Usage: cmake_build.sh <path_to_working_directory>"
    exit 1
fi
PACKAGE_DIR=$THIS_DIR/packages
MG_CPU=32
MG_ARCH=x86
if [ "$2" = "64" ]; then
    MG_CPU=64
    MG_ARCH=x64
fi
if [ ! -d $WORKING_DIR/${MG_ARCH}_release ]; then
    mkdir -p $WORKING_DIR/${MG_ARCH}_release
fi
if [ ! -d $PACKAGE_DIR ]; then
    mkdir -p $PACKAGE_DIR
fi

cd $WORKING_DIR/${MG_ARCH}_release
if test "$?" -ne 0; then
    exit 1
fi
cmake -DCMAKE_BUILD_TYPE=Release -DMG_CPU=$MG_CPU -DWITH_JAVA=1 -DWITH_DOTNET=1 -DWITH_PHP=1 $THIS_DIR
if test "$?" -ne 0; then
    exit 1
fi
cmake --build . --config Release
if test "$?" -ne 0; then
    exit 1
fi