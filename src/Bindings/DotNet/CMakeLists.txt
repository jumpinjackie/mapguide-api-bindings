project(MapGuideDotNetUnmanagedApi)

include_directories(
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

if (MSVC)
    add_definitions(-DSWIG_PUBLIC_API)
    add_definitions(-bigobj)
endif (MSVC)

set(DotNetUnmanagedApi_SRCS
    ${CMAKE_CURRENT_BINARY_DIR}/MgApi_wrap.cpp
)
message(STATUS "Using IMake at: ${IMAKE_TOOL}")
add_custom_command(OUTPUT ${DotNetUnmanagedApi_SRCS}
    COMMAND ${CMAKE_COMMAND} -E remove -f 
            ${CMAKE_CURRENT_BINARY_DIR}/MapGuideDotNetApi/*.cs
    COMMAND ${IMAKE_TOOL} -p ${CMAKE_CURRENT_BINARY_DIR}/../MapGuideApi/Constants.xml 
            -l "C#"
            -r ${CMAKE_CURRENT_SOURCE_DIR}
            -o ${CMAKE_CURRENT_BINARY_DIR}/MapGuideDotNetApi/Constants.cs
            -t
    COMMAND ${CMAKE_COMMAND} -E copy
            ${CMAKE_CURRENT_BINARY_DIR}/dotnetcore.i
            ${CMAKE_CURRENT_BINARY_DIR}/language.i
    COMMAND ${IMAKE_TOOL} -p ${CMAKE_CURRENT_BINARY_DIR}/../MapGuideApi/MapGuideApiGen.xml
            -l "C#"
            -r ${CMAKE_CURRENT_SOURCE_DIR}
            -o ${CMAKE_CURRENT_BINARY_DIR}
    COMMAND ${SWIG_TOOL} -c++ -csharp 
            -DDOTNETCORE -DWIN32 -DSWIG_CSHARP_NO_EXCEPTION_HELPER
            -DSWIG_CSHARP_NO_STRING_HELPER -DSWIG_CSHARP_NO_WSTRING_HELPER
            -namespace OSGeo.MapGuide
            -nodefaultctor -nodefaultdtor
            -module MapGuideDotNetUnmanagedApi
            -o "${CMAKE_CURRENT_BINARY_DIR}/MgApi_wrap.cpp"
            -outdir "${CMAKE_CURRENT_BINARY_DIR}/MapGuideDotNetApi" 
            "${CMAKE_CURRENT_BINARY_DIR}/MapGuideApi.i"
    COMMAND ${CMAKE_COMMAND} -E remove -f 
            ${CMAKE_CURRENT_BINARY_DIR}/MapGuideDotNetApi/MapGuideDotNetUnmanagedApi.cs
)

file(COPY "dotnetcore.i" DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
file(COPY "MapGuideDotNetApi" DESTINATION ${CMAKE_CURRENT_BINARY_DIR})

add_library(MapGuideDotNetUnmanagedApi${MG_VERSION_SUFFIX} SHARED ${DotNetUnmanagedApi_SRCS})
add_dependencies(MapGuideDotNetUnmanagedApi${MG_VERSION_SUFFIX} IMake)
target_link_libraries(MapGuideDotNetUnmanagedApi${MG_VERSION_SUFFIX}
    ${ACE_LIBRARY}
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