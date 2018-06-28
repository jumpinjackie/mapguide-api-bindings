#!/bin/sh
USE_JAVA=0
USE_DOTNET=0
USE_PHP=0
WORKING_DIR=
MG_CPU=32
MG_ARCH=x86
DOTNET_RID=unknown
DISTRO=$(./get_distro.sh)
while [ $# -gt 0 ]; do    # Until you run out of parameters...
    case "$1" in
        --with-java)
            USE_JAVA=1
            ;;
        --with-dotnet)
            USE_DOTNET=1
            ;;
        --with-php)
            USE_PHP=1
            ;;
        --cpu)
            if [ "$2" = "64" ]; then
                MG_CPU=64
                MG_ARCH=x64
            fi
            shift
            ;;
        --working-dir)
            WORKING_DIR=$2
            shift
            ;;
        --version)
            MG_VERSION=$2
            MG_VER_MAJOR=`echo "$2" | cut -d "." -f 1`
            MG_VER_MINOR=`echo "$2" | cut -d "." -f 2`
            MG_VER_REV=`echo "$2" | cut -d "." -f 3`
            MG_VER_BUILD=`echo "$2" | cut -d "." -f 4`
            shift
            ;;
        --help)
            echo "Usage: $0 (options)"
            echo "Options:"
            echo "  --version [major.minor.rev.build]"
            echo "  --cpu [32|64]"
            echo "  --working-dir [build working directory]"
            echo "  --with-java [build with java support]"
            echo "  --with-dotnet [build with .net Core support]"
            echo "  --with-php [build with PHP support]"
            echo "  --help [Display usage]"
            exit
            ;;
    esac
    shift   # Check next set of parameters.
done

if [ -z $DISTRO ]; then
    DISTRO=linux-generic
    echo "[warning]: Could not determine distro, falling back to linux-generic"
fi

if test $USE_DOTNET -eq 1; then
    echo "Checking for dotnet CLI"
    which dotnet
    if test "$?" -ne 0; then
        exit 1
    fi
    DOTNET_RID=`dotnet --info | grep "RID:" | awk '{print $2}'`
fi

echo "Testing for CMake"
which cmake
if test "$?" -ne 0; then
    echo "[error]: Not found: cmake"
    echo "[error]: Please install CMake"
    exit 1
fi

THIS_DIR=`pwd`
if [ -z $WORKING_DIR ]; then
    echo "[error]: Please set working directory"
    echo "Usage: cmake_build.sh --working-dir <path_to_working_directory>"
    exit 1
fi
PACKAGE_DIR=$THIS_DIR/packages
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
cmake -DCMAKE_BUILD_TYPE=Release -DMG_DISTRO=$DISTRO -DMG_DOTNET_RID=$DOTNET_RID -DMG_CPU=$MG_CPU -DWITH_JAVA=$USE_JAVA -DWITH_DOTNET=$USE_DOTNET -DWITH_PHP=$USE_PHP $THIS_DIR
if test "$?" -ne 0; then
    exit 1
fi
make
if test "$?" -ne 0; then
    exit 1
fi
make install
if test "$?" -ne 0; then
    exit 1
fi
echo "Building Sample dataset"
cd $THIS_DIR/src/TestData/Samples/Sheboygan
./build.sh
if test "$?" -ne 0; then
    exit 1
fi
if test $USE_JAVA -eq 1; then
    if [ -f $THIS_DIR/packages/Java/Release/${MG_ARCH}/${DISTRO}/libMapGuideJavaApi.so ]; then
        echo "Stripping Java glue library"
        strip -s $THIS_DIR/packages/Java/Release/${MG_ARCH}/${DISTRO}/libMapGuideJavaApi.so
    else
        echo "No Java glue library found to strip"
    fi
fi
if test $USE_DOTNET -eq 1; then
    if [ -f $THIS_DIR/src/Bindings/DotNet/MapGuideDotNetApi/runtimes/${DOTNET_RID}/native/libMapGuideDotNetUnmanagedApi.so ]; then
        echo "Stripping .net glue library"
        strip -s $THIS_DIR/src/Bindings/DotNet/MapGuideDotNetApi/runtimes/${DOTNET_RID}/native/libMapGuideDotNetUnmanagedApi.so
    else
        echo "No .net glue library found to strip"
    fi
    cd $THIS_DIR/src/Bindings/DotNet/MapGuideDotNetApi
    dotnet restore
    if test "$?" -ne 0; then
        exit 1
    fi
    dotnet pack --configuration Release --output "$THIS_DIR/packages"
fi