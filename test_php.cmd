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
echo Using configuration: %CONFIG%
set PHP_ENV=%CD%\runtimes\php\%CONFIG%
set PHP_EXT_DIR=%PHP_ENV%\ext
copy /Y "%CD%\sdk\%MG_VERSION%\%BINPREFIX%\*.dll" "%PHP_ENV%"
copy /Y "%CD%\packages\php\%CONFIG%\php_MapGuideApi.*" "%PHP_EXT_DIR%"
copy /Y "%CD%\packages\php\%CONFIG%\*.php" "%CD%\src\Test\Php"
pushd %CD%\src\Test\Php
set PHP_ARGS=-n -d display_errors=On -d extension_dir="%PHP_EXT_DIR%" -d extension=php_mbstring.dll -d extension=php_curl.dll -d extension=php_pdo_sqlite.dll -d extension=php_MapGuideApi.dll
%PHP_ENV%\php.exe %PHP_ARGS% RunTests.php -config "%MG_INSTALL_DIR%\Web\www\webconfig.ini"
REM %PHP_ENV%\php.exe %PHP_ARGS% Test1.php
popd