#include <iostream>
#include "helpers.h"

int stamp_project_file(const std::string& path, const std::string& version)
{
    if (!file_exists(path))
    {
        std::cout << "Project file not found: " << path << std::endl;
        return 1;
    }

    std::string content;
    if (!read_all_text(path, content))
    {
        std::cout << "Failed to read project file content" << std::endl;
        return 1;
    }

    if (!replace_content_between(content, "<Version>", "</Version>", version))
    {
        std::cout << "No replacements made in project file" << std::endl;
        return 1;
    }

    return 0;
}

int stamp_assembly_info(const std::string& path, const std::string& version)
{
    if (!file_exists(path))
    {
        std::cout << "AssemblyInfo file not found: " << path << std::endl;
        return 1;
    }

    std::string content;
    if (!read_all_text(path, content))
    {
        std::cout << "Failed to read AssemblyInfo file content" << std::endl;
        return 1;
    }

    if (!replace_content_between(content, "Version(\"", "\")]", version))
    {
        std::cout << "No replacements made in AssemblyInfo file" << std::endl;
        return 1;
    }

    return 0;
}

int main(int argc, char **argv)
{
    /*
    std::string content = "<Project>\n\t<Version>1.0.0.0</Version>\n</Project>";
    std::string content2 = "using System.Runtime.CompilerServices;\n\n[assembly: Version(\"1.0.0.0\")]\n[assembly: AssemblyVersion(\"1.0.0.1\")]";

    replace_content_between(content, "<Version>", "</Version>", "3.1.1.9389");
    replace_content_between(content2, "Version(\"", "\")]", "3.1.1.9389");

    std::cout << "Content:" << std::endl << content << std::endl;
    std::cout << "Content2:" << std::endl << content2 << std::endl;
    */
    if (argc != 7)
    {
        std::cout << "Usage: StampVer [ver:major] [ver:minor] [ver:build] [ver:rev] [assembly_info_file] [.net project]" << std::endl;
        return 1;
    }

    std::string version = argv[1];
    version += ".";
    version += argv[2];
    version += ".";
    version += argv[3];
    version += ".";
    version += argv[4];

    std::string asmInfoPath = argv[5];
    std::string projectFile = argv[6];

    int ret = 0;
    ret += stamp_assembly_info(asmInfoPath, version);
    ret += stamp_project_file(projectFile, version);

    return ret;
}