project(StampVer)

include_directories(
    "${CMAKE_CURRENT_SOURCE_DIR}"
    "${CMAKE_CURRENT_SOURCE_DIR}/../Common"
)

set(StampVer_SRCS
    main.cpp
)

add_executable(StampVer ${StampVer_SRCS})

if (MSVC)
    set_target_properties(StampVer PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${TOOL_INSTALL_PATH} )
    set_target_properties(StampVer PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG ${TOOL_INSTALL_PATH} )
    set_target_properties(StampVer PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE ${TOOL_INSTALL_PATH} )
endif (MSVC)

if (UNIX)
    install(TARGETS StampVer DESTINATION ${TOOL_INSTALL_PATH})
endif (UNIX)