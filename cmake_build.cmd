@echo off
REM Test for CMake
which cmake
if %errorlevel% neq 0 (
    echo CMake not found
    goto error
)
REM Test for Ninja
REM which ninja
REM if %errorlevel% neq 0 (
REM     echo Ninja not found
REM     goto error
REM )
SET WITH_JAVA=1
SET WITH_PHP=1
SET WITH_DOTNET=1
SET THIS_DIR=%CD%
SET WORKING_DIR=%1
if "%WORKING_DIR%" == "" goto no_working_dir

if not exist "%WORKING_DIR% mkdir" mkdir "%WORKING_DIR%"
if not exist "%WORKING_DIR%\x64_release" mkdir "%WORKING_DIR%\x64_release"
if not exist "%WORKING_DIR%\x86_release" mkdir "%WORKING_DIR%\x86_release"

SET PACKAGE_DIR=%CD%\packages
SET USE_CMAKE_GENERATOR_X86=Visual Studio 14 2015
SET USE_CMAKE_GENERATOR_X64=Visual Studio 14 2015 Win64
REM SET USE_CMAKE_GENERATOR_X86=Ninja
REM SET USE_CMAKE_GENERATOR_X64=Ninja
SET USE_CMAKE_VSTOOLSET=v140

echo CMake Generator (32-bit): %USE_CMAKE_GENERATOR_X86%
echo CMake Generator (64-bit): %USE_CMAKE_GENERATOR_X64%

pushd "%WORKING_DIR%\x86_release"
cmake -G "%USE_CMAKE_GENERATOR_X86%" -DCMAKE_BUILD_TYPE=Release -DSWIG_WIN_PATH=%SWIG_TOOL_PATH% -DMG_CPU=32 -DWITH_JAVA=%WITH_JAVA% -DWITH_DOTNET=%WITH_DOTNET% -DWITH_PHP=%WITH_PHP% -DMG_PACKAGE_DIR="%PACKAGE_DIR%" %THIS_DIR%
if %errorlevel% neq 0 goto error
cmake --build . --config Release
if %errorlevel% neq 0 goto error
popd
pushd "%WORKING_DIR%\x64_release"
cmake -G "%USE_CMAKE_GENERATOR_X64%" -DCMAKE_BUILD_TYPE=Release -DSWIG_WIN_PATH=%SWIG_TOOL_PATH% -DMG_CPU=64 -DWITH_JAVA=%WITH_JAVA% -DWITH_DOTNET=%WITH_DOTNET% -DWITH_PHP=%WITH_PHP% -DMG_PACKAGE_DIR="%PACKAGE_DIR%" %THIS_DIR%
if %errorlevel% neq 0 goto error
cmake --build . --config Release
if %errorlevel% neq 0 goto error
popd
if "%WITH_DOTNET%" == "1" (
    pushd src\Bindings\DotNet\MapGuideDotNetApi
    call dotnet restore
    if %errorlevel% neq 0 goto error
    call dotnet pack --configuration Release --output "%PACKAGE_DIR%"
    if %errorlevel% neq 0 goto error
    popd
)
if "%WITH_PHP%" == "1" (
    pushd src\Tools\PhpPostProcess
    echo Running PHP post-processor
    call dotnet run "%PACKAGE_DIR%\php\Release\x86"
    if %errorlevel% neq 0 goto error
    call dotnet run "%PACKAGE_DIR%\php\Release\x64"
    if %errorlevel% neq 0 goto error
    popd
)
echo Building Sample dataset
pushd src\TestData\Samples\Sheboygan
call build.bat
if %errorlevel% neq 0 goto error
popd
goto end
:no_working_dir
echo Must specify working directory
echo Usage: cmake_build.cmd [path to working directory] [path to swig directory]
goto error
:no_swig
echo Cannot find swig
echo Usage: cmake_build.cmd [path to working directory] [path to swig directory]
goto error
:error
echo An error occurred while building a component
popd
:end