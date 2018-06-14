project(IMake)
include_directories(
    ${TCLAP_INCLUDE}
)

set(IMake_SRCS
    IMake.cpp
    SimpleXmlParser.cpp
    stdafx.cpp
)

add_executable(IMake ${IMake_SRCS})

if(MSVC)
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)
    set_target_properties(IMake PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} )
    set_target_properties(IMake PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_CURRENT_BINARY_DIR} )
    set_target_properties(IMake PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_CURRENT_BINARY_DIR} )
endif(MSVC)