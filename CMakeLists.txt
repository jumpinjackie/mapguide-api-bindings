cmake_minimum_required(VERSION 2.6)
project(mapguide-api-bindings)

find_package(SWIG REQUIRED)

# These dirs will be common for all bindings we build
include_directories("src/MapGuide/$ENV{MG_VERSION}/Oem/ACE/ACE_wrappers")
include_directories("src/MapGuide/$ENV{MG_VERSION}/Oem/dbxml/xerces-c-src/src")
include_directories("src/MapGuide/$ENV{MG_VERSION}/Common/MdfModel")
include_directories("src/MapGuide/$ENV{MG_VERSION}/Common/Foundation")
include_directories("src/MapGuide/$ENV{MG_VERSION}/Common/Geometry")
include_directories("src/MapGuide/$ENV{MG_VERSION}/Common/PlatformBase")
include_directories("src/MapGuide/$ENV{MG_VERSION}/Common/MapGuideCommon")
add_subdirectory("src/Bindings")