//
//  Copyright (C) 2004-2011 by Autodesk, Inc.
//
//  This library is free software; you can redistribute it and/or
//  modify it under the terms of version 2.1 of the GNU Lesser
//  General Public License as published by the Free Software Foundation.
//
//  This library is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
//  Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public
//  License along with this library; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
//

// These methods have to be invoked C-style
%ignore MgObject::GetClassId;
%ignore MgObject::GetClassName;

// SWIG is refcounting aware and since our C++ classes follow a refcounting scheme
// we can tap into this feature
//
// NOTE: We don't implement ref because anything from the native boundary is already AddRef'd
// All the managed layer should do when Disposed or GC'd is to make sure it is released
%feature("ref")   MgDisposable ""
%feature("unref") MgDisposable "SAFE_RELEASE($this);"

///////////////////////////////////////////////////////////
// STRINGPARAM "in" typemap
// Marshal a string from PHP to C++
//
%typemap(in) STRINGPARAM (char* str)
{
    convert_to_string_ex($input);
    str = (char*)Z_STRVAL_PP($input);
    try
    {
        MgUtil::MultiByteToWideChar(str, $1);
    }
    catch (int)
    {
        zend_error(E_ERROR, "Invalid string format");
    }
}

///////////////////////////////////////////////////////////
// STRING "out" typemap
// Marshal a string returned by C++ to PHP
//
%typemap(out) STRING
{
    string pBuf;
    try
    {
        MgUtil::WideCharToMultiByte(result, pBuf);
    }
    catch (int)
    {
        zend_error(E_ERROR, "Invalid string format");
    }
    char* zendBuf = (char*)emalloc(pBuf.length()+1);
    if (zendBuf == NULL)
        zend_error(E_ERROR, "Out of memory");
    strcpy(zendBuf, pBuf.c_str());
    ZVAL_STRINGL(return_value, zendBuf, pBuf.length(), false);
}

///////////////////////////////////////////////////////////
// BYTE_ARRAY_OUT "in" typemap
// Marshal a byte array supplied by PHP
// and filled in by C++
//
%typemap(in) BYTE_ARRAY_OUT buffer (INT32 length)
{
    if (! SWIG_ConvertPtr(*$input, (void**) &$1, $1_descriptor) < 0)
    {
        zend_error(E_ERROR, "Type error in argument %d of $symname. Expected %s or at least something looking vaguely like a string passed by reference", $argnum-argbase, $1_descriptor->name);
    }
    else if ((*$input)->type==IS_STRING ||(*$input)->type==IS_NULL)
    {
        /* use a stack allocated temp string */
        convert_to_long_ex(args[1-argbase + 1]);
        length = (INT32)Z_LVAL((**args[1-argbase + 1]));
        $1 = (BYTE_ARRAY_OUT)emalloc(length + 1);
        if ($1 == NULL)
            zend_error(E_ERROR, "Out of memory");
        Z_STRVAL((**$input)) = (char*)$1;
    }
    else
    {
        zend_error(E_ERROR, "Type error in argument %d of $symname. Expected %s or at least something looking vaguely like a string passed by reference", $argnum-argbase, $1_descriptor->name);
    }
}

///////////////////////////////////////////////////////////
// BYTE_ARRAY_OUT "argout" typemap
// Post call processing of a byte array supplied by PHP
// and filled in by C++
//
%typemap(argout) BYTE_ARRAY_OUT buffer
{
    Z_STRLEN((**args[1-argbase])) = result;
}

///////////////////////////////////////////////////////////
// BYTE_ARRAY_OUT "in" typemap
// Marshal a byte array supplied and filled in by PHP
//
%typemap(in) BYTE_ARRAY_IN
{
    if ((*$input)->type==IS_STRING ||(*$input)->type==IS_NULL)
    {
        /* use the buffer directly */
        $1= (unsigned char*)((*$input)->value.str.val);
    }
    else
    {
        zend_error(E_ERROR, "Type error in argument %d of $symname. Expected %s or at least something looking vaguely like a string passed by reference", $argnum-argbase, $1_descriptor->name);
    }
}

///////////////////////////////////////////////////////////
// INT64 "in" typemap
// Marshal an INT64 parameter from PHP to a C++ 64 bits integer
// The int64 parameter can be specified as an integer or as a string
//
%typemap(in) long long (const char* str, char* endptr, long long lvalue)
{
    if ((*$input)->type == IS_STRING)
    {
        str = (char*)Z_STRVAL_PP($input);
#ifdef WIN32
        lvalue = _strtoi64(str, &endptr, 10);
#else
        lvalue = strtoll(str, &endptr, 10);
#endif
        if (*endptr != '\0')
            zend_error(E_ERROR, "Invalid string encoded number in argument %d", $argnum-argbase);
    }
    else if ((*$input)->type == IS_LONG)
    {
        lvalue = Z_LVAL_PP($input);
    }
    else
    {
        zend_error(E_ERROR, "Type error in argument %d of $symname. Expected a string or an integer", $argnum-argbase);
    }

    $1 = lvalue;
}

///////////////////////////////////////////////////////////
// INT64 "out" typemap
// Marshal a long long returned by C++ to PHP string
//
%typemap(out) long long
{
    char buf[25];       //can't actually be longer than 21 + 1 for the sign
#ifdef WIN32
    sprintf(buf, "%I64d", result);
#else
    sprintf(buf, "%lld", result);
#endif

    ZVAL_STRINGL(return_value, buf, strlen(buf), true);
}

///////////////////////////////////////////////////////////
// CHAR_PTR_NOCOPY "out" typemap
// returns a string from C++ without duplicating it
//
%typemap(out) CHAR_PTR_NOCOPY
{
    ZVAL_STRING(return_value, result, 0);
}
typedef char* CHAR_PTR_NOCOPY;

%pragma(php) phpinfo=
"    php_info_print_table_start();\n"\
"    php_info_print_table_row(2, \"MapGuideApi\", \"enabled\");\n"\
"    php_info_print_table_end();"

///////////////////////////////////////////////////////////
// Global functions
//
void MgInitializeWebTier(STRINGPARAM configFile);
void SetLocalizedFilesPath(const char* path);
CHAR_PTR_NOCOPY Localize(const char* text, const char* locale, int os);
CHAR_PTR_NOCOPY GetLocalizedString(char* id, char* locale);