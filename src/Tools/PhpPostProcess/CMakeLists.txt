project(PhpPostProcess)

include_directories(
    "${CMAKE_CURRENT_SOURCE_DIR}"
    "${CMAKE_CURRENT_SOURCE_DIR}/../Common"
)

set(PhpPostProcess_SRCS
    main.cpp
)

add_executable(PhpPostProcess ${PhpPostProcess_SRCS})

if (MSVC)
    set_target_properties(PhpPostProcess PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${TOOL_INSTALL_PATH} )
    set_target_properties(PhpPostProcess PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG ${TOOL_INSTALL_PATH} )
    set_target_properties(PhpPostProcess PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE ${TOOL_INSTALL_PATH} )
endif (MSVC)

if (UNIX)
    install(TARGETS PhpPostProcess DESTINATION ${TOOL_INSTALL_PATH})
endif (UNIX)