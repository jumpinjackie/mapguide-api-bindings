#!/bin/bash

MG_VER_MAJOR=$1
MG_VER_MINOR=$2
MG_VER_REV=$3
MG_VER_BUILD=$4
MG_ARCH=amd64

SRC_AREA=~/mapguide_build
CMAKE_BUILD_AREA=~/mapguide_build_cmake

git clone --depth 1 https://github.com/jumpinjackie/mapguide-api-bindings $SRC_AREA

echo "Going to download: http://192.168.0.2/releases/$MG_VER_MAJOR.$MG_VER_MINOR.$MG_VER_REV/Final/centos6_x64/mginstallcentos.sh"
wget -q http://192.168.0.2/releases/$MG_VER_MAJOR.$MG_VER_MINOR.$MG_VER_REV/Final/centos6_x64/mginstallcentos.sh
chmod +x mginstallcentos.sh
sudo ./mginstallcentos.sh
if test "$?" -ne 0; then
    exit 1
fi
cd $SRC_AREA
./build_tools.sh
./envsetupsdk.sh --with-java --version $MG_VER_MAJOR.$MG_VER_MINOR.$MG_VER_REV.$MG_VER_BUILD
if test "$?" -ne 0; then
    exit 1
fi
mkdir -p $CMAKE_BUILD_AREA
./cmake_build.sh --with-java --version $MG_VER_MAJOR.$MG_VER_MINOR.$MG_VER_REV.$MG_VER_BUILD --cpu 64 --working-dir $CMAKE_BUILD_AREA
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
cp $SRC_AREA/packages/Java/Release/x64/CentOS6.9.x86_64/libMapGuideJavaApi.so /mapguide_sources/packages/Java/Release/x64/CentOS6.9.x86_64