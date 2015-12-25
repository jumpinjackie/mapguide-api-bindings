#!/bin/sh
export MG_DEV_ROOT=$1
export MG_VER=$2
export MG_VER_FULL=$3

if [ ! -d swig ]; then
	./swigsetup.sh
fi
export SWIG_TOOL_PATH=$PWD/swig/bin
if [ ! -d src/MapGuide/MgDev ];
then
	echo "No symlink found. Making it, pointing to ${MG_DEV_ROOT}"
	ln -s ${MG_DEV_ROOT} src/MapGuide/MgDev
	echo "Symlink created => ${MG_DEV_ROOT}"
	echo "Assumed to be referring to branch [${MG_VER}]"
else
	echo "Symlink src/MapGuide/MgDev points to [${MG_DEV_ROOT}] and is assumed to be referring to branch [${MG_VER}]"
fi
export MG_SOURCE_ROOT=$PWD/src/MapGuide/MgDev
source Env/${MG_VER}/setup.sh
echo Copying API generation configuration files
if [ ! -d "src/Bindings/MapGuideApi" ];
then
	mkdir -p src/Bindings/MapGuideApi
fi
cp Env/${MG_VER}/MapGuideApiGen.xml src/Bindings/MapGuideApi
cp Env/${MG_VER}/Constants.xml src/Bindings/MapGuideApi
echo "Environment set for [${MG_VER}]"