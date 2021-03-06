project(MapGuideJavaApi)

include_directories(${JNI_INCLUDE_DIRS}
    ${MG_COMMON_DIR}/MdfModel
    ${MG_COMMON_DIR}/Foundation
    ${MG_COMMON_DIR}/Geometry
    ${MG_COMMON_DIR}/PlatformBase
    ${MG_COMMON_DIR}/MapGuideCommon
    ${ACE_INCLUDE_DIR}
    ${MG_WEB_DIR}/HttpHandler
    ${MG_WEB_DIR}/WebSupport
    ${MG_WEB_DIR}/WebApp
    ${XERCESC_INCLUDE_DIR}
)

set(SWIG_JAVA_DEFS "")
if (WIN32)
    set(SWIG_JAVA_DEFS "-DWIN32")
endif (WIN32)

set(MG_JAVA_OUTPUT_DIR "${MG_PACKAGE_OUTPUT_DIR}/Java/${CMAKE_BUILD_TYPE}/${MG_ARCH}")

set(MapGuideJavaApi_SRCS
    ${CMAKE_CURRENT_BINARY_DIR}/MgApi_wrap.cpp
)

set(IMAKE_RELATIVE_RESOLUTION "-r ${CMAKE_CURRENT_SOURCE_DIR}")
if (UNIX)
    set(IMAKE_RELATIVE_RESOLUTION "-a")
endif (UNIX)

message(STATUS "Using IMake at: ${IMAKE_TOOL}")
add_custom_command(OUTPUT ${MapGuideJavaApi_SRCS}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${MG_JAVA_OUTPUT_DIR}
    COMMAND ${CMAKE_COMMAND} -E echo Regenerating constant classes
    COMMAND ${IMAKE_TOOL} -p ${CMAKE_CURRENT_BINARY_DIR}/../MapGuideApi/Constants.xml 
            -l Java 
            ${IMAKE_RELATIVE_RESOLUTION}
            -o ${MG_JAVA_PROJECT_DIR}/org/osgeo/mapguide
            -t
    COMMAND ${CMAKE_COMMAND} -E copy
            ${CMAKE_CURRENT_BINARY_DIR}/java.i
            ${CMAKE_CURRENT_BINARY_DIR}/language.i
    COMMAND ${IMAKE_TOOL} -p ../MapGuideApi/MapGuideApiGen.xml
            -l Java
            ${IMAKE_RELATIVE_RESOLUTION}
            -o ${CMAKE_CURRENT_BINARY_DIR}
    COMMAND ${CMAKE_COMMAND} -E echo Running SWIG [Java]
    COMMAND ${SWIG_TOOL} -c++ -java
            -DJAVA ${SWIG_JAVA_DEFS} 
            -package org.osgeo.mapguide 
            -nodefaultctor -nodefaultdtor 
            -module MapGuideJavaApi 
            -o "${CMAKE_CURRENT_BINARY_DIR}/MgApi_wrap.cpp" 
            ${CMAKE_CURRENT_BINARY_DIR}/MapGuideApi.i
    COMMAND ${CMAKE_COMMAND} -E remove -f 
            ${MG_JAVA_PROJECT_DIR}/org/osgeo/mapguide/*.class 
    COMMAND ${MOVE_COMMAND} ${MOVE_ARGS}
            *.java
            ${MG_JAVA_PROJECT_DIR}/org/osgeo/mapguide
)

add_library(MapGuideJavaApi${MG_VERSION_SUFFIX} SHARED ${MapGuideJavaApi_SRCS})
add_definitions(-DJAVA -DSWIG_PUBLIC_API)
if (UNIX)
    add_definitions(-fno-strict-aliasing -fno-var-tracking-assignments)
endif (UNIX)
if (MSVC)
    add_definitions(/bigobj)
    set_target_properties(MapGuideJavaApi${MG_VERSION_SUFFIX} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${MG_JAVA_OUTPUT_DIR} )
    set_target_properties(MapGuideJavaApi${MG_VERSION_SUFFIX} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG ${MG_JAVA_OUTPUT_DIR} )
    set_target_properties(MapGuideJavaApi${MG_VERSION_SUFFIX} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE ${MG_JAVA_OUTPUT_DIR} )
endif (MSVC)
add_dependencies(MapGuideJavaApi${MG_VERSION_SUFFIX} IMake)

# if (UNIX)
#     install(TARGETS MapGuideJavaApi${MG_VERSION_SUFFIX} DESTINATION ${LIB_INSTALL_DIR} COMPONENT ${MG_COMPONENT})
#     install_symlink(${CMAKE_INSTALL_PREFIX}/${LIB_INSTALL_DIR}/libMapGuideJavaApi${MG_VERSION_SUFFIX}.so libMapGuideJavaApi.so ${MG_COMPONENT})
#     set(MG_JARS
#         "${MG_JAVA_OUTPUT_DIR}/MapGuideApi.jar"
#         "${MG_JAVA_OUTPUT_DIR}/MapGuideApi-sources.jar"
#     )
#     install(FILES ${MG_JARS} DESTINATION ${MG_WWWROOT}/WEB-INF/lib)
# endif (UNIX)
target_link_libraries(MapGuideJavaApi${MG_VERSION_SUFFIX}
    ${ACE_LIBRARY}
    #${JNI_LIBRARIES}
    ${MG_FOUNDATION_LIBRARY}
    ${MG_GEOMETRY_LIBRARY}
    ${MG_PLATFORMBASE_LIBRARY}
    ${MG_COMMON_LIBRARY}
    ${MG_HTTPHANDLER_LIBRARY}
    ${MG_WEBAPP_LIBRARY}
    ${MG_MDFMODEL_LIBRARY}
    ${MG_MDFPARSER_LIBRARY}
    ${MG_WEBSUPPORT_LIBRARY}
    #MgFoundation${MG_VERSION_SUFFIX}
    #MgGeometry${MG_VERSION_SUFFIX}
    #MgPlatformBase${MG_VERSION_SUFFIX}
    #MgMapGuideCommon${MG_VERSION_SUFFIX}
    #MgHttpHandler${MG_VERSION_SUFFIX}
    #MgMdfModel${MG_VERSION_SUFFIX}
    #MgMdfParser${MG_VERSION_SUFFIX}
    ${XERCESC_LIBRARIES}
    #MgWebApp${MG_VERSION_SUFFIX}
)

# Only needed for Linux
if (UNIX)
    file(COPY "InitializeWebTier.cpp" DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
    install( TARGETS MapGuideJavaApi${MG_VERSION_SUFFIX} DESTINATION "${MG_JAVA_OUTPUT_DIR}/${MG_DISTRO}" )
endif (UNIX)

file(COPY "java.i" DESTINATION ${CMAKE_CURRENT_BINARY_DIR})