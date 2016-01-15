@echo off
SET MG_CONFIG=Release
IF %MG_VERSION%=="3.0" SET MG_CONFIG=Release_VC11
IF %MG_VERSION%=="2.6" SET MG_CONFIG=Release_VC11
pushd src\Bindings
msbuild /p:Configuration=%MG_CONFIG%;Platform=x86 Bindings.sln
if %errorlevel%=="1" goto error
msbuild /p:Configuration=%MG_CONFIG%;Platform=x64 Bindings.sln
if %errorlevel%=="1" goto error
popd
pushd src\Bindings\DotNet\MapGuideDotNetApi
call dnu pack --configuration Release
if %errorlevel%=="1" goto error
popd
goto end
:error
echo An error occurred while building a component
popd
:end