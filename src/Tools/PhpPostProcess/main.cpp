#include <iostream>
#include <set>
//#include <vector>
#include "helpers.h"

void check_traits(const std::string& line, std::set<std::string>& traits)
{
    size_t pos = line.find("trait ");
    if (pos != std::string::npos)
    {
        size_t pos_end = line.find("Patched ", pos + 6 /* "trait " */);
        if (pos_end != std::string::npos)
        {
            std::string className = line.substr(pos + 6, pos_end - 6);
            std::cout << "Found trait for class: " << className << std::endl;

            traits.insert(className);
        }
    }
}

void apply_traits(const std::string& line, std::string& content, std::set<std::string>& traits)
{
    size_t pos = line.find("class ");
    if (pos != std::string::npos)
    {
        size_t pos_class_start = pos + 6;
        size_t pos_end = line.find(" ", pos_class_start /* "class " */);
        if (pos_end != std::string::npos)
        {
            std::string className = line.substr(pos_class_start, pos_end - pos_class_start);
            std::cout << pos_class_start << ":" << pos_end << " Checking if trait exists for class: `" << className << "`" << std::endl;
            if (traits.find(className) != traits.end())
            {
                content += "    use ";
                content += className;
                content += "Patched;  /* Inserted by PhpPostProcess tool */";
                content += "\n";
                std::cout << "Applied trait for class: " << className << std::endl;
            }
        }
    }
}

int main(int argc, char **argv)
{
    /*
    std::vector<std::string> lines;
    lines.push_back("<?php");
    lines.push_back("trait MgExceptionPatched {");
    lines.push_back("}");
    lines.push_back("class MgException {");
    lines.push_back("    function getMessage() { }");
    lines.push_back("}");
    lines.push_back("class MgSiteConnection {");
    lines.push_back("    function CreateService($serviceType) { }");
    lines.push_back("}");
    lines.push_back("?>");

    std::set<std::string> traits;
    std::string content;
    for (std::vector<std::string>::iterator it = lines.begin(); it != lines.end(); it++)
    {
        std::string line = *it;
        check_traits(line, traits);
        content += line;
        content += "\n";
        apply_traits(line, content, traits);
    }

    std::cout << content << std::endl;
    return 0;
    */
    if (argc != 2)
    {
        std::cout << "Usage: PhpPostProcess [path to MapGuideApi.php]" << std::endl;
        return 1;
    }

    std::set<std::string> traits;
    std::string content;

    std::string line;
    std::ifstream myfile(argv[1]);
    if (myfile.is_open())
    {
        while (std::getline(myfile,line))
        {
            check_traits(line, traits);
            content += line;
            content += "\n";
            apply_traits(line, content, traits);
        }
        myfile.close();
        return 0;
    }
    return 1;
}