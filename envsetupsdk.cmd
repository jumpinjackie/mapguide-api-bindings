@echo off
SET MG_VER_MAJOR=%1
SET MG_VER_MINOR=%2
SET MG_VER_REV=%3
SET MG_VER_BUILD=%4
SET MG_VERSION=%1.%2
SET MG_VER_TRIPLET=%1.%2.%3
SET SWIG_TOOL_PATH=%5
if not exist "%SWIG_TOOL_PATH%\swig.exe" goto no_swig

SET MG_SDK_DIR=sdk/%MG_VERSION%
IF NOT EXIST %MG_SDK_DIR% (
    echo No SDK found at [%MG_SDK_DIR%]
    exit /b 1
)

SET SRC_BASE=%CD%/src
SET PHP_SRC=%CD%/thirdparty/php7/src/php-7.1.18

SET MG_OEM_ACE_INCLUDE_DIR=../../../%MG_SDK_DIR%/Inc/ACE_wrappers
SET MG_HTTPHANDLER_INCLUDE_DIR=../../../%MG_SDK_DIR%/Inc/Web/HttpHandler
SET MG_WEBAPP_INCLUDE_DIR=../../../%MG_SDK_DIR%/Inc/Web/WebApp
SET MG_WEBSUPPORT_INCLUDE_DIR=../../../%MG_SDK_DIR%/Inc/Web/WebSupport
SET MG_MDFMODEL_INCLUDE_DIR=../../../%MG_SDK_DIR%/Inc/Common/MdfModel
SET MG_FOUNDATION_INCLUDE_DIR=../../../%MG_SDK_DIR%/Inc/Common/Foundation
SET MG_GEOMETRY_INCLUDE_DIR=../../../%MG_SDK_DIR%/Inc/Common/Geometry
SET MG_PLATFORMBASE_INCLUDE_DIR=../../../%MG_SDK_DIR%/Inc/Common/PlatformBase
SET MG_MAPGUIDECOMMON_INCLUDE_DIR=../../../%MG_SDK_DIR%/Inc/Common/MapGuideCommon

SET PHP_LIB=%CD%/runtimes/php/Release/dev
SET PHP_LIB64=%CD%/runtimes/php/Release64/dev

SET MG_SDK_INC=../../../%MG_SDK_DIR%/Inc
SET MG_SDK_LIB=../../../%MG_SDK_DIR%/Lib
SET MG_SDK_LIB64=../../../%MG_SDK_DIR%/Lib64

REM restore nuget packages just in case
pushd src\Tools
call dotnet restore
popd

echo Preparing SWIG configurations
pushd src\Tools\SwigPrepare
call dotnet run ..\..\..\sdk\%MG_VERSION% ..\..\Bindings\MapGuideApi
popd

echo Stamping version [%MG_VER_MAJOR%.%MG_VER_MINOR%.%MG_VER_REV%.%MG_VER_BUILD%]
pushd src\Tools\StampVer
call dotnet run ..\.. %MG_VER_MAJOR% %MG_VER_MINOR% %MG_VER_REV% %MG_VER_BUILD%
popd

echo Regenerating Class Maps
pushd src\Tools\ClassMapGen
call dotnet run "%SRC_BASE%"
popd

echo Preparing native binaries for nuget package
copy /y "sdk\%MG_VERSION%\Bin\*.dll" "src\Bindings\DotNet\MapGuideDotNetApi\runtimes\win-x86\native"
copy /y "sdk\%MG_VERSION%\Bin64\*.dll" "src\Bindings\DotNet\MapGuideDotNetApi\runtimes\win-x64\native"

IF "%MG_VERSION%"=="3.3" goto setvcvarsall_2015
IF "%MG_VERSION%"=="3.1" goto setvcvarsall_2015
goto error

:setvcvarsall_2015
if "%CALLED_VCVARS%"=="1" (
    echo Already set up vcvars
    goto done
)
set PARAM1=x86_amd64
rem VS 2015 will be default from now
SET VCBEXTENSION=_vs15
SET VC_COMPILER=vc140
SET ACTIVENAMECHECK="Microsoft Visual Studio 15"
rem Test [VS2017 + 2015 compiler workload] cases first
SET ACTIVEPATHCHECK=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build
if exist "%ACTIVEPATHCHECK%" goto VS17Exist
SET ACTIVEPATHCHECK=C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Auxiliary\Build
if exist "%ACTIVEPATHCHECK%" goto VS17Exist
SET ACTIVEPATHCHECK=C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\VC\Auxiliary\Build
if exist "%ACTIVEPATHCHECK%" goto VS17Exist
rem Then test for original VS 2015
SET ACTIVEPATHCHECK=C:\Program Files\Microsoft Visual Studio 14.0\VC
if exist "%ACTIVEPATHCHECK%" goto VSExist
SET ACTIVEPATHCHECK=C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC
if exist "%ACTIVEPATHCHECK%" goto VSExist

goto error

:VS17Exist
rem This will instruct the 2017 vcvarsall to use the v140 toolset
rem https://docs.microsoft.com/en-us/visualstudio/releasenotes/vs2017-relnotes-v15.3#C++ToolsetLibs15
SET PARAM2=-vcvars_ver=14.0

:VSExist
call "%ACTIVEPATHCHECK%/vcvarsall.bat" %PARAM1% %PARAM2%
set CALLED_VCVARS=1
goto done

:no_swig
echo Cannot find swig
echo Usage: envsetupsdk.cmd [version:major] [version:minor] [version:rev] [version:build] [path to swig directory]
goto error

:error
echo Unable to find Visual Studio or your version of MapGuide is not supported by this script
exit /B 1

:done
echo Environment set for [%MG_VERSION%] using SDK in [%MG_SDK_DIR%]