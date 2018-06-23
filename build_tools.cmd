@echo off
SET BUILD_AREA=%TEMP%\mapguide-api-bindings-tools
SET MG_TOOL_SRC_PATH=%CD%\src\Tools
if not exist "%BUILD_AREA%" mkdir "%BUILD_AREA%"
pushd "%BUILD_AREA%"
REM Test for CMake
which cmake
if %errorlevel% neq 0 (
    echo CMake not found
    goto error
)
cmake -G "Visual Studio 14 2015" -DCMAKE_BUILD_TYPE=Release %MG_TOOL_SRC_PATH%
if %errorlevel% neq 0 goto error
cmake --build . --config Release
popd
goto end

:error
echo An error occurred while building a component
popd
:end
