cmake_minimum_required(VERSION 3.0)

if(COMMAND cmake_policy)
    cmake_policy(SET CMP0003 NEW)
    cmake_policy(SET CMP0054 OLD)
endif(COMMAND cmake_policy)

set(EXE ".exe")

# Set common commands.
if (UNIX)
    set(MOVE_COMMAND "mv")
    set(MOVE_ARGS "")
else (UNIX)
    set(MOVE_COMMAND "move")
    set(MOVE_ARGS "/Y")
endif (UNIX)

set(MG_VERSION_MAJOR 3)
set(MG_VERSION_MINOR 1)
set(MG_VERSION_PATCH 1)
set(MG_VERSION "${MG_VERSION_MAJOR}.${MG_VERSION_MINOR}.${MG_VERSION_PATCH}")
set(CMAKE_DEBUG_POSTFIX "d")

set(MG_PACKAGE_OUTPUT_DIR "${CMAKE_CURRENT_BINARY_DIR}/packages")

set(LIB_SUFFIX "lib")
set(LIB_SUFFIX "lib64")

if(WIN32)
    add_definitions(-D_WIN32_WINNT=0x600)
    add_definitions(-DUNICODE -D_UNICODE)
    add_definitions(/MP)
    if(MSVC)
        if(NOT (MSVC14))
            message(FATAL_ERROR, "Only MSVC14 (Visual Studio 2015) is supported compiler on Windows")
        endif(NOT (MSVC14))
    else(MSVC)
        message(FATAL_ERROR, "Only MSVC is the supported compiler on Windows")
    endif(MSVC)
endif(WIN32)

