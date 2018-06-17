cmake_minimum_required(VERSION 2.8)

if(COMMAND cmake_policy)
    cmake_policy(SET CMP0003 NEW)
    cmake_policy(SET CMP0054 OLD)
endif(COMMAND cmake_policy)

set(EXE ".exe")
set(SED_COMMAND "sed")
set(SED_ARGS "-i")

# Set common commands.
if (UNIX)
    set(EXE "")
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

set(MG_PACKAGE_OUTPUT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/packages")

# Determine bitness
if ((NOT MG_CPU EQUAL 32) AND (NOT MG_CPU EQUAL 64))
    message(STATUS "MG_CPU not defined, determining what we're building for based on system bitness")
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(MG_CPU 64)
    else(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(MG_CPU 32)
    endif(CMAKE_SIZEOF_VOID_P EQUAL 8)
    message (STATUS "MG_CPU is ${MG_CPU}")
endif ((NOT MG_CPU EQUAL 32) AND (NOT MG_CPU EQUAL 64))

# Check VS toolset
if (MSVC)
    message(STATUS "Using VS toolset: ${CMAKE_VS_PLATFORM_TOOLSET}")
endif (MSVC)

set(LIB_SUFFIX "lib")
set(BIN_SUFFIX "bin")
set(MG_ARCH "x86")
if (MG_CPU EQUAL 64)
    set(LIB_SUFFIX "lib64")
    set(BIN_SUFFIX "bin64")
    set(MG_ARCH "x64")
endif (MG_CPU EQUAL 64)

if(WIN32)
    add_definitions(-D_WIN32_WINNT=0x600)
    add_definitions(-DUNICODE -D_UNICODE)
    #add_definitions(/MP)
    if(MSVC)
        if(NOT (MSVC14))
            message(FATAL_ERROR, "Only MSVC14 (Visual Studio 2015) is supported compiler on Windows")
        endif(NOT (MSVC14))
    else(MSVC)
        message(FATAL_ERROR, "Only MSVC is the supported compiler on Windows")
    endif(MSVC)
endif(WIN32)

set(MG_SDK_DIR "${CMAKE_CURRENT_SOURCE_DIR}/sdk/${MG_VERSION_MAJOR}.${MG_VERSION_MINOR}")

if (MSVC)
    # Prepared MapGuide buildpack headers
    find_path(MG_COMMON_DIR NAMES "Foundation/Foundation.h"
        HINTS "${MG_SDK_DIR}/Inc/Common"
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
        HINTS "${MG_SDK_DIR}/Inc/ACE_Wrappers"
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
        HINTS "${MG_SDK_DIR}/Inc/Web"
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
        PATHS "${MG_SDK_DIR}/${LIB_SUFFIX}"
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
        PATHS "${MG_SDK_DIR}/${LIB_SUFFIX}"
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
        PATHS "${MG_SDK_DIR}/${LIB_SUFFIX}"
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
        PATHS "${MG_SDK_DIR}/${LIB_SUFFIX}"
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
        PATHS "${MG_SDK_DIR}/${LIB_SUFFIX}"
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
        PATHS "${MG_SDK_DIR}/${LIB_SUFFIX}"
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
        PATHS "${MG_SDK_DIR}/${LIB_SUFFIX}"
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
        PATHS "${MG_SDK_DIR}/${LIB_SUFFIX}"
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
        PATHS "${MG_SDK_DIR}/${LIB_SUFFIX}"
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
        PATHS "${MG_SDK_DIR}/${LIB_SUFFIX}"
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
if (WITH_JAVA)
    find_package(Java REQUIRED)
    find_package(JNI REQUIRED)
endif (WITH_JAVA)

# PHP
if (WITH_PHP)
    if (MSVC)
        set(EXPECTED_PHP_PATH "${CMAKE_CURRENT_SOURCE_DIR}/runtimes/php/Release")
        if (MG_CPU EQUAL 64)
            set(EXPECTED_PHP_PATH "${CMAKE_CURRENT_SOURCE_DIR}/runtimes/php/Release64")
        endif (MG_CPU EQUAL 64)

        find_path(PHP_INCLUDE_DIR NAMES "Zend/Zend_API.h"
            HINTS "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/php7/src/php-7.1.18"
            NO_DEFAULT_PATH
            NO_CMAKE_ENVIRONMENT_PATH
            NO_CMAKE_PATH
            NO_SYSTEM_ENVIRONMENT_PATH
            NO_CMAKE_SYSTEM_PATH
            NO_CMAKE_FIND_ROOT_PATH
        )
        find_library(PHP_LIBRARY NAMES php7ts
            PATHS "${EXPECTED_PHP_PATH}/dev"
            NO_DEFAULT_PATH
            NO_CMAKE_ENVIRONMENT_PATH
            NO_CMAKE_PATH
            NO_SYSTEM_ENVIRONMENT_PATH
            NO_CMAKE_SYSTEM_PATH
            NO_CMAKE_FIND_ROOT_PATH
        )
    endif (MSVC)
endif (WITH_PHP)

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
if (WIN32)
    set(SWIG_HINT_PATH "${SWIG_WIN_PATH}")
else (WIN32)
    # Assuming swig was installed via swigsetup.sh
    set(SWIG_HINT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/swig/bin")
endif (WIN32)

find_path(SWIG_PATH NAMES "swig${EXE}"
    HINTS "${SWIG_HINT_PATH}"
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
message(STATUS "Using IMake tool path (we expect IMake to be built here): ${IMAKE_TOOL}")

add_subdirectory(src)