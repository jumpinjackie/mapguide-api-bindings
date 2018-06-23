THIS_DIR=`pwd`
check_test()
{
    error=$?
    if [ $error -ne 0 ]; then
        echo "[warning]: ${TEST_COMPONENT} - Test returned non-zero result ($error)"
    else
        echo "[test]: ${TEST_COMPONENT} - Test returned exit code ($error)"	
    fi
}
pushd src/Test/DotNet
TEST_COMPONENT="Add MapGuideDotNetApi (TestCommon)"
dotnet add src/TestCommon package MapGuideDotNetApi
check_test
TEST_COMPONENT="Add MapGuideDotNetApi (TestMapGuideApi)"
dotnet add src/TestMapGuideApi package MapGuideDotNetApi
check_test
TEST_COMPONENT="Add MapGuideDotNetApi (TestRunner)"
dotnet add src/TestRunner package MapGuideDotNetApi
check_test
TEST_COMPONENT="Add MapGuideDotNetApi (TestMisc)"
dotnet add src/TestMisc package MapGuideDotNetApi
check_test
TEST_COMPONENT="dotnet restore"
dotnet restore DotNet.sln
check_test
TEST_COMPONENT="dotnet build"
dotnet build --configuration Release DotNet.sln
check_test
popd
pushd src/Test/DotNet/src/TestRunner
TEST_COMPONENT=".net Core Test Suite"
dotnet run -f netcoreapp2.1 --web-config-path "/usr/local/mapguideopensource-3.1.1/webserverextensions/www/webconfig.ini" --dictionary-path "/usr/local/mapguideopensource-3.1.1/share/gis/coordsys" --test-data-root $THIS_DIR/src/TestData
check_test
popd