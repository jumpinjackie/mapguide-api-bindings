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

set(DotNetUnmanagedApi_SRCS
    ${CMAKE_CURRENT_BINARY_DIR}/MgApi_wrap.cpp
)

add_library(MapGuideDotNetUnmanagedApi${MG_VERSION_SUFFIX} SHARED ${DotNetUnmanagedApi_SRCS})
add_dependencies(MapGuideDotNetUnmanagedApi${MG_VERSION_SUFFIX} IMake)
if (UNIX)
    add_definitions(-DDOTNETCORE)
endif (UNIX)
if (MSVC)
    add_definitions(-DSWIG_PUBLIC_API)
    add_definitions(/bigobj)
    set_target_properties(MapGuideDotNetUnmanagedApi${MG_VERSION_SUFFIX} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${MG_DOTNET_OUTPUT_DIR} )
    set_target_properties(MapGuideDotNetUnmanagedApi${MG_VERSION_SUFFIX} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG ${MG_DOTNET_OUTPUT_DIR} )
    set_target_properties(MapGuideDotNetUnmanagedApi${MG_VERSION_SUFFIX} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE ${MG_DOTNET_OUTPUT_DIR} )
endif (MSVC)

set(IMAKE_RELATIVE_RESOLUTION "-r ${CMAKE_CURRENT_SOURCE_DIR}")
if (UNIX)
    set(IMAKE_RELATIVE_RESOLUTION "-a")
endif (UNIX)

set(SWIG_DOTNET_DEFS "")
if (WIN32)
    set(SWIG_DOTNET_DEFS "-DWIN32")
endif (WIN32)

message(STATUS "Using IMake at: ${IMAKE_TOOL}")
add_custom_command(OUTPUT ${DotNetUnmanagedApi_SRCS}
    COMMAND ${CMAKE_COMMAND} -E echo Removing: ${MG_DOTNET_PROJECT_DIR}/*.cs
    COMMAND ${CMAKE_COMMAND} -E remove -f 
            ${MG_DOTNET_PROJECT_DIR}/*.cs
    COMMAND ${CMAKE_COMMAND} -E echo Regenerating: ${MG_DOTNET_PROJECT_DIR}/Constants.cs
    COMMAND ${IMAKE_TOOL} -p ${CMAKE_CURRENT_BINARY_DIR}/../MapGuideApi/Constants.xml 
            -l "C#"
            ${IMAKE_RELATIVE_RESOLUTION}
            -o ${MG_DOTNET_PROJECT_DIR}/Constants.cs
            -t
    COMMAND ${CMAKE_COMMAND} -E copy
            ${CMAKE_CURRENT_BINARY_DIR}/dotnetcore.i
            ${CMAKE_CURRENT_BINARY_DIR}/language.i
    COMMAND ${IMAKE_TOOL} -p ${CMAKE_CURRENT_BINARY_DIR}/../MapGuideApi/MapGuideApiGen.xml
            -l "C#"
            ${IMAKE_RELATIVE_RESOLUTION}
            -o ${CMAKE_CURRENT_BINARY_DIR}
    COMMAND ${CMAKE_COMMAND} -E echo Running SWIG [DotNet]. Output Dir: ${MG_DOTNET_PROJECT_DIR}
    COMMAND ${SWIG_TOOL} -c++ -csharp 
            ${SWIG_DOTNET_DEFS} -DDOTNETCORE -DSWIG_CSHARP_NO_EXCEPTION_HELPER
            -DSWIG_CSHARP_NO_STRING_HELPER -DSWIG_CSHARP_NO_WSTRING_HELPER
            -namespace OSGeo.MapGuide
            -nodefaultctor -nodefaultdtor
            -module MapGuideDotNetUnmanagedApi
            -o "${CMAKE_CURRENT_BINARY_DIR}/MgApi_wrap.cpp"
            -outdir "${MG_DOTNET_PROJECT_DIR}" 
            "${CMAKE_CURRENT_BINARY_DIR}/MapGuideApi.i"
    COMMAND ${CMAKE_COMMAND} -E remove -f 
            ${MG_DOTNET_PROJECT_DIR}/MapGuideDotNetUnmanagedApi.cs
)

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

# Only needed for Linux
if (UNIX)
    file(COPY "InitializeWebTier.cpp" DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
    install( TARGETS MapGuideDotNetUnmanagedApi${MG_VERSION_SUFFIX} DESTINATION ${MG_DOTNET_OUTPUT_DIR})
endif (UNIX)

file(COPY "dotnetcore.i" DESTINATION ${CMAKE_CURRENT_BINARY_DIR})