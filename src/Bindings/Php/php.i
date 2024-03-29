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

%begin %{
//HACK: ACE and PHP conflict on some typedefs. In this battle, PHP must give way through
//select patched headers on the PHP end.
//
//Therefore, we need to make sure that ACE headers are pulled in before PHP
//
//So in order to beat it to the punch, this #include is from the SWIG %begin section, 
//ensuring it will be rendered before the #include of php.h
#include "MapGuideCommon.h"
%}

%include "../Common/Php/pointer.i"
%include "../Common/Php/exception.i"
%include "../Common/Php/monkey_patch.i"

%runtime %{
#if defined(_MSC_VER)
#   pragma warning(disable : 4102) /* unreferenced label. SWIG is inserting these, not me */
#endif
#include "PhpLocalizer.cpp"
#include "PhpClassMap.cpp"
%}

%include "../Common/refcount.i"

// These methods have to be invoked C-style
%ignore MgObject::GetClassId;
%ignore MgObject::GetClassName;

///////////////////////////////////////////////////////////
// STRINGPARAM "typecheck" typemap
//
%typemap(typecheck, precedence=SWIG_TYPECHECK_UNISTRING) STRINGPARAM 
{
    $1 = Z_TYPE($input) == IS_STRING;
}

///////////////////////////////////////////////////////////
// STRINGPARAM "in" typemap
// Marshal a string from PHP to C++
//
%typemap(in) STRINGPARAM (char* str)
{
    convert_to_string(&$input);
    str = (char*)Z_STRVAL($input);
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
    ZVAL_STRINGL(return_value, zendBuf, pBuf.length());
}

///////////////////////////////////////////////////////////
// BYTE_ARRAY_OUT "in" typemap
// Marshal a byte array supplied by PHP
// and filled in by C++
//
%typemap(in, byref=1) BYTE_ARRAY_OUT buffer (INT32 length)
{
    bool isNull = (Z_TYPE($input) == IS_NULL);
    bool isRef = Z_ISREF($input);
    if (isNull)
    {
        $1 = (BYTE_ARRAY_OUT)0;
    }
    else if (isRef)
    {
        /* use a stack allocated temp string */
        convert_to_long(&args[1 + 1]);
        length = (INT32)Z_LVAL((args[1 + 1]));
        $1 = (BYTE_ARRAY_OUT)emalloc(length + 1);
        if ($1 == NULL)
            zend_error(E_ERROR, "Out of memory");
    }
    else
    {
        zend_error(E_ERROR, "Type error in argument %d of $symname. Expected %s or at least something looking vaguely like a string passed by reference", $argnum, $1_descriptor->name);
    }
}

///////////////////////////////////////////////////////////
// BYTE_ARRAY_OUT "argout" typemap
// Post call processing of a byte array supplied by PHP
// and filled in by C++
//
%typemap(argout) BYTE_ARRAY_OUT buffer
{
    if (Z_ISREF($input)) 
    {
        ZVAL_STRINGL(Z_REFVAL($input), (char*)$1, result);
        efree($1);
    }
}

///////////////////////////////////////////////////////////
// BYTE_ARRAY_IN "in" typemap
// Marshal a byte array supplied and filled in by PHP
//
%typemap(in) BYTE_ARRAY_IN
{
    if (Z_TYPE($input) == IS_STRING || Z_TYPE($input) == IS_NULL)
    {
        /* use the buffer directly */
        $1= (unsigned char*)(Z_STRVAL($input));
    }
    else
    {
        zend_error(E_ERROR, "Type error in argument %d of $symname. Expected %s or at least something looking vaguely like a string passed by reference", $argnum, $1_descriptor->name);
    }
}

///////////////////////////////////////////////////////////
// INT64 "in" typemap
// Marshal an INT64 parameter from PHP to a C++ 64 bits integer
// The int64 parameter can be specified as an integer or as a string
//
%typemap(in) long long (const char* str, char* endptr, long long lvalue)
{
    if (Z_TYPE($input) == IS_STRING)
    {
        str = (char*)Z_STRVAL($input);
#ifdef WIN32
        lvalue = _strtoi64(str, &endptr, 10);
#else
        lvalue = strtoll(str, &endptr, 10);
#endif
        if (*endptr != '\0')
            zend_error(E_ERROR, "Invalid string encoded number in argument %d", $argnum);
    }
    else if (Z_TYPE($input) == IS_LONG)
    {
        lvalue = Z_LVAL($input);
    }
    else
    {
        zend_error(E_ERROR, "Type error in argument %d of $symname. Expected a string or an integer", $argnum);
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

    ZVAL_STRINGL(return_value, buf, strlen(buf));
}

///////////////////////////////////////////////////////////
// CHAR_PTR_NOCOPY "out" typemap
// returns a string from C++ without duplicating it
//
%typemap(out) CHAR_PTR_NOCOPY
{
    ZVAL_STRING(return_value, result);
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
