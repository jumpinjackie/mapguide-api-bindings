# mapguide-api-bindings

Language bindings for the MapGuide API

# Motivation

We currently use a heavily modified version of [SWIG](http://swig.org) to generate 
language bindings for the [MapGuide](http://mapguide.osgeo.org) API

This modified version of SWIG is extermely old and has an unclear audit trail of modifications
which makes it difficult for us to expand language support beyond what we currently support:

 * PHP (5.5.x)
 * Java
 * .net (Full Framework)

# Supported Platforms

Our current focus of this project is to use the current version of SWIG (3.0.7 as of writing) to generate
MapGuide API bindings to support the following languages/platforms:

 * .net Core (Windows and Linux) [Binding Notes](src/Bindings/DotNetCore/README.md)
 
Eventually reaching platform parity with our existing offerings:

 * PHP (5.5.x)
 * Java
 * .net (Full Framework)

With future experimental (a.k.a Use at your own risk) support for other platforms that a current and unmodified SWIG can offer us:

 * Ruby
 * Python
 * node.js
 * and much more!

# Build Instructions (Windows)

## Before you start

Make sure you have built the MapGuide source

For the rest of these instructions refer to these variables:
 * ```$PATH_TO_MAPGUIDE_SOURCE_MGDEV``` (the path where you built the MapGuide source)
 * ```$MG_VERSION_MAJOR_MINOR``` (the major.minor version number this MapGuide source directory corresponds to)

## Build Steps

 1. Run ```envsetup.cmd $PATH_TO_MAPGUIDE_SOURCE_MGDEV $MG_VERSION_MAJOR_MINOR``` if this is the first time, run the command as administrator (so that symlinks can be created)
 2. Build ```src/Bindings/Bindings.sln``` either through MSBuild or Visual Studio
 3. Set up DNX ```dnvm use 1.0.0-rc1-update1 -r coreclr -arch x64```
 4. Enter ```src/Bindings/DotNetCore/MapGuideDotNetCoreApi```
 5. Run ```dnu pack --configuration Release``` the nuget package will reside in ```src/Bindings/DotNetCore/MapGuideDotNetCoreApi/bin/release```

# Build Instructions (Linux)

## Before you start

Make sure you have built the MapGuide source and installed the binaries

For the rest of these instructions refer to these variables:
 * ```$PATH_TO_MAPGUIDE_SOURCE_MGDEV``` (the path where you built the MapGuide source)
 * ```$MG_VERSION_MAJOR_MINOR``` (the major.minor version number this MapGuide source directory corresponds to)
 * ```$MG_VERSION_FULL``` (the major.minor.rev version number this MapGuide source directory corresponds to)

Also note that this build process on Linux will only build the SWIG glue library for .net Core. The .net wrapper itself is expected to be built on Windows

## Build Steps

 1. Run ```source ./envsetup.sh $PATH_TO_MAPGUIDE_SOURCE_MGDEV $MG_VERSION_MAJOR_MINOR $MG_VERSION_FULL``` if this is the first time, run the command as administrator (so that symlinks can be created)
 2. Enter ```src/Bindings/DotNetCore```
 3. Run ```make```