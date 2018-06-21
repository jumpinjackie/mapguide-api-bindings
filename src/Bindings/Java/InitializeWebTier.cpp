// What is this file?
//
// MapGuideApiGen.xml tries to include this file on Linux, presumably because its default include paths
// includes WebSupport that would have this file present. In our context, this file doesn't exist so
// this file just basically re-includes WebSupport.h, just like it would on Windows
#ifndef _WIN32
#include "WebSupport.h"
#endif