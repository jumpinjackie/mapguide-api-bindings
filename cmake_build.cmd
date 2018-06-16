@echo off
REM Test for CMake
which cmake
if %errorlevel% neq 0 (
    echo CMake not found
    goto error
)
SET THIS_DIR=%CD%
SET WORKING_DIR=%1
if "%WORKING_DIR%" == "" goto no_working_dir

if not exist "%WORKING_DIR% mkdir" mkdir "%WORKING_DIR%"
if not exist "%WORKING_DIR%\x64_release" mkdir "%WORKING_DIR%\x64_release"
if not exist "%WORKING_DIR%\x86_release" mkdir "%WORKING_DIR%\x86_release"

SET PACKAGE_DIR=%CD%\packages
SET USE_CMAKE_GENERATOR_X86=Visual Studio 14 2015
SET USE_CMAKE_GENERATOR_X64=Visual Studio 14 2015 Win64
SET USE_CMAKE_VSTOOLSET=v140

echo CMake Generator (32-bit): %USE_CMAKE_GENERATOR_X86%
echo CMake Generator (64-bit): %USE_CMAKE_GENERATOR_X64%

REM pushd "%WORKING_DIR%\x86_release"
REM cmake -G "%USE_CMAKE_GENERATOR_X86%" -DCMAKE_BUILD_TYPE=Release -DMG_CPU=32 -DMG_PACKAGE_DIR="%PACKAGE_DIR%" %THIS_DIR%
REM if %errorlevel% neq 0 goto error
REM cmake --build . --config Release
REM if %errorlevel% neq 0 goto error
REM popd
pushd "%WORKING_DIR%\x64_release"
cmake -G "%USE_CMAKE_GENERATOR_X64%" -DCMAKE_BUILD_TYPE=Release -DMG_CPU=64 -DMG_PACKAGE_DIR="%PACKAGE_DIR%" %THIS_DIR%
if %errorlevel% neq 0 goto error
cmake --build . --config Release
if %errorlevel% neq 0 goto error
popd

pushd src\Bindings\DotNet\MapGuideDotNetApi
call dotnet restore
if %errorlevel% neq 0 goto error
call dotnet pack --configuration Release --output "%PACKAGE_DIR%"
if %errorlevel% neq 0 goto error
popd
pushd src\Tools\PhpPostProcess
echo Running PHP post-processor
call dotnet run "%PACKAGE_DIR%\php\Release"
if %errorlevel% neq 0 goto error
call dotnet run "%PACKAGE_DIR%\php\Release64"
if %errorlevel% neq 0 goto error
popd
echo Building Sample dataset
pushd src\TestData\Samples\Sheboygan
call build.bat
if %errorlevel% neq 0 goto error
popd
goto end
:no_working_dir
echo Must specify working directory
echo Usage: cmake_build.cmd [path to working directory]
:error
echo An error occurred while building a component
popd
:end