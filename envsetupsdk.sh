#!/bin/sh
SWIG_VER=3.0.12
ROOT=$PWD

USE_JAVA=0
USE_DOTNET=0
USE_PHP=0
MG_VER_MAJOR=1
MG_VER_MINOR=0
MG_VER_REV=0
MG_VER_BUILD=0
MG_VERSION=$MG_VER_MAJOR.$MG_VER_MINOR.$MG_VER_REV.$MG_VER_BUILD
MG_BUILDPACK_URL=

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
            echo "  --with-java [build with java support]"
            echo "  --with-dotnet [build with .net Core support]"
            echo "  --with-php [build with PHP support]"
            echo "  --help [Display usage]"
            exit
            ;;
    esac
    shift   # Check next set of parameters.
done

echo "MapGuide API: [$MG_VER_MAJOR.$MG_VER_MINOR.$MG_VER_REV.$MG_VER_BUILD]"
MG_VER_MAJOR_MINOR=$MG_VER_MAJOR.$MG_VER_MINOR
case $MG_VER_MAJOR_MINOR in
3.1)
    MG_BUILDPACK_URL=https://github.com/jumpinjackie/mapguide-api-bindings/releases/download/v0.3.1/mapguide-3.1-buildpack.7z
    ;;
*)
    echo "[error]: Don't know the buildpack URL for this version of MapGuide ($MG_VER_MAJOR_MINOR)"
    exit 1
esac

echo "Using buildpack URL: $MG_BUILDPACK_URL"

install_swig()
{
    if [ ! -f $ROOT/downloads/swig-${SWIG_VER}.tar.gz ];
    then
        echo "Downloading SWIG tarball"
        wget https://prdownloads.sourceforge.net/swig/swig-${SWIG_VER}.tar.gz -O $ROOT/downloads/swig-${SWIG_VER}.tar.gz
    fi
    if [ -d $ROOT/swig-${SWIG_VER} ]; 
    then
        rm -rf $ROOT/swig-${SWIG_VER}
    fi
    if [ -d $ROOT/swig ]; 
    then
        rm -rf $ROOT/swig
    fi
    mkdir -p $ROOT/swig
    tar -zxf $ROOT/downloads/swig-${SWIG_VER}.tar.gz
    cd $ROOT/swig-${SWIG_VER}
    ./configure --prefix=${ROOT}/swig && make && make install
}

echo "Checking for internal tools"
which tools/SwigPrepare
if test "$?" -ne 0; then
    echo "One or more internal tools not found. Run build_tools.sh"
    exit 1
fi
which tools/StampVer
if test "$?" -ne 0; then
    echo "One or more internal tools not found. Run build_tools.sh"
    exit 1
fi
which tools/PhpPostProcess
if test "$?" -ne 0; then
    echo "One or more internal tools not found. Run build_tools.sh"
    exit 1
fi

if [ ! -d $ROOT/downloads ]; then
    echo "Creating download directory"
    mkdir -p $ROOT/downloads
fi

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
if [ ! -f $ROOT/downloads/mapguide-$MG_VER_MAJOR.$MG_VER_MINOR-buildpack.7z ]; then
    wget $MG_BUILDPACK_URL -O $ROOT/downloads/mapguide-$MG_VER_MAJOR.$MG_VER_MINOR-buildpack.7z
fi

echo "Extracting buildpack"
7z x $ROOT/downloads/mapguide-3.1-buildpack.7z -aos -o$ROOT/sdk/$MG_VER_MAJOR.$MG_VER_MINOR
echo "Fixing line endings in buildpack headers"
find $ROOT/sdk/$MG_VER_MAJOR.$MG_VER_MINOR/Inc -type f -print0 | xargs -0 dos2unix

if [ "$USE_JAVA" = "1" ]; then
    echo "Checking for: javac"
    which javac
    if test "$?" -ne 0; then
        echo "[error]: Not found: javac"
        echo "[error]: Please install the Java SDK"
        exit 1
    fi
fi
if [ `uname -m` = "x86_64" ] && [ "$USE_DOTNET" = "1" ]; then
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

echo "Running SwigPrepare"
$ROOT/tools/SwigPrepare "$ROOT/sdk/$MG_VER_MAJOR.$MG_VER_MINOR" "$ROOT/sdk/$MG_VER_MAJOR.$MG_VER_MINOR" "$ROOT/src/Bindings/MapGuideApi"
if test "$?" -ne 0; then
    exit 1
fi
echo "Stamping version [$MG_VER_MAJOR.$MG_VER_MINOR.$MG_VER_REV.$MG_VER_BUILD]"
$ROOT/tools/StampVer $MG_VER_MAJOR $MG_VER_MINOR $MG_VER_REV $MG_VER_BUILD "$ROOT/src/Bindings/DotNet/MapGuideDotNetApi/Properties/AssemblyInfo.cs"  "$ROOT/src/Bindings/DotNet/MapGuideDotNetApi/MapGuideDotNetApi.csproj"
if test "$?" -ne 0; then
    exit 1
fi