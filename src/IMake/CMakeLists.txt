project(imake)
include_directories(
    ${TCLAP_INCLUDE}
)

if(MSVC)
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)
endif(MSVC)

set(IMake_SRCS
    IMake.cpp
    SimpleXmlParser.cpp
    stdafx.cpp
)

add_executable(IMake ${IMake_SRCS})
target_link_libraries(IMake)