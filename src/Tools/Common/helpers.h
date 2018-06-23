#ifndef FS_HELPER_H
#define FS_HELPER_H

#include <iostream>
#include <fstream>
#include <string>
#include <sys/stat.h> // stat
#include <errno.h>    // errno, ENOENT, EEXIST
#if defined(_WIN32)
#include <direct.h>   // _mkdir
#endif

// Based on the following code samples:
// https://stackoverflow.com/questions/675039/how-can-i-create-directory-tree-in-c-linux
// https://stackoverflow.com/questions/1494399/how-do-i-search-find-and-replace-in-a-standard-string
// https://stackoverflow.com/questions/874134/find-if-string-ends-with-another-string-in-c
// http://www.cplusplus.com/doc/tutorial/files/

bool file_exists(const std::string &path)
{
#if defined(_WIN32)
    struct _stat info;
    if (_stat(path.c_str(), &info) != 0)
#else
    struct stat info;
    if (stat(path.c_str(), &info) != 0)
#endif
        return false;
    else
        return true;
}

bool directory_exists(const std::string& path)
{
#if defined(_WIN32)
    struct _stat info;
    if (_stat(path.c_str(), &info) != 0)
    {
        return false;
    }
    return (info.st_mode & _S_IFDIR) != 0;
#else 
    struct stat info;
    if (stat(path.c_str(), &info) != 0)
    {
        return false;
    }
    return (info.st_mode & S_IFDIR) != 0;
#endif
}

bool make_path(const std::string& path)
{
#if defined(_WIN32)
    int ret = _mkdir(path.c_str());
#else
    mode_t mode = 0755;
    int ret = mkdir(path.c_str(), mode);
#endif
    if (ret == 0)
        return true;

    switch (errno)
    {
    case ENOENT:
        // parent didn't exist, try to create it
        {
            int pos = path.find_last_of('/');
            if (pos == std::string::npos)
#if defined(_WIN32)
                pos = path.find_last_of('\\');
            if (pos == std::string::npos)
#endif
                return false;
            if (!make_path( path.substr(0, pos) ))
                return false;
        }
        // now, try to create again
#if defined(_WIN32)
        return 0 == _mkdir(path.c_str());
#else 
        return 0 == mkdir(path.c_str(), mode);
#endif

    case EEXIST:
        // done!
        return directory_exists(path);

    default:
        return false;
    }
}

bool str_ends_with(std::string const &fullString, std::string const &ending)
{
    if (fullString.length() >= ending.length()) {
        return (0 == fullString.compare (fullString.length() - ending.length(), ending.length(), ending));
    } else {
        return false;
    }
}

void str_replace(std::string& str,
                 const std::string& oldStr,
                 const std::string& newStr)
{
    std::string::size_type pos = 0u;
    while((pos = str.find(oldStr, pos)) != std::string::npos) {
        str.replace(pos, oldStr.length(), newStr);
        pos += newStr.length();
    }
}

bool replace_content_between(std::string& content,
                             const std::string& start,
                             const std::string& end,
                             const std::string& replace)
{
    bool didAtLeastOneReplacement = false;
    size_t pos_start = content.find(start);
    while (std::string::npos != pos_start)
    {
        size_t pos_end = content.find(end, pos_start);
        if (std::string::npos != pos_end)
        {
            size_t pos_repl = pos_start + replace.length() - 1;
            content.replace(pos_repl, pos_end - pos_repl, replace);
            didAtLeastOneReplacement = true;

            pos_start = content.find(start, pos_end);
        }
    }
    return didAtLeastOneReplacement;
}

bool write_all_text(const std::string& path, const std::string& content)
{
    std::ofstream myfile(path.c_str());
    if (myfile.is_open())
    {
        myfile << content;
        myfile.close();
        return true;
    }
    return false;
}

bool read_all_text(const std::string& path, std::string& content)
{
    std::string line;
    std::ifstream myfile(path.c_str());
    if (myfile.is_open())
    {
        while (std::getline(myfile,line))
        {
            content += line;
            content += "\n";
        }
        myfile.close();
        return true;
    }
    return false;
}

#endif