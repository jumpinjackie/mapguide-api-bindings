@echo off
REM sdkify.cmd
REM 
REM Produces the minimal set of binaries/libs/headers from the MapGuide source tree so that native MapGuide
REM extensions (eg. These SWIG bindings) can be built against minimal SDK-like packages
REM 
REM This requires the MapGuide source tree has been built in both x86 and x64 release configurations
SET MG_SRC_DIR=%1
SET MG_SDK_OUTPUT_DIR=%2

SET COPY=copy /Y
SET XCOPY_DIR=xcopy /e /y /i /q /s

if not exist "%MG_SRC_DIR%" (
    echo No such directory: %MG_SRC_DIR%
    goto fail
)

if not exist "%MG_SDK_OUTPUT_DIR%" mkdir "%MG_SDK_OUTPUT_DIR%"
if not exist "%MG_SDK_OUTPUT_DIR%\Bin" mkdir "%MG_SDK_OUTPUT_DIR%\Bin"
if not exist "%MG_SDK_OUTPUT_DIR%\Bin64" mkdir "%MG_SDK_OUTPUT_DIR%\Bin64"
if not exist "%MG_SDK_OUTPUT_DIR%\Lib" mkdir "%MG_SDK_OUTPUT_DIR%\Lib"
if not exist "%MG_SDK_OUTPUT_DIR%\Lib64" mkdir "%MG_SDK_OUTPUT_DIR%\Lib64"
if not exist "%MG_SDK_OUTPUT_DIR%\Inc" mkdir "%MG_SDK_OUTPUT_DIR%\Inc"
if not exist "%MG_SDK_OUTPUT_DIR%\SWIG" mkdir "%MG_SDK_OUTPUT_DIR%\SWIG"
echo [prepare]: Oem - ACE
%COPY% "%MG_SRC_DIR%\Oem\ACE\ACE_wrappers\lib\Release\ACE.dll" "%MG_SDK_OUTPUT_DIR%\Bin"
REM %COPY% "%MG_SRC_DIR%\Oem\ACE\ACE_wrappers\lib\Release\ACE.pdb" "%MG_SDK_OUTPUT_DIR%\Bin"
%COPY% "%MG_SRC_DIR%\Oem\ACE\ACE_wrappers\lib\Release\ACE.lib" "%MG_SDK_OUTPUT_DIR%\Lib"
%COPY% "%MG_SRC_DIR%\Oem\ACE\ACE_wrappers\lib64\Release\ACE.dll" "%MG_SDK_OUTPUT_DIR%\Bin64"
REM %COPY% "%MG_SRC_DIR%\Oem\ACE\ACE_wrappers\lib64\Release\ACE.pdb" "%MG_SDK_OUTPUT_DIR%\Bin64"
%COPY% "%MG_SRC_DIR%\Oem\ACE\ACE_wrappers\lib64\Release\ACE.lib" "%MG_SDK_OUTPUT_DIR%\Lib64"
%XCOPY_DIR% "%MG_SRC_DIR%\Oem\ACE\ACE_wrappers\ace\*.h" "%MG_SDK_OUTPUT_DIR%\Inc\ACE_wrappers\ace"
%XCOPY_DIR% "%MG_SRC_DIR%\Oem\ACE\ACE_wrappers\ace\*.inl" "%MG_SDK_OUTPUT_DIR%\Inc\ACE_wrappers\ace"
%XCOPY_DIR% "%MG_SRC_DIR%\Oem\ACE\ACE_wrappers\ace\*.cpp" "%MG_SDK_OUTPUT_DIR%\Inc\ACE_wrappers\ace"
echo [prepare]: Oem - GEOS
%COPY% "%MG_SRC_DIR%\Oem\geos\VisualStudio\Release\GEOS.dll" "%MG_SDK_OUTPUT_DIR%\Bin"
REM %COPY% "%MG_SRC_DIR%\Oem\geos\VisualStudio\Release\GEOS.pdb" "%MG_SDK_OUTPUT_DIR%\Bin"
%COPY% "%MG_SRC_DIR%\Oem\geos\VisualStudio\Release64\GEOS.dll" "%MG_SDK_OUTPUT_DIR%\Bin64"
REM %COPY% "%MG_SRC_DIR%\Oem\geos\VisualStudio\Release64\GEOS.pdb" "%MG_SDK_OUTPUT_DIR%\Bin64"
echo [prepare]: Oem - xerces
%COPY% "%MG_SRC_DIR%\Oem\dbxml\xerces-c-src\Build\Release\xerces-c_3_1mg.dll" "%MG_SDK_OUTPUT_DIR%\Bin"
REM %COPY% "%MG_SRC_DIR%\Oem\dbxml\xerces-c-src\Build\Release\xerces-c_3_1mg.pdb" "%MG_SDK_OUTPUT_DIR%\Bin"
REM %COPY% "%MG_SRC_DIR%\Oem\dbxml\xerces-c-src\Build\Release\xerces-c_3mg.lib" "%MG_SDK_OUTPUT_DIR%\Lib"
%COPY% "%MG_SRC_DIR%\Oem\dbxml\xerces-c-src\Build\Release64\xerces-c_3_1mg.dll" "%MG_SDK_OUTPUT_DIR%\Bin64"
REM %COPY% "%MG_SRC_DIR%\Oem\dbxml\xerces-c-src\Build\Release64\xerces-c_3_1mg.pdb" "%MG_SDK_OUTPUT_DIR%\Bin64"
REM %COPY% "%MG_SRC_DIR%\Oem\dbxml\xerces-c-src\Build\Release64\xerces-c_3mg.lib" "%MG_SDK_OUTPUT_DIR%\Lib64"
%XCOPY_DIR% "%MG_SRC_DIR%\Oem\dbxml\xerces-c-src\src\*.h" "%MG_SDK_OUTPUT_DIR%\Inc\xerces"
%XCOPY_DIR% "%MG_SRC_DIR%\Oem\dbxml\xerces-c-src\src\*.hpp" "%MG_SDK_OUTPUT_DIR%\Inc\xerces"
%XCOPY_DIR% "%MG_SRC_DIR%\Oem\dbxml\xerces-c-src\src\*.c" "%MG_SDK_OUTPUT_DIR%\Inc\xerces"
echo [prepare]: MapGuide - Common
%COPY% "%MG_SRC_DIR%\Common\bin\Release\MgFoundation.dll" "%MG_SDK_OUTPUT_DIR%\Bin"
REM %COPY% "%MG_SRC_DIR%\Common\bin\Release\MgFoundation.pdb" "%MG_SDK_OUTPUT_DIR%\Bin"
%COPY% "%MG_SRC_DIR%\Common\lib\Release\MgFoundation.lib" "%MG_SDK_OUTPUT_DIR%\Lib"
%COPY% "%MG_SRC_DIR%\Common\bin\Release\MgGeometry.dll" "%MG_SDK_OUTPUT_DIR%\Bin"
REM %COPY% "%MG_SRC_DIR%\Common\bin\Release\MgGeometry.pdb" "%MG_SDK_OUTPUT_DIR%\Bin"
%COPY% "%MG_SRC_DIR%\Common\lib\Release\MgGeometry.lib" "%MG_SDK_OUTPUT_DIR%\Lib"
%COPY% "%MG_SRC_DIR%\Common\bin\Release\MgMapGuideCommon.dll" "%MG_SDK_OUTPUT_DIR%\Bin"
REM %COPY% "%MG_SRC_DIR%\Common\bin\Release\MgMapGuideCommon.pdb" "%MG_SDK_OUTPUT_DIR%\Bin"
%COPY% "%MG_SRC_DIR%\Common\lib\Release\MgMapGuideCommon.lib" "%MG_SDK_OUTPUT_DIR%\Lib"
%COPY% "%MG_SRC_DIR%\Common\bin\Release\MgMdfModel.dll" "%MG_SDK_OUTPUT_DIR%\Bin"
REM %COPY% "%MG_SRC_DIR%\Common\bin\Release\MgMdfModel.pdb" "%MG_SDK_OUTPUT_DIR%\Bin"
%COPY% "%MG_SRC_DIR%\Common\lib\Release\MgMdfModel.lib" "%MG_SDK_OUTPUT_DIR%\Lib"
%COPY% "%MG_SRC_DIR%\Common\bin\Release\MgMdfParser.dll" "%MG_SDK_OUTPUT_DIR%\Bin"
REM %COPY% "%MG_SRC_DIR%\Common\bin\Release\MgMdfParser.pdb" "%MG_SDK_OUTPUT_DIR%\Bin"
%COPY% "%MG_SRC_DIR%\Common\lib\Release\MgMdfParser.lib" "%MG_SDK_OUTPUT_DIR%\Lib"
%COPY% "%MG_SRC_DIR%\Common\bin\Release\MgPlatformBase.dll" "%MG_SDK_OUTPUT_DIR%\Bin"
REM %COPY% "%MG_SRC_DIR%\Common\bin\Release\MgPlatformBase.pdb" "%MG_SDK_OUTPUT_DIR%\Bin"
%COPY% "%MG_SRC_DIR%\Common\lib\Release\MgPlatformBase.lib" "%MG_SDK_OUTPUT_DIR%\Lib"
%COPY% "%MG_SRC_DIR%\Common\bin\Release64\MgFoundation.dll" "%MG_SDK_OUTPUT_DIR%\Bin64"
REM %COPY% "%MG_SRC_DIR%\Common\bin\Release64\MgFoundation.pdb" "%MG_SDK_OUTPUT_DIR%\Bin64"
%COPY% "%MG_SRC_DIR%\Common\lib\Release64\MgFoundation.lib" "%MG_SDK_OUTPUT_DIR%\Lib64"
%COPY% "%MG_SRC_DIR%\Common\bin\Release64\MgGeometry.dll" "%MG_SDK_OUTPUT_DIR%\Bin64"
REM %COPY% "%MG_SRC_DIR%\Common\bin\Release64\MgGeometry.pdb" "%MG_SDK_OUTPUT_DIR%\Bin64"
%COPY% "%MG_SRC_DIR%\Common\lib\Release64\MgGeometry.lib" "%MG_SDK_OUTPUT_DIR%\Lib64"
%COPY% "%MG_SRC_DIR%\Common\bin\Release64\MgMapGuideCommon.dll" "%MG_SDK_OUTPUT_DIR%\Bin64"
REM %COPY% "%MG_SRC_DIR%\Common\bin\Release64\MgMapGuideCommon.pdb" "%MG_SDK_OUTPUT_DIR%\Bin64"
%COPY% "%MG_SRC_DIR%\Common\lib\Release64\MgMapGuideCommon.lib" "%MG_SDK_OUTPUT_DIR%\Lib64"
%COPY% "%MG_SRC_DIR%\Common\bin\Release64\MgMdfModel.dll" "%MG_SDK_OUTPUT_DIR%\Bin64"
REM %COPY% "%MG_SRC_DIR%\Common\bin\Release64\MgMdfModel.pdb" "%MG_SDK_OUTPUT_DIR%\Bin64"
%COPY% "%MG_SRC_DIR%\Common\lib\Release64\MgMdfModel.lib" "%MG_SDK_OUTPUT_DIR%\Lib64"
%COPY% "%MG_SRC_DIR%\Common\bin\Release64\MgMdfParser.dll" "%MG_SDK_OUTPUT_DIR%\Bin64"
REM %COPY% "%MG_SRC_DIR%\Common\bin\Release64\MgMdfParser.pdb" "%MG_SDK_OUTPUT_DIR%\Bin64"
%COPY% "%MG_SRC_DIR%\Common\lib\Release64\MgMdfParser.lib" "%MG_SDK_OUTPUT_DIR%\Lib64"
%COPY% "%MG_SRC_DIR%\Common\bin\Release64\MgPlatformBase.dll" "%MG_SDK_OUTPUT_DIR%\Bin64"
REM %COPY% "%MG_SRC_DIR%\Common\bin\Release64\MgPlatformBase.pdb" "%MG_SDK_OUTPUT_DIR%\Bin64"
%COPY% "%MG_SRC_DIR%\Common\lib\Release64\MgPlatformBase.lib" "%MG_SDK_OUTPUT_DIR%\Lib64"
%XCOPY_DIR% "%MG_SRC_DIR%\Common\Foundation\*.h" "%MG_SDK_OUTPUT_DIR%\Inc\Common\Foundation"
%XCOPY_DIR% "%MG_SRC_DIR%\Common\Geometry\*.h" "%MG_SDK_OUTPUT_DIR%\Inc\Common\Geometry"
%XCOPY_DIR% "%MG_SRC_DIR%\Common\MapGuideCommon\*.h" "%MG_SDK_OUTPUT_DIR%\Inc\Common\MapGuideCommon"
%XCOPY_DIR% "%MG_SRC_DIR%\Common\MdfModel\*.h" "%MG_SDK_OUTPUT_DIR%\Inc\Common\MdfModel"
%XCOPY_DIR% "%MG_SRC_DIR%\Common\MdfParser\*.h" "%MG_SDK_OUTPUT_DIR%\Inc\Common\MdfParser"
%XCOPY_DIR% "%MG_SRC_DIR%\Common\PlatformBase\*.h" "%MG_SDK_OUTPUT_DIR%\Inc\Common\PlatformBase"
%XCOPY_DIR% "%MG_SRC_DIR%\Common\Security\*.h" "%MG_SDK_OUTPUT_DIR%\Inc\Common\Security"
echo [prepare]: MapGuide - Web Common
%COPY% "%MG_SRC_DIR%\Web\bin\Release\lib_json.dll" "%MG_SDK_OUTPUT_DIR%\Bin"
%COPY% "%MG_SRC_DIR%\Web\bin\Release\MgHttpHandler.dll" "%MG_SDK_OUTPUT_DIR%\Bin"
REM %COPY% "%MG_SRC_DIR%\Web\bin\Release\MgHttpHandler.pdb" "%MG_SDK_OUTPUT_DIR%\Bin"
%COPY% "%MG_SRC_DIR%\Web\lib\Release\HttpHandler.lib" "%MG_SDK_OUTPUT_DIR%\Lib"
%COPY% "%MG_SRC_DIR%\Web\bin\Release\MgWebApp.dll" "%MG_SDK_OUTPUT_DIR%\Bin"
REM %COPY% "%MG_SRC_DIR%\Web\bin\Release\MgWebApp.pdb" "%MG_SDK_OUTPUT_DIR%\Bin"
%COPY% "%MG_SRC_DIR%\Web\lib\Release\WebApp.lib" "%MG_SDK_OUTPUT_DIR%\Lib"
%COPY% "%MG_SRC_DIR%\Web\bin\Release\MgWebSupport.dll" "%MG_SDK_OUTPUT_DIR%\Bin"
REM %COPY% "%MG_SRC_DIR%\Web\bin\Release\MgWebSupport.pdb" "%MG_SDK_OUTPUT_DIR%\Bin"
%COPY% "%MG_SRC_DIR%\Web\lib\Release\WebSupport.lib" "%MG_SDK_OUTPUT_DIR%\Lib"
%COPY% "%MG_SRC_DIR%\Web\bin\Release64\lib_json.dll" "%MG_SDK_OUTPUT_DIR%\Bin64"
%COPY% "%MG_SRC_DIR%\Web\bin\Release64\MgHttpHandler.dll" "%MG_SDK_OUTPUT_DIR%\Bin64"
REM %COPY% "%MG_SRC_DIR%\Web\bin\Release64\MgHttpHandler.pdb" "%MG_SDK_OUTPUT_DIR%\Bin64"
%COPY% "%MG_SRC_DIR%\Web\lib\Release64\HttpHandler.lib" "%MG_SDK_OUTPUT_DIR%\Lib64"
%COPY% "%MG_SRC_DIR%\Web\bin\Release64\MgWebApp.dll" "%MG_SDK_OUTPUT_DIR%\Bin64"
REM %COPY% "%MG_SRC_DIR%\Web\bin\Release64\MgWebApp.pdb" "%MG_SDK_OUTPUT_DIR%\Bin64"
%COPY% "%MG_SRC_DIR%\Web\lib\Release64\WebApp.lib" "%MG_SDK_OUTPUT_DIR%\Lib64"
%COPY% "%MG_SRC_DIR%\Web\bin\Release64\MgWebSupport.dll" "%MG_SDK_OUTPUT_DIR%\Bin64"
REM %COPY% "%MG_SRC_DIR%\Web\bin\Release64\MgWebSupport.pdb" "%MG_SDK_OUTPUT_DIR%\Bin64"
%COPY% "%MG_SRC_DIR%\Web\lib\Release64\WebSupport.lib" "%MG_SDK_OUTPUT_DIR%\Lib64"
%XCOPY_DIR% "%MG_SRC_DIR%\Web\src\HttpHandler\*.h" "%MG_SDK_OUTPUT_DIR%\Inc\Web\HttpHandler"
%XCOPY_DIR% "%MG_SRC_DIR%\Web\src\WebApp\*.h" "%MG_SDK_OUTPUT_DIR%\Inc\Web\WebApp"
%XCOPY_DIR% "%MG_SRC_DIR%\Web\src\WebSupport\*.h" "%MG_SDK_OUTPUT_DIR%\Inc\Web\WebSupport"
echo [prepare]: MapGuide - SWIG configuration
%COPY% "%MG_SRC_DIR%\Web\src\MapGuideApi\MapGuideApiGen.xml" "%MG_SDK_OUTPUT_DIR%\SWIG"
%COPY% "%MG_SRC_DIR%\Web\src\MapGuideApi\Constants.xml" "%MG_SDK_OUTPUT_DIR%\SWIG"
goto end
:fail
echo Usage: sdkify.cmd [MapGuide Source Tree root dir] [output directory]
:end