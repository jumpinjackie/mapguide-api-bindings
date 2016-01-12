@echo off
SET MG_VERSION=%1
SET SWIG_TOOL_PATH=D:\swigwin-3.0.7

SET MG_SDK_DIR=sdk/%MG_VERSION%
IF NOT EXIST %MG_SDK_DIR% (
    echo No SDK found at [%MG_SDK_DIR%]
    exit /b 1
)

SET MG_OEM_ACE_INCLUDE_DIR=../../../%MG_SDK_DIR%/Inc/ACE_wrappers
SET MG_OEM_XERCES_INCLUDE_DIR=../../../%MG_SDK_DIR%/Inc/xerces
SET MG_HTTPHANDLER_INCLUDE_DIR=../../../%MG_SDK_DIR%/Inc/Web/HttpHandler
SET MG_WEBAPP_INCLUDE_DIR=../../../%MG_SDK_DIR%/Inc/Web/WebApp
SET MG_WEBSUPPORT_INCLUDE_DIR=../../../%MG_SDK_DIR%/Inc/Web/WebSupport
SET MG_MDFMODEL_INCLUDE_DIR=../../../%MG_SDK_DIR%/Inc/Common/MdfModel
SET MG_FOUNDATION_INCLUDE_DIR=../../../%MG_SDK_DIR%/Inc/Common/Foundation
SET MG_GEOMETRY_INCLUDE_DIR=../../../%MG_SDK_DIR%/Inc/Common/Geometry
SET MG_PLATFORMBASE_INCLUDE_DIR=../../../%MG_SDK_DIR%/Inc/Common/PlatformBase
SET MG_MAPGUIDECOMMON_INCLUDE_DIR=../../../%MG_SDK_DIR%/Inc/Common/MapGuideCommon

SET MG_SDK_INC=../../../%MG_SDK_DIR%/Inc
SET MG_SDK_LIB=../../../%MG_SDK_DIR%/Lib
SET MG_SDK_LIB64=../../../%MG_SDK_DIR%/Lib64

src\FileReplace\bin\FileReplace.exe "%MG_SDK_DIR%/SWIG/Constants.xml" "src\Bindings\MapGuideApi\Constants.xml" replacements.txt "../../../%MG_SDK_DIR%"
src\FileReplace\bin\FileReplace.exe "%MG_SDK_DIR%/SWIG/MapGuideApiGen.xml" "src\Bindings\MapGuideApi\MapGuideApiGen.xml" replacements.txt "../../../%MG_SDK_DIR%"

echo Preparing native binaries for nuget package
copy /y "sdk\%MG_VERSION%\Bin\*.dll" "src\Bindings\DotNet\MapGuideDotNetApi\runtimes\win7-x86\native"
copy /y "sdk\%MG_VERSION%\Bin64\*.dll" "src\Bindings\DotNet\MapGuideDotNetApi\runtimes\win7-x64\native"

echo Environment set for [%MG_VERSION%] using SDK in [%MG_SDK_DIR%]