if (MSVC)
    # Prepared MapGuide buildpack headers
    find_path(MG_COMMON_DIR NAMES "Foundation/Foundation.h"
        HINTS "${CMAKE_CURRENT_SOURCE_DIR}/sdk/${MG_VERSION_MAJOR}.${MG_VERSION_MINOR}/Inc/Common"
        NO_DEFAULT_PATH
        NO_CMAKE_ENVIRONMENT_PATH
        NO_CMAKE_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_SYSTEM_PATH
        NO_CMAKE_FIND_ROOT_PATH
    )
    if(NOT MG_COMMON_DIR)
        message(FATAL_ERROR "MapGuide common include path not found")
    else(NOT MG_COMMON_DIR)
        message(STATUS "Found MapGuide common include path: ${MG_COMMON_DIR}")
    endif()
    find_path(ACE_INCLUDE_DIR NAMES "ace/ace_wchar.h"
        HINTS "${CMAKE_CURRENT_SOURCE_DIR}/sdk/${MG_VERSION_MAJOR}.${MG_VERSION_MINOR}/Inc/ACE_Wrappers"
        NO_DEFAULT_PATH
        NO_CMAKE_ENVIRONMENT_PATH
        NO_CMAKE_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_SYSTEM_PATH
        NO_CMAKE_FIND_ROOT_PATH
    )
    if(NOT ACE_INCLUDE_DIR)
        message(FATAL_ERROR "ACE include path not found")
    else(NOT ACE_INCLUDE_DIR)
        message(STATUS "Found ACE include path: ${ACE_INCLUDE_DIR}")
    endif()
    find_path(MG_WEB_DIR NAMES "HttpHandler/HttpHandler.h"
        HINTS "${CMAKE_CURRENT_SOURCE_DIR}/sdk/${MG_VERSION_MAJOR}.${MG_VERSION_MINOR}/Inc/Web"
        NO_DEFAULT_PATH
        NO_CMAKE_ENVIRONMENT_PATH
        NO_CMAKE_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_SYSTEM_PATH
        NO_CMAKE_FIND_ROOT_PATH
    )
    if(NOT MG_WEB_DIR)
        message(FATAL_ERROR "MapGuide web include path not found")
    else(NOT MG_WEB_DIR)
        message(STATUS "Found MapGuide web include path: ${MG_WEB_DIR}")
    endif()
    # Prepared MapGuide buildpack libs
    find_library(ACE_LIBRARIES NAMES ACE
        PATHS "${CMAKE_CURRENT_SOURCE_DIR}/sdk/${MG_VERSION_MAJOR}.${MG_VERSION_MINOR}/${LIB_SUFFIX}"
        NO_DEFAULT_PATH
        NO_CMAKE_ENVIRONMENT_PATH
        NO_CMAKE_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_SYSTEM_PATH
        NO_CMAKE_FIND_ROOT_PATH)
    if(NOT ACE_LIBRARIES)
        message(FATAL_ERROR "ACE library path not found")
    else(NOT ACE_LIBRARIES)
        message(STATUS "Found ACE library path: ${ACE_LIBRARIES}")
    endif()
    find_library(MG_FOUNDATION_LIBRARY NAMES MgFoundation
        PATHS "${CMAKE_CURRENT_SOURCE_DIR}/sdk/${MG_VERSION_MAJOR}.${MG_VERSION_MINOR}/${LIB_SUFFIX}"
        NO_DEFAULT_PATH
        NO_CMAKE_ENVIRONMENT_PATH
        NO_CMAKE_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_SYSTEM_PATH
        NO_CMAKE_FIND_ROOT_PATH)
    if(NOT MG_FOUNDATION_LIBRARY)
        message(FATAL_ERROR "MgFoundation library path not found")
    else(NOT MG_FOUNDATION_LIBRARY)
        message(STATUS "Found MgFoundation library path: ${MG_FOUNDATION_LIBRARY}")
    endif()
    find_library(MG_GEOMETRY_LIBRARY NAMES MgGeometry
        PATHS "${CMAKE_CURRENT_SOURCE_DIR}/sdk/${MG_VERSION_MAJOR}.${MG_VERSION_MINOR}/${LIB_SUFFIX}"
        NO_DEFAULT_PATH
        NO_CMAKE_ENVIRONMENT_PATH
        NO_CMAKE_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_SYSTEM_PATH
        NO_CMAKE_FIND_ROOT_PATH)
    if(NOT MG_GEOMETRY_LIBRARY)
        message(FATAL_ERROR "MgGeometry library path not found")
    else(NOT MG_GEOMETRY_LIBRARY)
        message(STATUS "Found MgGeometry library path: ${MG_GEOMETRY_LIBRARY}")
    endif()
    find_library(MG_PLATFORMBASE_LIBRARY NAMES MgPlatformBase
        PATHS "${CMAKE_CURRENT_SOURCE_DIR}/sdk/${MG_VERSION_MAJOR}.${MG_VERSION_MINOR}/${LIB_SUFFIX}"
        NO_DEFAULT_PATH
        NO_CMAKE_ENVIRONMENT_PATH
        NO_CMAKE_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_SYSTEM_PATH
        NO_CMAKE_FIND_ROOT_PATH)
    if(NOT MG_PLATFORMBASE_LIBRARY)
        message(FATAL_ERROR "MgPlatformBase library path not found")
    else(NOT MG_PLATFORMBASE_LIBRARY)
        message(STATUS "Found MgPlatformBase library path: ${MG_PLATFORMBASE_LIBRARY}")
    endif()
    find_library(MG_COMMON_LIBRARY NAMES MgMapGuideCommon
        PATHS "${CMAKE_CURRENT_SOURCE_DIR}/sdk/${MG_VERSION_MAJOR}.${MG_VERSION_MINOR}/${LIB_SUFFIX}"
        NO_DEFAULT_PATH
        NO_CMAKE_ENVIRONMENT_PATH
        NO_CMAKE_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_SYSTEM_PATH
        NO_CMAKE_FIND_ROOT_PATH)
    if(NOT MG_COMMON_LIBRARY)
        message(FATAL_ERROR "MgMapGuideCommon library path not found")
    else(NOT MG_COMMON_LIBRARY)
        message(STATUS "Found MgMapGuideCommon library path: ${MG_COMMON_LIBRARY}")
    endif()
    find_library(MG_HTTPHANDLER_LIBRARY NAMES HttpHandler
        PATHS "${CMAKE_CURRENT_SOURCE_DIR}/sdk/${MG_VERSION_MAJOR}.${MG_VERSION_MINOR}/${LIB_SUFFIX}"
        NO_DEFAULT_PATH
        NO_CMAKE_ENVIRONMENT_PATH
        NO_CMAKE_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_SYSTEM_PATH
        NO_CMAKE_FIND_ROOT_PATH)
    if(NOT MG_HTTPHANDLER_LIBRARY)
        message(FATAL_ERROR "HttpHandler library path not found")
    else(NOT MG_HTTPHANDLER_LIBRARY)
        message(STATUS "Found HttpHandler library path: ${MG_HTTPHANDLER_LIBRARY}")
    endif()
    find_library(MG_WEBAPP_LIBRARY NAMES WebApp
        PATHS "${CMAKE_CURRENT_SOURCE_DIR}/sdk/${MG_VERSION_MAJOR}.${MG_VERSION_MINOR}/${LIB_SUFFIX}"
        NO_DEFAULT_PATH
        NO_CMAKE_ENVIRONMENT_PATH
        NO_CMAKE_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_SYSTEM_PATH
        NO_CMAKE_FIND_ROOT_PATH)
    if(NOT MG_WEBAPP_LIBRARY)
        message(FATAL_ERROR "WebApp library path not found")
    else(NOT MG_WEBAPP_LIBRARY)
        message(STATUS "Found WebApp library path: ${MG_WEBAPP_LIBRARY}")
    endif()
    find_library(MG_WEBSUPPORT_LIBRARY NAMES WebSupport
        PATHS "${CMAKE_CURRENT_SOURCE_DIR}/sdk/${MG_VERSION_MAJOR}.${MG_VERSION_MINOR}/${LIB_SUFFIX}"
        NO_DEFAULT_PATH
        NO_CMAKE_ENVIRONMENT_PATH
        NO_CMAKE_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_SYSTEM_PATH
        NO_CMAKE_FIND_ROOT_PATH)
    if(NOT MG_WEBSUPPORT_LIBRARY)
        message(FATAL_ERROR "WebSupport library path not found")
    else(NOT MG_WEBSUPPORT_LIBRARY)
        message(STATUS "Found WebSupport library path: ${MG_WEBSUPPORT_LIBRARY}")
    endif()
    find_library(MG_MDFMODEL_LIBRARY NAMES MgMdfModel
        PATHS "${CMAKE_CURRENT_SOURCE_DIR}/sdk/${MG_VERSION_MAJOR}.${MG_VERSION_MINOR}/${LIB_SUFFIX}"
        NO_DEFAULT_PATH
        NO_CMAKE_ENVIRONMENT_PATH
        NO_CMAKE_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_SYSTEM_PATH
        NO_CMAKE_FIND_ROOT_PATH)
    if(NOT MG_MDFMODEL_LIBRARY)
        message(FATAL_ERROR "MgMdfModel library path not found")
    else(NOT MG_MDFMODEL_LIBRARY)
        message(STATUS "Found MgMdfModel library path: ${MG_MDFMODEL_LIBRARY}")
    endif()
    find_library(MG_MDFPARSER_LIBRARY NAMES MgMdfParser
        PATHS "${CMAKE_CURRENT_SOURCE_DIR}/sdk/${MG_VERSION_MAJOR}.${MG_VERSION_MINOR}/${LIB_SUFFIX}"
        NO_DEFAULT_PATH
        NO_CMAKE_ENVIRONMENT_PATH
        NO_CMAKE_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_SYSTEM_PATH
        NO_CMAKE_FIND_ROOT_PATH)
    if(NOT MG_MDFPARSER_LIBRARY)
        message(FATAL_ERROR "MgMdfParser library path not found")
    else(NOT MG_MDFPARSER_LIBRARY)
        message(STATUS "Found MgMdfParser library path: ${MG_MDFPARSER_LIBRARY}")
    endif()
