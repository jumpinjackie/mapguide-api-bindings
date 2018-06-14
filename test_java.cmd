@echo off
set BINPREFIX=Bin64
set CONFIG=Release64
if "%1" == "Release" (
    set CONFIG=%1
    set BINPREFIX=Bin
)
SET MG_INSTALL_DIR=%2
IF "%MG_INSTALL_DIR%" == "" (
    SET MG_INSTALL_DIR=C:\Program Files\OSGeo\MapGuide
)
echo Preparing native binaries for java test
SET MG_JAVA_BIN_DIR=%CD%\src\Test\Java\lib
SET MG_JAVA_JAR_DIR=%CD%\src\Test\Java\lib
if not exist "%MG_JAVA_BIN_DIR%" mkdir "%MG_JAVA_BIN_DIR%"
if not exist "%MG_JAVA_JAR_DIR%" mkdir "%MG_JAVA_JAR_DIR%"
copy /y "%CD%\sdk\%MG_VERSION%\%BINPREFIX%\*.dll" "%MG_JAVA_BIN_DIR%"
copy /y "%CD%\packages\Java\%CONFIG%\*.dll" "%MG_JAVA_BIN_DIR%"
copy /y "%CD%\packages\Java\%CONFIG%\*.jar" "%MG_JAVA_JAR_DIR%"
pushd "%CD%\src\Test\Java"
call "%ANT_HOME%\bin\ant" checkwin_external -Dmapguide.dictpath="%MG_INSTALL_DIR%\CS-Map\Dictionaries" -Djarsrc.web="%MG_JAVA_JAR_DIR%" -Dbinsrc.web="%MG_JAVA_BIN_DIR%" -Dmapguide.config.src="%MG_INSTALL_DIR%\Web\www\webconfig.ini" -Dmapguide.res.src="%MG_INSTALL_DIR%\Web\www\mapagent\Resources\mapguide_en.res"
if %ERRORLEVEL% neq 0 echo [test]: Java test runner had one or more test failures. Check log files for more information
popd