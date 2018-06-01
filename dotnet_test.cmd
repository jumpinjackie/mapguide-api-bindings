@echo off
SET MG_INSTALL_DIR=%1
IF "%MG_INSTALL_DIR%" == "" (
    SET MG_INSTALL_DIR=C:\Program Files\OSGeo\MapGuide
)
pushd src\Test\DotNet
dotnet add src\TestCommon package MapGuideDotNetApi
dotnet add src\TestMapGuideApi package MapGuideDotNetApi
dotnet add src\TestRunner package MapGuideDotNetApi
dotnet restore
dotnet build --configuration Release
popd
pushd src\Test\DotNet\src\TestRunner
dotnet run -f netcoreapp2.0 "%MG_INSTALL_DIR%\Web\www\webconfig.ini" "%MG_INSTALL_DIR%\CS-Map\Dictionaries"
popd