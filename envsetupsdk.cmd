@echo off
SET MG_VER_MAJOR=%1
SET MG_VER_MINOR=%2
SET MG_VER_REV=%3
SET MG_VER_BUILD=%4
SET MG_VERSION=%1.%2
SET MG_VER_TRIPLET=%1.%2.%3
SET SWIG_TOOL_PATH=%5
SET MG_PKG_BUILD=%6
SET MG_PKG_VER=%MG_VER_TRIPLET%.%MG_VER_BUILD%
if not "%MG_PKG_BUILD%" == "" (
    SET MG_PKG_VER=%MG_VER_TRIPLET%.%MG_VER_BUILD%-pre%MG_PKG_BUILD%
)
if not exist "%SWIG_TOOL_PATH%\swig.exe" goto no_swig

SET MG_SDK_DIR=sdk/%MG_VERSION%
IF NOT EXIST %MG_SDK_DIR% (
    echo No SDK found at [%MG_SDK_DIR%]
    exit /b 1
)

echo NuGet package version will be: %MG_PKG_VER%

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

echo Preparing native binaries for nuget package
copy /y "sdk\%MG_VERSION%\Bin\*.dll" "src\Managed\DotNet\MapGuideDotNetApi\runtimes\win-x86\native"
copy /y "sdk\%MG_VERSION%\Bin64\*.dll" "src\Managed\DotNet\MapGuideDotNetApi\runtimes\win-x64\native"
echo Preparing native binaries for PHP extension
if not exist "packages\php\Release\x86" mkdir "packages\php\Release\x86"
if not exist "packages\php\Release\x64" mkdir "packages\php\Release\x64"
copy /y "sdk\%MG_VERSION%\Bin\*.dll" "packages\php\Release\x86"
copy /y "sdk\%MG_VERSION%\Bin64\*.dll" "packages\php\Release\x64"
echo Preparing native binaries for Java binding
if not exist "packages\Java\Release\x86" mkdir "packages\Java\Release\x86"
if not exist "packages\Java\Release\x64" mkdir "packages\Java\Release\x64"
copy /y "sdk\%MG_VERSION%\Bin\*.dll" "packages\Java\Release\x86"
copy /y "sdk\%MG_VERSION%\Bin64\*.dll" "packages\Java\Release\x64"

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

echo Checking for internal tools
which tools/SwigPrepare
if %errorlevel% neq 0 (
    echo One or more internal tools not found. Run build_tools.cmd
    goto error
)
which tools/StampVer
if %errorlevel% neq 0 (
    echo One or more internal tools not found. Run build_tools.cmd
    goto error
)
which tools/PhpPostProcess
if %errorlevel% neq 0 (
    echo One or more internal tools not found. Run build_tools.cmd
    goto error
)

SET MG_INTERNAL_TOOL_PATH=%CD%\tools
echo Running SwigPrepare
%MG_INTERNAL_TOOL_PATH%\SwigPrepare "sdk\%MG_VERSION%" "../../../sdk/%MG_VERSION%" "src\Bindings\MapGuideApi"
if %errorlevel% neq 0 goto error

echo Stamping version [%MG_VER_MAJOR%.%MG_VER_MINOR%.%MG_VER_REV%.%MG_VER_BUILD%]
%MG_INTERNAL_TOOL_PATH%\StampVer %MG_VER_MAJOR% %MG_VER_MINOR% %MG_VER_REV% %MG_VER_BUILD% "%CD%\src\Managed\DotNet\MapGuideDotNetApi\Properties\AssemblyInfo.cs"  "%CD%\src\Managed\DotNet\MapGuideDotNetApi\MapGuideDotNetApi.csproj"
if %errorlevel% neq 0 goto error

REM echo Regenerating Class Maps
REM pushd src\Tools\ClassMapGen
REM call dotnet run "%SRC_BASE%"
REM popd