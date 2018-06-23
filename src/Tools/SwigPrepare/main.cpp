#include <iostream>
#include "helpers.h"

int main(int argc, char **argv)
{
    if (argc != 4)
    {
        std::cout << "Usage: SwigPrepare [sdk path] [sdk rel path] [target dir]" << std::endl;
        return 1;
    }

    std::string sdkRoot = argv[1];
    std::string sdkRelPath = argv[2];
    std::string targetDir = argv[3];

    if (!directory_exists(sdkRoot))
    {
        std::cout << "Directory not found: " << sdkRoot << std::endl;
        return 1;
    }
    if (!directory_exists(targetDir))
    {
        make_path(targetDir);
        std::cout << "Created directory: " << targetDir << std::endl;
    }

    //Normalize on / as separator
    str_replace(sdkRoot, "\\", "/");

    std::string fConstants = combine_paths(sdkRoot, "SWIG/Constants.xml");
    std::string fMapGuideApiGen = combine_paths(sdkRoot, "SWIG/MapGuideApiGen.xml");

    std::string sbConstants;
    if (!read_all_text(fConstants, sbConstants))
    {
        std::cout << "File not found: " << fConstants << std::endl;
        return 1;
    }
    std::string sbMapGuideApiGen;
    if (!read_all_text(fMapGuideApiGen, sbMapGuideApiGen))
    {
        std::cout << "File not found: " << fMapGuideApiGen << std::endl;
        return 1;
    }

    //Add extra STRINGPARAM typedef for .net Core
    str_replace(sbMapGuideApiGen, "#if defined(PHP) || defined(JAVA)", "#if defined(PHP) || defined(JAVA) || defined(DOTNETCORE)");
    //Patch STRINGPARAM typedef for PHP
    str_replace(sbMapGuideApiGen, "typedef char*         STRINGPARAM;", "typedef std::wstring STRINGPARAM;");
    //Comment out class id includes
    str_replace(sbMapGuideApiGen, "%include \"../../../Common", "//%include \"../../../Common");
    str_replace(sbMapGuideApiGen, "%include \"../WebApp", "//%include \"../WebApp");
    str_replace(sbMapGuideApiGen, "%include \"../HttpHandler", "//%include \"../HttpHandler");
    //Fix header relative paths
    str_replace(sbMapGuideApiGen, "<Header path=\"../../../Common", "<Header path=\"" + sdkRelPath + "/Inc/Common");
    str_replace(sbMapGuideApiGen, "<Header path=\"../WebApp", "<Header path=\"" + sdkRelPath + "/Inc/Web/WebApp");
    str_replace(sbMapGuideApiGen, "<Header path=\"../HttpHandler", "<Header path=\"" + sdkRelPath + "/Inc/Web/HttpHandler");
    //#elseif must've been valid in our custom version of SWIG we're using. Not here
    str_replace(sbMapGuideApiGen, "#elseif", "#elif");

    //Fix header relative paths
    str_replace(sbConstants, "<Header path=\"../../../Common", "<Header path=\"" + sdkRelPath + "/Inc/Common");
    str_replace(sbConstants, "<Header path=\"../WebApp", "<Header path=\"" + sdkRelPath + "/Inc/Web/WebApp");
    str_replace(sbConstants, "<Header path=\"../HttpHandler", "<Header path=\"" + sdkRelPath + "/Inc/Web/HttpHandler");

    std::string outConstants = combine_paths(targetDir, "Constants.xml");
    std::string outMapGuideApiGen = combine_paths(targetDir, "MapGuideApiGen.xml");

    if (!write_all_text(outConstants, sbConstants))
    {
        std::cout << "Failed to write Constants.xml" << std::endl;
        return 1;
    }
    std::cout << "Wrote: " << outConstants << std::endl;
    if (!write_all_text(outMapGuideApiGen, sbMapGuideApiGen))
    {
        std::cout << "Failed to write MapGuideApiGen.xml" << std::endl;
        return 1;
    }
    std::cout << "Wrote: " << outMapGuideApiGen << std::endl;
    return 0;
}