#!/bin/sh
ROOT=$PWD
BUILD_AREA=/tmp/build/mapguide-api-bindings-tools
MG_TOOL_SRC_PATH=$ROOT/src/Tools
if [ ! -d "$BUILD_AREA" ]; then
    mkdir -p "$BUILD_AREA"
fi
cd "$BUILD_AREA"
# Test for CMake
which cmake
if test "$?" -ne 0; then
    echo "CMake not found. Cannot continue"
    exit 1
fi
cmake -DCMAKE_BUILD_TYPE=Release $MG_TOOL_SRC_PATH
if test "$?" -ne 0; then
    exit 1
fi
cmake --build . --config Release
if test "$?" -ne 0; then
    exit 1
fi
