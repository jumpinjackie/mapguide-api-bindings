#include <string>
#include <map>

static std::string localizationPath;
static std::string english = "en";
typedef std::map<std::string, std::string> STRBUNDLE;
typedef STRBUNDLE* PSTRBUNDLE;
static std::map<std::string, PSTRBUNDLE> languages;
typedef char* CHAR_PTR_NOCOPY;

extern "C" {
#include "zend_API.h"
}

#include <algorithm>
#define MAX_LOC_LEN     4096

static std::string trim(std::string source)
{
    std::string cs = "\t \r\n";
    std::string s = source.erase(0, source.find_first_not_of(cs));
    return s.erase(s.find_last_not_of(cs) + 1) ;
}

static void strlower(std::string& str)
{
    std::transform(str.begin(), str.end(), str.begin(), ::tolower);
}

static void SetLocalizedFilesPath(const char*path)
{
    localizationPath = path;
}

PSTRBUNDLE GetStringBundle(std::string& locale_)
{
    std::string locale = locale_;
    if (locale == "")
        locale = english;
    else
        strlower(locale);
    
    std::string localKey = localizationPath + locale;

    std::map<std::string, PSTRBUNDLE>::const_iterator it = languages.find(localKey);
    
    if (it == languages.end()) {
        FILE* f = NULL;
        std::string fname = localKey;
        f = fopen(fname.c_str(), "r");
        if(f == NULL) {  // assume file doesn't exists
            // requested locale is not supported, default to English
            it = languages.find(localizationPath + english);
            if(it != languages.end())
                return it->second;
            fname = localizationPath + english;
            f = fopen(fname.c_str(), "r");
        }
        PSTRBUNDLE sb = new STRBUNDLE;
        languages[localKey] = sb;
        if(f != NULL) {
            char l[MAX_LOC_LEN + 1];
            for(int lc = 0; fgets(l, MAX_LOC_LEN, f) != NULL; lc++) {
                std::string line;
                if(lc == 0 && (unsigned char)l[0] == 0xEF)
                    line = trim(std::string(l + 3)); //Skip UTF8 BOF marker
                else
                    line = trim(std::string(l));
                if(line.empty() || line.at(0) == '#')
                    continue;
                size_t sep = line.find('=');
                if (sep == std::string::npos)
                    continue;
                std::string key = trim(line.substr(0, sep));
                if (key.empty())
                    continue;
                std::string value = trim(line.substr(sep + 1));
                (*sb)[key] = value;
            }
            fclose(f);
        }
    }
    return languages[localKey];
}

static char* Localize(const char* text_, const char* locale_, int os)
{
    std::string locale = locale_;
    strlower(locale);
    std::string text = text_;
    std::string fontSuffix = (os == 0 ? "Windows" : (os == 1 ? "Macintosh" : "Linux"));


    PSTRBUNDLE sb = GetStringBundle(locale);
    if(sb == NULL)
        return estrdup("");
    size_t len = text.length();
    for(size_t i = 0; i < len; )
    {
        bool fontTag = false;
        size_t pos1 = text.find("__#", i);
        if (pos1 != std::string::npos)
        {
            size_t pos2 = text.find("#__", pos1 + 3);
            if (pos2 != std::string::npos)
            {
                std::string id = text.substr(pos1 + 3, pos2 - pos1 - 3);
                std::string locStr;
                std::map<std::string, std::string>::const_iterator it = sb->find(id == "@font" || id == "@fontsize" ? id + fontSuffix : id);
                if (it == sb->end())
                    locStr = "";
                else
                    locStr = it->second;
                size_t locLen = locStr.length();

                std::string begin, end;
                if (pos1 > 0)
                    begin = text.substr(0, pos1);
                else
                    begin = "";
                end = text.substr(pos2 + 3);
                text = begin + locStr + end;

                len = len - 6 - id.length() + locLen;
                i = pos1 + locLen;
            }
            else
                i = len;
        }
        else
            i = len;
    }
    return estrdup(text.c_str());
}

static char* GetLocalizedString(const char* id_, const char* locale_)
{
    PSTRBUNDLE sb = NULL;
    std::string locale = locale_;
    sb = GetStringBundle(locale);
    if(sb == NULL)
        return estrdup("");
    std::string id = id_;
    std::map<std::string, std::string>::const_iterator it = sb->find(id);
    if (it == sb->end())
        return estrdup("");
    return estrdup(it->second.c_str());
}
