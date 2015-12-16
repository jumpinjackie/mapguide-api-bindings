SET MG_SRC_DIR=%1
SET MG_VERSION=%2

pushd "src/MapGuide"
if exist "%MG_VERSION%" (
    rmdir "%MG_VERSION%"
    echo Removed old %MG_VERSION% symlink
)
mklink /D "%MG_VERSION%" "%MG_SRC_DIR%"
echo Created symbolic link [%MG_VERSION%] to [%MG_SRC_DIR%]
popd