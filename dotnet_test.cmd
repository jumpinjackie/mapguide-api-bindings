pushd src\Test\Dnx
dotnet add src\TestCommon package MapGuideDotNetApi
dotnet add src\TestMapGuideApi package MapGuideDotNetApi
dotnet add src\TestRunner package MapGuideDotNetApi
dotnet restore
dotnet build
popd