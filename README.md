# mapguide-api-bindings

Language bindings for the MapGuide API

# Motivation

We currently use a heavily modified version of [SWIG](http://swig.org) to generate 
language bindings for the [MapGuide](http://mapguide.osgeo.org) API

This modified version of SWIG is extermely old and has an unclear audit trail of modifications
which makes it difficult for us to expand language support beyond what we currently support:

 * PHP (5.x)
 * Java
 * .net (Full Framework)

# Supported Platforms

Our current focus of this project is to use the current version of SWIG (3.0.12 as of writing) to generate
MapGuide API bindings to support the following languages/platforms:

| Platform | Binding Notes                                | Windows (x86) | Windows (x64) | Linux (x86) | Linux (x64) |
| -------- |:--------------------------------------------:| ------------- | ------------- | ----------- | ----------- |
| .net     |[Binding Notes](src/Bindings/DotNet/README.md)| Supported     | Supported     | No (^1)     | TBD (^2)    |
| PHP 7.1  |[Binding Notes](src/Bindings/Php/README.md)   | TBD (^3)      | Supported (^3)| TBD (^3)    | TBD (^3)    |
| Java     |[Binding Notes](src/Bindings/Java/README.md)  | TBD           | Supported     | TBD         | TBD         |
 
(^1): 
Microsoft does not offer .net Core for 32-bit Linux.

(^2): 
If/when support is confirmed. This will only work on 64-bit Linux distros where both binary packages for MapGuide and .net Core are both available (ie. Ubuntu 14.04)

(^3):
Because official MapGuide release does not (yet) bundle PHP 7.x, the current way to use this binding is through a standalone install of PHP 7.x and manually registering the MapGuide API extension with it.

With the possibility in the future for experimental (a.k.a Use at your own risk) support for other platforms that a current and unmodified SWIG can offer us:

 * Ruby
 * Python
 * node.js
 * and much more!

# Build requirements (Windows)

 * Microsoft Visual C++ 2015 (You can use the Community Edition)
    * If you have VS 2017, make sure it has the MSVC 2015 (v140) toolset installed
 * SWIG 3.0.12 (On Linux, swigsetup.sh can download and install this for you)
 * .net Core SDK (if you have VS 2017, make sure you installed it with the .net Core workload)
 * 7-zip
 * Java SDK
 * ant

# Build requirements (Linux)

 * Ubuntu 14.04 64-bit
 * MapGuide is installed
 * .net Core SDK
 * Java SDK

# Before you build

You will need a pre-compiled "buildpack". This contains the minimum set of headers/libs/dlls from MapGuide needed to build 
the SWIG bindings. Grab the appropriate buildpacks here (URL TBD) and extract them a versioned directory under the "sdk" directory. 

For example, if you are installing the 3.1 buildpack, extract the buildpack contents to ```sdk\3.1```

# Build Instructions (Windows)

## Build Steps

 1. Run ```envsetup.cmd $VERSION_MAJOR $VERSION_MINOR $VERSION_BUILD $VERSION_REV```. For example, if building against MGOS 3.1.1, you would run ```envsetup.cmd 3 1 1 9378```
 2. Run ```build.cmd``` to build the SWIG bindings and associated wrappers
 3. To test any of the bindings, run:
   - For .net: `test_dotnet.cmd`
   - For PHP: `test_php.cmd`
   - For Java: `test_java.cmd`

# Build Instructions (Linux)

## Before you start

Also note that this build process on Linux will only build the SWIG glue library for .net Core. The .net wrapper itself is expected to be built on Windows

## Build Steps

 1. Run ```source ./envsetup.sh $PATH_TO_MAPGUIDE_SOURCE_MGDEV $MG_VERSION_MAJOR_MINOR $MG_VERSION_FULL``` if this is the first time, run the command as administrator (so that symlinks can be created)
 2. Enter ```src/Bindings/DotNet```
 3. Run ```make```