project(php_MapGuideApi)

if (CMAKE_COMPILER_IS_GNUCXX)
    message ("Restoring default linker flags for libphp_MapGuideApi")
    set ( CMAKE_SHARED_LINKER_FLAGS "${WEB_CMAKE_SHARED_LINKER_FLAGS}")
endif (CMAKE_COMPILER_IS_GNUCXX)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}
    ${MG_COMMON_DIR}/MdfModel
    ${MG_COMMON_DIR}/Foundation
    ${MG_COMMON_DIR}/Geometry
    ${MG_COMMON_DIR}/PlatformBase
    ${MG_COMMON_DIR}/MapGuideCommon
    ${PHP_INCLUDE_DIR}/TSRM
    ${PHP_INCLUDE_DIR}/Zend
    ${PHP_INCLUDE_DIR}/main
    ${PHP_INCLUDE_DIR}
    ${ACE_INCLUDE_DIR}
    ${MG_WEB_DIR}/HttpHandler
    ${MG_WEB_DIR}/WebSupport
    ${MG_WEB_DIR}/WebApp
    ${XERCESC_INCLUDE_DIR}
)

set(MG_PHP_OUTPUT_DIR "${MG_PACKAGE_OUTPUT_DIR}/Php/${CMAKE_BUILD_TYPE}/${MG_ARCH}")

set(php_MapGuideApi_SRCS
    ${CMAKE_CURRENT_BINARY_DIR}/MgApi_wrap.cpp
)

add_library(php_MapGuideApi${MG_VERSION_SUFFIX} SHARED ${php_MapGuideApi_SRCS})
add_dependencies(php_MapGuideApi${MG_VERSION_SUFFIX} IMake)
add_definitions(-DPHP -DPHPPROXYAPI_EXPORTS)
if (UNIX)
    add_definitions(-fno-var-tracking-assignments)
endif (UNIX)
if (MSVC)
    add_definitions(-DSWIG_PUBLIC_API -D_XKEYCHECK_H -DZEND_WIN32 -DPHP_WIN32 -DZEND_DEBUG=0 -DZTS=1)
    if (MG_CPU EQUAL 32)
        add_definitions(-D_USE_32BIT_TIME_T)
    endif (MG_CPU EQUAL 32)
    add_definitions(-bigobj)
    set_target_properties(php_MapGuideApi${MG_VERSION_SUFFIX} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${MG_PHP_OUTPUT_DIR} )
    set_target_properties(php_MapGuideApi${MG_VERSION_SUFFIX} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG ${MG_PHP_OUTPUT_DIR} )
    set_target_properties(php_MapGuideApi${MG_VERSION_SUFFIX} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE ${MG_PHP_OUTPUT_DIR} )
endif (MSVC)

add_custom_command(OUTPUT ${php_MapGuideApi_SRCS}
    COMMAND ${IMAKE_TOOL} -p ${CMAKE_CURRENT_BINARY_DIR}/../MapGuideApi/Constants.xml 
        -l PHP 
        -r ${CMAKE_CURRENT_SOURCE_DIR}
        -o ${CMAKE_CURRENT_BINARY_DIR}/constants.php
        -t
    COMMAND ${CMAKE_COMMAND} -E copy
        ${CMAKE_CURRENT_BINARY_DIR}/php.i
        ${CMAKE_CURRENT_BINARY_DIR}/language.i
    COMMAND ${IMAKE_TOOL} -p ../MapGuideApi/MapGuideApiGen.xml
        -l PHP
        -r ${CMAKE_CURRENT_SOURCE_DIR}
        -o ${CMAKE_CURRENT_BINARY_DIR}
    COMMAND ${SWIG_TOOL} -c++ -php7 
        -DWIN32 -DPHPSWIG
        -nodefaultctor -nodefaultdtor 
        -o "${CMAKE_CURRENT_BINARY_DIR}/MgApi_wrap_orig.cpp" 
        ${CMAKE_CURRENT_BINARY_DIR}/MapGuideApi.i
    COMMAND ${CMAKE_COMMAND} -E make_directory ${MG_PHP_OUTPUT_DIR}
    COMMAND ${MOVE_COMMAND} ${MOVE_ARGS}
        MapGuideApi.php
        ${MG_PHP_OUTPUT_DIR}
    COMMAND ${MOVE_COMMAND} ${MOVE_ARGS}
        constants.php
        ${MG_PHP_OUTPUT_DIR}
    COMMAND ${SED_COMMAND} "s#(MapGuideApi_globals.error_msg)#ZEND_MODULE_GLOBALS_ACCESSOR(MapGuideApi, error_msg)#g; s#(MapGuideApi_globals.error_code)#ZEND_MODULE_GLOBALS_ACCESSOR(MapGuideApi, error_code)#g"
        "${CMAKE_CURRENT_BINARY_DIR}/MgApi_wrap_orig.cpp" > "${CMAKE_CURRENT_BINARY_DIR}/MgApi_wrap.cpp"
)

if (UNIX)
    install(TARGETS php_MapGuideApi${MG_VERSION_SUFFIX} DESTINATION ${LIB_INSTALL_DIR} COMPONENT ${MG_COMPONENT})
    install_symlink(${CMAKE_INSTALL_PREFIX}/${LIB_INSTALL_DIR}/libphp_MapGuideApi${MG_VERSION_SUFFIX}.so libphp_MapGuideApi.so ${MG_COMPONENT})
    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/constants.php DESTINATION ${MG_WWWROOT}/mapadmin COMPONENT ${MG_COMPONENT})
    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/constants.php DESTINATION ${MG_WWWROOT}/mapviewerphp COMPONENT ${MG_COMPONENT})
endif (UNIX)
target_link_libraries(php_MapGuideApi${MG_VERSION_SUFFIX}
    ${ACE_LIBRARY}
    ${PHP_LIBRARY}
    ${MG_FOUNDATION_LIBRARY}
    ${MG_GEOMETRY_LIBRARY}
    ${MG_PLATFORMBASE_LIBRARY}
    ${MG_COMMON_LIBRARY}
    ${MG_HTTPHANDLER_LIBRARY}
    ${MG_WEBAPP_LIBRARY}
    ${MG_MDFMODEL_LIBRARY}
    ${MG_MDFPARSER_LIBRARY}
    ${MG_WEBSUPPORT_LIBRARY}
    ${XERCESC_LIBRARIES}
)

file(COPY "php.i" DESTINATION ${CMAKE_CURRENT_BINARY_DIR})