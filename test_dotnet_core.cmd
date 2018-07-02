@echo off
IF "%MG_PKG_VER%"=="" (
    echo Could not determine NuGet package version. This should've been set by envsetupsdk.cmd
    exit /B 1
)
SET THIS_DIR=%CD%
SET MG_INSTALL_DIR=%1
IF "%MG_INSTALL_DIR%" == "" (
    SET MG_INSTALL_DIR=C:\Program Files\OSGeo\MapGuide
)
pushd src\Test\DotNet
dotnet add src\TestCommon package MapGuideDotNetApi --version %MG_PKG_VER%
dotnet add src\TestMapGuideApi package MapGuideDotNetApi --version %MG_PKG_VER%
dotnet add src\TestRunner package MapGuideDotNetApi --version %MG_PKG_VER%
dotnet add src\TestMisc package MapGuideDotNetApi --version %MG_PKG_VER%
dotnet restore DotNet.sln
dotnet build --configuration Release DotNet.sln
popd
pushd src\Test\DotNet\src\TestRunner
dotnet run -f netcoreapp2.1 --web-config-path "%MG_INSTALL_DIR%\Web\www\webconfig.ini" --dictionary-path "%MG_INSTALL_DIR%\CS-Map\Dictionaries" --test-data-root %THIS_DIR%\src\TestData
popd