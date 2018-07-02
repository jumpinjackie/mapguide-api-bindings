@echo off
IF "%MG_PKG_VER%"=="" (
    echo Could not determine NuGet package version. This should've been set by envsetupsdk.cmd
    exit /B 1
)
which nuget
if %errorlevel% neq 0 (
    echo NuGet command-line tool not installed
    exit /b 1
)
SET THIS_DIR=%CD%
SET MG_INSTALL_DIR=%1
IF "%MG_INSTALL_DIR%" == "" (
    SET MG_INSTALL_DIR=C:\Program Files\OSGeo\MapGuide
)
pushd src\Test\DotNet
dotnet add src\TestCommonFull package MapGuideDotNetApi --version %MG_PKG_VER%
if %errorlevel% neq 0 goto error_popd
dotnet add src\TestMapGuideApiFull package MapGuideDotNetApi --version %MG_PKG_VER%
if %errorlevel% neq 0 goto error_popd
dotnet add src\TestRunnerFull package MapGuideDotNetApi --version %MG_PKG_VER%
if %errorlevel% neq 0 goto error_popd
dotnet add src\TestMiscFull package MapGuideDotNetApi --version %MG_PKG_VER%
if %errorlevel% neq 0 goto error_popd
nuget restore FullFramework.sln
if %errorlevel% neq 0 goto error_popd
msbuild /p:Configuration=Release FullFramework.sln
if %errorlevel% neq 0 goto error_popd
popd
pushd src\Test\DotNet\src\TestRunnerFull\bin\x64\Release\net461
TestRunnerFull --web-config-path "%MG_INSTALL_DIR%\Web\www\webconfig.ini" --dictionary-path "%MG_INSTALL_DIR%\CS-Map\Dictionaries" --test-data-root %THIS_DIR%\src\TestData
if %errorlevel% neq 0 goto error_popd
popd
goto done
:error_popd
popd
:error
exit /b 1
:done