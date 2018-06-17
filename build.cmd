@echo off
SET MG_CONFIG=Release
IF "%MG_VERSION%"=="3.3" SET MG_CONFIG=Release_VC14
IF "%MG_VERSION%"=="3.1" SET MG_CONFIG=Release_VC14
IF "%MG_VERSION%"=="3.0" SET MG_CONFIG=Release_VC11
IF "%MG_VERSION%"=="2.6" SET MG_CONFIG=Release_VC11
SET PACKAGE_DIR=%CD%\packages
echo Using configuration [%MG_CONFIG%]
pushd src\Bindings
msbuild /p:Configuration=%MG_CONFIG%;Platform=x86 Bindings.sln
if errorlevel 1 goto error
msbuild /p:Configuration=%MG_CONFIG%;Platform=x64 Bindings.sln
if errorlevel 1 goto error
popd
pushd src\Bindings\DotNet\MapGuideDotNetApi
call dotnet restore
if errorlevel 1 goto error
call dotnet pack --configuration Release --output "%PACKAGE_DIR%"
if errorlevel 1 goto error
popd
pushd src\Tools\PhpPostProcess
echo Running PHP post-processor
call dotnet run "%PACKAGE_DIR%\php\Release\x86"
call dotnet run "%PACKAGE_DIR%\php\Release\x64"
popd
echo Building Sample dataset
pushd src\TestData\Samples\Sheboygan
call build.bat
popd
goto end
:error
echo An error occurred while building a component
popd
:end