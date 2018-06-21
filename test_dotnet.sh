pushd src/Test/DotNet
dotnet add src/TestCommon package MapGuideDotNetApi
dotnet add src/TestMapGuideApi package MapGuideDotNetApi
dotnet add src/TestRunner package MapGuideDotNetApi
dotnet restore DotNet.sln
dotnet build --configuration Release DotNet.sln
popd
pushd src/Test/DotNet/src/TestRunner
dotnet run -f netcoreapp2.0 "/usr/local/mapguideopensource-3.1.1/webserverextensions/www/webconfig.ini" "/usr/local/mapguideopensource-3.1.1/share/gis/coordsys"
popd