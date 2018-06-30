@echo off
SET MG_CONFIG=Release
IF "%MG_VERSION%"=="3.3" SET MG_CONFIG=Release_VC14
IF "%MG_VERSION%"=="3.1" SET MG_CONFIG=Release_VC14
IF "%MG_VERSION%"=="3.0" SET MG_CONFIG=Release_VC11
IF "%MG_VERSION%"=="2.6" SET MG_CONFIG=Release_VC11
SET PACKAGE_DIR=%CD%\packages
SET TOOLS_DIR=%CD%\tools
echo Using configuration [%MG_CONFIG%]
pushd src\Bindings
msbuild /m /p:Configuration=%MG_CONFIG%;Platform=x86 Bindings.sln
if errorlevel 1 goto error
msbuild /m /p:Configuration=%MG_CONFIG%;Platform=x64 Bindings.sln
if errorlevel 1 goto error
popd
pushd src\Managed\DotNet\MapGuideDotNetApi
call dotnet restore
if errorlevel 1 goto error
call dotnet pack --configuration Release --output "%PACKAGE_DIR%"
if errorlevel 1 goto error
popd
pushd src\Managed\Java
echo Building java classes...
"%JAVA_HOME%\bin\javac" -classpath . org\osgeo\mapguide\*.java
echo Building JAR file
"%JAVA_HOME%\bin\jar" cf %PACKAGE_DIR%\Java\Release\x86\MapGuideApi.jar org\osgeo\mapguide\*.class
echo Building -sources JAR file
"%JAVA_HOME%\bin\jar" cf %PACKAGE_DIR%\Java\Release\x86\MapGuideApi-sources.jar org\osgeo\mapguide\*.java
copy /Y %PACKAGE_DIR%\Java\Release\x86\*.jar %PACKAGE_DIR%\Java\Release\x64
popd
echo Running PHP post-processor
%TOOLS_DIR%\PhpPostProcess "%PACKAGE_DIR%\php\Release\x86\MapGuideApi.php"
%TOOLS_DIR%\PhpPostProcess "%PACKAGE_DIR%\php\Release\x64\MapGuideApi.php"
echo Building Sample dataset
pushd src\TestData\Samples\Sheboygan
call build.bat
popd
goto end
:error
echo An error occurred while building a component
popd
:end