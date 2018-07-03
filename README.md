# mapguide-api-bindings

[![Windows Build status](https://ci.appveyor.com/api/projects/status/rf40wvqdsedmk6lm?svg=true)](https://ci.appveyor.com/project/jumpinjackie/mapguide-api-bindings)

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
| .net     |[Binding Notes](src/Bindings/DotNet/README.md)| Yes           | Yes           | No (^1)     | Yes (^2)    |
| PHP 7.1  |[Binding Notes](src/Bindings/Php/README.md)   | TBD (^3)      | Yes (^3)      | TBD (^3)    | TBD (^3)    |
| Java     |[Binding Notes](src/Bindings/Java/README.md)  | TBD           | Yes           | Yes (^4)    | Yes (^4)    |
 
(^1): 
Microsoft does not offer .net Core for 32-bit Linux.

(^2): 
Ubuntu 14.04 64-bit only

(^3):
Because official MapGuide release does not (yet) bundle PHP 7.x, the current way to use this binding is through a standalone install of PHP 7.x and manually registering the MapGuide API extension with it.

(^4):
Only supported on Linux distros where we provide MapGuide binaries for:
 * Ubuntu 14.04
 * CentOS 6.x

With the possibility in the future for experimental (a.k.a Use at your own risk) support for other platforms that a current and unmodified SWIG can offer us:

 * Ruby
 * Python
 * node.js
 * and much more!

# Build requirements (Windows)

 * Microsoft Visual C++ 2015 (You can use the Community Edition)
    * If you have VS 2017, make sure it has the MSVC 2015 (v140) toolset installed
 * SWIG 3.0.12 (On Linux, envsetupsdk.sh can download and install this for you)
 * .net Core SDK 2.1
 * 7-zip
 * Java SDK
 * ant
 * ant-contrib
 * CMake (>= 2.8)

# Build requirements (Linux)

 * Ubuntu 14.04 or CentOS 6.x
 * MapGuide is installed
 * .net Core SDK
 * Java SDK
 * dos2unix
 * p7zip (for CentOS, you need to enable EPEL repositories)
 * CMake (>= 2.8)

# Before you build

You will need a pre-compiled "buildpack". This contains the minimum set of headers/libs/dlls from MapGuide needed to build 
the SWIG bindings. Grab the appropriate buildpacks here (URL TBD) and extract them a versioned directory under the "sdk" directory. 

For example, if you are installing the 3.1 buildpack, extract the buildpack contents to ```sdk\3.1```

On Linux, only the headers from this buildpack are needed as this project will link against the libraries of your MapGuide installation.

# Build Instructions (Windows)

## Build Steps (CMake)

 1. Run ```build_tools.cmd``` to build all the internal tools required for the rest of the build 
 2. Run ```envsetup.cmd $VERSION_MAJOR $VERSION_MINOR $VERSION_BUILD $VERSION_REV <path to swig installation>```. For example, if building against MGOS 3.1.1 and SWIG is installed in ```C:\swigwin-3.0.12```, you would run ```envsetup.cmd 3 1 1 9378 C:\swigwin-3.0.12```
 3. Run ```cmake_build.cmd <path to working directory>``` to build the SWIG bindings and associated wrappers
 4. To test any of the bindings, run:
   - For .net Core: `test_dotnet_core.cmd`
   - For .net Full Framework: `test_dotnet_full.cmd`
   - For PHP: `test_php.cmd`
   - For Java: `test_java.cmd`

## Build Steps (MSBuild)

 1. Run ```build_tools.cmd``` to build all the internal tools required for the rest of the build 
 2. Run ```envsetup.cmd $VERSION_MAJOR $VERSION_MINOR $VERSION_BUILD $VERSION_REV```. For example, if building against MGOS 3.1.1, you would run ```envsetup.cmd 3 1 1 9378```
 3. Run ```build.cmd``` to build the SWIG bindings and associated wrappers
 4. To test any of the bindings, run:
   - For .net Core: `test_dotnet_core.cmd`
   - For .net Full Framework: `test_dotnet_full.cmd`
   - For PHP: `test_php.cmd`
   - For Java: `test_java.cmd`

# Build Instructions (Linux, bare metal)

## Before you start

Also note that this build process on Linux will only build the SWIG glue library for .net/Java/PHP. The mananged wrapper libraries themselves are expected to be built on Windows

## Build Steps

 1. Run ```./build_tools.sh``` to build all the internal tools required for the rest of the build
 2. Run ```./envsetupsdk.sh --version $VERSION_MAJOR.$VERSION_MINOR.$VERSION_BUILD.$VERSION_REV [--with-java] [--with-dotnet] [--with-php]``` to prepare the environment to build for .net/Java/PHP. This will download SWIG and the equivalent MapGuide buildpack if required. Please observe the above support matrix when deciding what languages to enable. For example, ```--with-dotnet``` is useless on 32-bit Linux because there is no .net Core SDK for 32-bit Linux.
 3. Run ```./cmake_build.sh --version $VERSION_MAJOR.$VERSION_MINOR.$VERSION_BUILD.$VERSION_REV --working-dir <path to working directory> [--with-java] [--with-dotnet] [--with-php]``` to build the glue libraries in `<working directory>`
 4. To test any of the bindings, run:
   - For .net Core: `test_dotnet.sh`
   - For Java: `test_java.sh`

# Build Instructions (Linux, via vagrant on Windows host)

Vagrantfiles are provided which can build the required SWIG glue libraries for the supported distros on Linux.

These Vagrantfiles assume vagrant base boxes that are already present:
  - `env-centos6-amd64`
  - `env-centos6-i386`
  - `env-ubuntu14-amd64`
  - `env-ubuntu14-i386`

If these base boxes aren't present, you can build them using using [packer](https://www.packer.io/) and the provided templates in `linux_build/packer`. For convenience, a `make_boxes.cmd` wrapper batch file is included to build all these vagrant base boxes for you (make sure packer is in your Windows `PATH`).

 1. Enter any of the following directories:
   - `linux_build/CentOS6_x64`
   - `linux_build/CentOS6_x86`
   - `linux_build/Ubuntu14_x64`
   - `linux_build/Ubuntu14_x86`
 2. Run `vagrant up` to spin up the Linux VM and build the SWIG glue libraries supported on that distro. Upon completion, the glue libraries will be in (on your host):
   - Java: `packages/Java/Release/$CPU/$DISTRO/libMapGuideJavaApi.so`
   - .net: `src/Managed/DotNet/MapGuideDotNetApi/runtimes/ubuntu14.04-x64/native/libMapGuideDotNetUnmanagedApi.so` (Ubuntu 14.04 64-bit only)