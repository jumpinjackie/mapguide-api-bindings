cmake_minimum_required(VERSION 3.0)

if(COMMAND cmake_policy)
    cmake_policy(SET CMP0003 NEW)
    cmake_policy(SET CMP0054 OLD)
endif(COMMAND cmake_policy)

set(MG_VERSION_MAJOR 1)
set(MG_VERSION_MINOR 0)
set(MG_VERSION_PATCH 0)
set(MG_VERSION "${MG_VERSION_MAJOR}.${MG_VERSION_MINOR}.${MG_VERSION_PATCH}")
set(CMAKE_DEBUG_POSTFIX "d")

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

add_subdirectory(src)