@echo off
SET MG_SRC_DIR=%1
SET MG_VERSION=%2

pushd "src/MapGuide"
if exist MgDev (
    echo MgDev symlink already exists. Moving on
) else (
    mklink /D MgDev %MG_SRC_DIR%
    echo Created symbolic link [MgDev] to [%MG_SRC_DIR%]
    echo We assume [%MG_SRC_DIR%] refers to the [%MG_VERSION%] branch
)
popd

SET SWIG_TOOL_PATH=D:\swigwin-3.0.7

SET MG_SOURCE_ROOT=%CD%\src\MapGuide\MgDev
call "%CD%\Env\%MG_VERSION%\setup.cmd"
REM Post setup
echo Copying API generation configuration files
pushd "src/Bindings"
if not exist MapGuideApi mkdir MapGuideApi
popd
copy /Y "%CD%\Env\%MG_VERSION%\MapGuideApiGen.xml" "%CD%\src\Bindings\MapGuideApi"
copy /Y "%CD%\Env\%MG_VERSION%\Constants.xml" "%CD%\src\Bindings\MapGuideApi"
echo Environment set for [%MG_VERSION%]