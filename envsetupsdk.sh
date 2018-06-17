#!/bin/sh
MG_VERSION=3.1
SWIG_VER=3.0.12
ROOT=$PWD

install_swig()
{
    if [ ! -f downloads/swig-${SWIG_VER}.tar.gz ];
    then
        wget http://prdownloads.sourceforge.net/swig/swig-${SWIG_VER}.tar.gz -O downloads/swig-${SWIG_VER}.tar.gz
    fi
    if [ -d swig-${SWIG_VER} ]; 
    then
        rm -rf swig-${SWIG_VER}
    fi
    if [ -d swig ]; 
    then
        rm -rf swig
    fi
    mkdir swig
    tar -zxf downloads/swig-${SWIG_VER}.tar.gz
    cd swig-${SWIG_VER}
    ./configure --prefix=${ROOT}/swig && make && make install
}

echo "Checking for swig"
which swig
if test "$?" -ne 0; then
    echo "Could not find swig in the usual places. Checking for local install"
    if [ ! -f swig/bin/swig ] || [ ! -d swig/share/swig/${SWIG_VER} ]; then
        install_swig
    else
        echo "Found local copy of swig"
    fi
else
    echo "Found system-installed copy of swig"
fi

echo "Checking for: dos2unix"
which dos2unix
if test "$?" -ne 0; then
    echo "[error]: Not found: dos2unix"
    echo "[error]: Please install dos2unix"
    exit 1
fi

echo "Checking for: 7z"
which 7z
if test "$?" -ne 0; then
    echo "[error]: Not found: 7z"
    echo "[error]: Please install 7-zip"
    exit 1
fi

echo "Checking for MapGuide buildpack"
mkdir -p downloads
if [ ! -f downloads/mapguide-3.1-buildpack.7z ]; then
    wget https://github.com/jumpinjackie/mapguide-api-bindings/releases/download/v0.3/mapguide-3.1-buildpack.7z -O downloads/mapguide-3.1-buildpack.7z
fi

echo "Extracting buildpack"
7z x downloads/mapguide-3.1-buildpack.7z -osdk/$MG_VERSION
echo "Fixing line endings in buildpack headers"
find ./sdk/3.1/Inc -type f -print0 | xargs -0 dos2unix

echo "Checking for: javac"
which javac
if test "$?" -ne 0; then
    echo "[error]: Not found: javac"
    echo "[error]: Please install the Java SDK"
    exit 1
fi

if [ `uname -m` = "x86_64" ]; then
    echo "Checking for: dotnet"
    which dotnet
    if test "$?" -ne 0; then
        echo "[error]: Not found: dotnet"
        echo "[error]: Please install the .net Core SDK"
        exit 1
    fi
else
    echo "Skipping check for dotnet: Not a 64-bit OS"
fi