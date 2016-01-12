#include <fstream>
#include <iostream>
#include <map>
#include <string>
#include <vector>

typedef std::map<std::string, std::string> StringMap;

void ReplaceStringInPlace(std::string& subject, const std::string& search, const std::string& replace)
{
    size_t pos = 0;
    while ((pos = subject.find(search, pos)) != std::string::npos)
    {
        subject.replace(pos, search.length(), replace);
        pos += replace.length();
    }
}

void DumpArgs(int argc, char** argv)
{
    for (int i = 0; i < argc; i++)
    {
        std::cout << "  [" << (i + 1) << "]: " << argv[i] << std::endl;
    }
}

void Usage(int argc, char** argv)
{
    std::cout
        << "Usage: "
        << ((argc == 1) ? argv[0] : "FileReplace") //argv[0] should be the program name, but just in case ...
        << " [input_file] [output_file] [replacements_file] [sdk_root_dir]"
        << std::endl;
}

int main(int argc, char** argv)
{   
    if (argc == 5)
    {
        std::ifstream replFile(argv[3]);
        std::string sdkDir = argv[4];

        StringMap findAndReplace;

        //Load replacements
        std::string replLine;
        std::vector<std::string> tokens;
        while (std::getline(replFile, replLine))
        {
            tokens.push_back(replLine);
        }

        if (tokens.size() % 2 != 0)
        {
            std::cout << "Error: Odd number of find/replace tokens in file." << std::endl;
            Usage(argc, argv);
            return 1;
        }
        else
        {
            for (size_t i = 0; i < tokens.size(); i += 2)
            {
                std::string find;
                std::string replace;

                find += tokens[i];
                replace += tokens[i + 1];

                ReplaceStringInPlace(find, "$SDK", sdkDir);
                ReplaceStringInPlace(replace, "$SDK", sdkDir);

                findAndReplace[find] = replace;
            }
            std::cout
                << "=== Summary ===" << std::endl
                << "Input: "
                << argv[1] << std::endl
                << "Output: "
                << argv[2] << std::endl
                << "Replacements: " << std::endl;

            for (StringMap::const_iterator it = findAndReplace.begin(); it != findAndReplace.end(); it++)
            {
                std::cout << "    " << it->first << " -> " << it->second << std::endl;
            }

            std::ifstream readFile(argv[1]);
            std::ofstream outFile(argv[2]);

            std::string buffer((std::istreambuf_iterator<char>(readFile)),
                (std::istreambuf_iterator<char>()));


            //Perform replacements
            for (StringMap::const_iterator it = findAndReplace.begin(); it != findAndReplace.end(); it++)
            {
                ReplaceStringInPlace(buffer, it->first, it->second);
            }

            //Write result
            outFile << buffer;
            outFile.close();

            std::cout << std::endl << "Modified file saved to: " << argv[2] << std::endl;

            return 0;
        }
    }
    else
    {
        std::cout << "Error: Unexpected number of arguments." << std::endl;
        if (argc > 0)
        {
            std::cout << "Found the following:" << std::endl;
            DumpArgs(argc, argv);
        }
        Usage(argc, argv);
        
        return 1;
    }
}