endif (MSVC)

# Java SDK
find_package(Java REQUIRED)
find_package(JNI REQUIRED)

# tclap
find_path(TCLAP_INCLUDE NAMES "tclap/CmdLine.h"
    HINTS "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/tclap-1.2.2/include"
    NO_DEFAULT_PATH
    NO_CMAKE_ENVIRONMENT_PATH
    NO_CMAKE_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_SYSTEM_PATH
    NO_CMAKE_FIND_ROOT_PATH
)
if(NOT TCLAP_INCLUDE)
    message(FATAL_ERROR "TCLAP include path not found")
else(NOT TCLAP_INCLUDE)
    message(STATUS "Found TCLAP include path: ${TCLAP_INCLUDE}")
endif()

# swig
find_path(SWIG_PATH NAMES "swig${EXE}"
    HINTS "D:/swigwin-3.0.12"
    NO_DEFAULT_PATH
    NO_CMAKE_ENVIRONMENT_PATH
    NO_CMAKE_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_SYSTEM_PATH
    NO_CMAKE_FIND_ROOT_PATH
)
if(NOT SWIG_PATH)
    message(FATAL_ERROR "SWIG path not found")
else(NOT SWIG_PATH)
    message(STATUS "Found SWIG path: ${SWIG_PATH}")
    set(SWIG_TOOL ${SWIG_PATH}/swig)
endif()

# IMake
set(IMAKE_TOOL ${CMAKE_CURRENT_BINARY_DIR}/src/IMake/IMake${EXE})
message(STATUS "Using IMake tool path: ${IMAKE_TOOL}")

add_subdirectory(src)