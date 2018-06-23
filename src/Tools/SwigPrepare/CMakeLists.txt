project(SwigPrepare)

include_directories(
    "${CMAKE_CURRENT_SOURCE_DIR}"
    "${CMAKE_CURRENT_SOURCE_DIR}/../Common"
)

set(SwigPrepare_SRCS
    main.cpp
)

add_executable(SwigPrepare ${SwigPrepare_SRCS})

if (MSVC)
    set_target_properties(SwigPrepare PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${TOOL_INSTALL_PATH} )
    set_target_properties(SwigPrepare PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG ${TOOL_INSTALL_PATH} )
    set_target_properties(SwigPrepare PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE ${TOOL_INSTALL_PATH} )
endif (MSVC)

if (UNIX)
    install(TARGETS SwigPrepare DESTINATION ${TOOL_INSTALL_PATH})
endif (UNIX)