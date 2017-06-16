pushd src\Test\Dnx
call dotnet add src\TestCommon package MapGuideDotNetApi
call dotnet add src\TestMapGuideApi package MapGuideDotNetApi
call dotnet add src\TestRunner package MapGuideDotNetApi
call dotnet restore
call dotnet build
popd