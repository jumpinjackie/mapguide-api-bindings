cmake_minimum_required(VERSION 2.8)

if(COMMAND cmake_policy)
    cmake_policy(SET CMP0003 NEW)
    #cmake_policy(SET CMP0054 OLD)
endif(COMMAND cmake_policy)

set(TOOL_INSTALL_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../tools")

add_subdirectory(PhpPostProcess)
add_subdirectory(StampVer)
add_subdirectory(SwigPrepare)