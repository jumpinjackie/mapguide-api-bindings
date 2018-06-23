THIS_DIR=`pwd`
DISTRO=$(./get_distro.sh)
check_test()
{
    error=$?
    if [ $error -ne 0 ]; then
        echo "[warning]: ${TEST_COMPONENT} - Test returned non-zero result ($error)"
    else
        echo "[test]: ${TEST_COMPONENT} - Test returned exit code ($error)"	
    fi
}
pushd src/Test/Java
TEST_COMPONENT="Java test suite"
MG_JARPATH=$THIS_DIR/packages/Java/Release/x64
MG_LD_PATH=$THIS_DIR/packages/Java/Release/x64/${DISTRO}
MG_RES_PATH=/usr/local/mapguideopensource-3.1.1/webserverextensions/www/Resources/mapguide_en.res
MG_WEBCONFIG=/usr/local/mapguideopensource-3.1.1/webserverextensions/www/webconfig.ini
ant checkunix -Djarsrc.web=$MG_JARPATH -Dmapguide.ldpath=$MG_LD_PATH -Dmapguide.res.src=$MG_RES_PATH -Dmapguide.config.src=$MG_WEBCONFIG
check_test
popd