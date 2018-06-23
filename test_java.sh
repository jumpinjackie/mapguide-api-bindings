THIS_DIR=`pwd`
DISTRO=$(./get_distro.sh)
TEST_PLAT=$(uname -p)
TEST_ARCH=x86
if [ "$TEST_PLAT" = "x86_64" ]; then
    TEST_ARCH=x64
fi

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
MG_JARPATH=$THIS_DIR/packages/Java/Release/${TEST_ARCH}
MG_LD_PATH=$THIS_DIR/packages/Java/Release/${TEST_ARCH}/${DISTRO}
MG_RES_PATH=/usr/local/mapguideopensource-3.1.1/webserverextensions/www/Resources/mapguide_en.res
MG_WEBCONFIG=/usr/local/mapguideopensource-3.1.1/webserverextensions/www/webconfig.ini
MG_DICT_PATH=/usr/local/mapguideopensource-3.1.1/share/gis/coordsys
ant checkunix -Djarsrc.web=$MG_JARPATH -Dmapguide.dictpath=$MG_DICT_PATH -Dmapguide.ldpath=$MG_LD_PATH -Dmapguide.res.src=$MG_RES_PATH -Dmapguide.config.src=$MG_WEBCONFIG
check_test
popd