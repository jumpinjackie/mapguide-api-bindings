add_subdirectory(DotNet)

# Needed for api binding generation
file(COPY "Common" DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
file(COPY "MapGuideApi" DESTINATION ${CMAKE_CURRENT_BINARY_DIR})