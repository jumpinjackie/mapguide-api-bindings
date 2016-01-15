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

| Platform | Binding Notes                                |
| -------- |:--------------------------------------------:|
| .net     |[Binding Notes](src/Bindings/DotNet/README.md)|
 
Eventually reaching platform parity with our existing offerings:

 * PHP (5.5.x)
 * Java
 * .net (Full Framework)

With future experimental (a.k.a Use at your own risk) support for other platforms that a current and unmodified SWIG can offer us:

 * Ruby
 * Python
 * node.js
 * and much more!

# Build requirements (Windows)

 * Microsoft Visual C++ 2015 (You can use the Community Edition)
 * Microsoft Visual C++ 2012 (You can use the Express Edition for Windows Desktop)
 * SWIG 3.0.7 (On Linux, swigsetup.sh can download and install this for you)
 * DNX 1.0.0 RC1. Get DNX for both platforms (x86 and x64) and runtimes (clr and coreclr) 

# Build requirements (Linux)

 * Ubuntu 14.04 64-bit
 * MapGuide is installed
 * DNX 1.0.0 RC1. Get DNX for coreclr

# Before you build

You will need a pre-compiled "buildpack". This contains the minimum set of headers/libs/dlls from MapGuide needed to build 
the SWIG bindings. Grab the appropriate buildpacks here (URL TBD) and extract them a versioned directory under the "sdk" directory. 

For example, if you are installing the 3.0 buildpack, extract the buildpack contents to ```sdk\3.0```

# Build Instructions (Windows)

## Build Steps

 1. Launch the VS 2015 developer command prompt.
 2. Activate DNX with ```dnvm use```. Choose the x64 coreclr or clr runtime. 
 3. Run ```envsetup.cmd $VERSION_MAJOR $VERSION_MINOR $VERSION_BUILD $VERSION_REV```. For example, if building against MGOS 3.0, you would run ```envsetup.cmd 3 0 0 8701```
 4. Run ```build.cmd``` to build the SWIG bindings and associated wrappers

# Build Instructions (Linux)

## Before you start

Also note that this build process on Linux will only build the SWIG glue library for .net Core. The .net wrapper itself is expected to be built on Windows

## Build Steps

 1. Run ```source ./envsetup.sh $PATH_TO_MAPGUIDE_SOURCE_MGDEV $MG_VERSION_MAJOR_MINOR $MG_VERSION_FULL``` if this is the first time, run the command as administrator (so that symlinks can be created)
 2. Enter ```src/Bindings/DotNet```
 3. Run ```make```