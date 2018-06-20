#!/bin/bash

MG_VER_MAJOR=$1
MG_VER_MINOR=$2
MG_VER_REV=$3
MG_VER_BUILD=$4
MG_ARCH=amd64

SRC_AREA=~/mapguide_build
CMAKE_BUILD_AREA=~/mapguide_build_cmake

sudo apt-get update && sudo apt-get install -y build-essential git wget cmake dos2unix p7zip-full libpcre3-dev
git clone --depth 1 https://github.com/jumpinjackie/mapguide-api-bindings $SRC_AREA

# Install .net Core SDK
wget -q https://packages.microsoft.com/config/ubuntu/14.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get install -y apt-transport-https && sudo apt-get update && sudo apt-get install -y dotnet-sdk-2.1
# We don't need to download the full set of MapGuide packages, this should be sufficient
for pkg in platformbase common webextensions
do
    wget -q https://download.osgeo.org/mapguide/releases/$MG_VER_MAJOR.$MG_VER_MINOR.$MG_VER_REV/Final/ubuntu14_x64/mapguideopensource-${pkg}_$MG_VER_MAJOR.$MG_VER_MINOR.$MG_VER_REV-${MG_VER_BUILD}_${MG_ARCH}.deb
    sudo dpkg -i mapguideopensource-${pkg}_$MG_VER_MAJOR.$MG_VER_MINOR.$MG_VER_REV-${MG_VER_BUILD}_${MG_ARCH}.deb
done
cd $SRC_AREA
./envsetupsdk.sh --with-dotnet --version $MG_VER_MAJOR.$MG_VER_MINOR.$MG_VER_REV.$MG_VER_BUILD
mkdir -p $CMAKE_BUILD_AREA
cd $CMAKE_BUILD_AREA
cmake -DCMAKE_BUILD_TYPE=Release -DMG_VERSION_MAJOR=$MG_VER_MAJOR -DMG_VERSION_MINOR=$MG_VER_MINOR -DMG_VERSION_PATCH=$MG_VER_REV -DMG_CPU=64 -DWITH_JAVA=1 -DWITH_PHP=0 -DWITH_DOTNET=1 $SRC_AREA
make