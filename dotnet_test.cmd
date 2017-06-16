SET MG_INSTALL_DIR=D:\mg-trunk\MgDev\Release64
pushd src\Test\Dnx
dotnet add src\TestCommon package MapGuideDotNetApi
dotnet add src\TestMapGuideApi package MapGuideDotNetApi
dotnet add src\TestRunner package MapGuideDotNetApi
dotnet restore
dotnet build --configuration Release
popd
pushd src\Test\Dnx\src\TestRunner
dotnet run -f netcoreapp1.1 "%MG_INSTALL_DIR%\Web\www\webconfig.ini" "%MG_INSTALL_DIR%\CS-Map\Dictionaries"
popd