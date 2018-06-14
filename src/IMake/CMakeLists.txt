project(IMake)
include_directories(
    ${TCLAP_INCLUDE}
)

if(MSVC)
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)
    set_target_properties( ${targetname} PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} )
    set_target_properties( ${targetname} PROPERTIES LIBRARY_OUTPUT_DIRECTORY_DEBUG ${CMAKE_CURRENT_BINARY_DIR} )
    set_target_properties( ${targetname} PROPERTIES LIBRARY_OUTPUT_DIRECTORY_RELEASE ${CMAKE_CURRENT_BINARY_DIR} )
endif(MSVC)

set(IMake_SRCS
    IMake.cpp
    SimpleXmlParser.cpp
    stdafx.cpp
)

add_executable(IMake ${IMake_SRCS})
target_link_libraries(IMake)