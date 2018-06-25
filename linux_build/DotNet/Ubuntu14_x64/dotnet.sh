#!/bin/bash

MG_VER_MAJOR=$1
MG_VER_MINOR=$2
MG_VER_REV=$3
MG_VER_BUILD=$4
MG_ARCH=amd64

SRC_AREA=~/mapguide_build
CMAKE_BUILD_AREA=~/mapguide_build_cmake

# Need xerces so we have its headers, which is needed by string out typemaps for .net. Buildpack does not include xerces headers because
# they have been "configure"'d for Win32
sudo apt-get update && sudo apt-get install -y zip build-essential git wget cmake dos2unix p7zip-full libpcre3-dev libxerces-c-dev
git clone --depth 1 https://github.com/jumpinjackie/mapguide-api-bindings $SRC_AREA

# Install .net Core SDK
wget -q https://packages.microsoft.com/config/ubuntu/14.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get install -y apt-transport-https && sudo apt-get update && sudo apt-get install -y dotnet-sdk-2.1
wget -q https://download.osgeo.org/mapguide/releases/$MG_VER_MAJOR.$MG_VER_MINOR.$MG_VER_REV/Final/ubuntu14_x64/mginstallubuntu.sh
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
echo "Copying java glue library"
cp $SRC_AREA/packages/Java/Release/x64/Ubuntu14.04.x86_64/libMapGuideJavaApi.so /mapguide_sources/packages/Java/Release/x64/Ubuntu14.04.x86_64
echo "Copying .net glue library"
cp $SRC_AREA/src/Bindings/DotNet/MapGuideDotNetApi/runtimes/ubuntu.14.04-x64/libMapGuideDotNetUnmanagedApi.so /mapguide_sources/src/Bindings/DotNet/MapGuideDotNetApi/runtimes/ubuntu.14.04-x64