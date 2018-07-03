#!/bin/bash

MG_VER_MAJOR=$1
MG_VER_MINOR=$2
MG_VER_REV=$3
MG_VER_BUILD=$4
MG_ARCH=amd64

SRC_AREA=~/mapguide_build
CMAKE_BUILD_AREA=~/mapguide_build_cmake

git clone --depth 1 https://github.com/jumpinjackie/mapguide-api-bindings $SRC_AREA

#DOWNLOAD_URL=http://192.168.0.2/releases/$MG_VER_MAJOR.$MG_VER_MINOR.$MG_VER_REV/Final/ubuntu14_x64/mginstallubuntu.sh
DOWNLOAD_URL=http://download.osgeo.org/mapguide/releases/$MG_VER_MAJOR.$MG_VER_MINOR.$MG_VER_REV/Final/ubuntu14_x64/mginstallubuntu.sh
echo "Going to download: $DOWNLOAD_URL"
wget -q $DOWNLOAD_URL
chmod +x mginstallubuntu.sh
sudo ./mginstallubuntu.sh --headless --with-sdf --with-shp --with-sqlite
if test "$?" -ne 0; then
    exit 1
fi
cd $SRC_AREA
./build_tools.sh
./envsetupsdk.sh --with-dotnet --with-java --version $MG_VER_MAJOR.$MG_VER_MINOR.$MG_VER_REV.$MG_VER_BUILD
if test "$?" -ne 0; then
    exit 1
fi
mkdir -p $CMAKE_BUILD_AREA
./cmake_build.sh --with-dotnet --with-java --version $MG_VER_MAJOR.$MG_VER_MINOR.$MG_VER_REV.$MG_VER_BUILD --cpu 64 --working-dir $CMAKE_BUILD_AREA
if test "$?" -ne 0; then
    exit 1
fi
./test_dotnet.sh
if test "$?" -ne 0; then
    exit 1
fi
./test_java.sh
if test "$?" -ne 0; then
    exit 1
fi
echo "Copying java glue library"
cp $SRC_AREA/packages/Java/Release/x64/Ubuntu14.04.x86_64/libMapGuideJavaApi.so /mapguide_sources/packages/Java/Release/x64/Ubuntu14.04.x86_64
echo "Copying .net glue library"
cp $SRC_AREA/src/Managed/DotNet/MapGuideDotNetApi/runtimes/ubuntu.14.04-x64/native/libMapGuideDotNetUnmanagedApi.so /mapguide_sources/src/Managed/DotNet/MapGuideDotNetApi/runtimes/ubuntu.14.04-x64/native