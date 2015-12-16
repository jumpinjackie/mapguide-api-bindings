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
%include <wchar.i>
%include <exception.i>
%include "../Common/DotNet/coreclr_compat.i"

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

// Exception support
%exception {
  try 
  {
    $action
  } 
  catch (MgException* ex) 
  {
    //TODO: Custom SWIG MgException helper that uses the same pending exception mechanism
    SAFE_RELEASE(ex);
  }
}

///////////////////////////////////////////////////////////
// STRINGPARAM "in" typemap
// Marshal a C++ style string to a wstring
// Allocate temporary memory only when required, otherwise
// use a buffer on the stack
//
#if defined(DOTNETCORE)
#if defined(WIN32)
%typemap(in) STRINGPARAM
{
    //out typemap - WIN32 (DOTNETCORE)
    $1 = (STRINGPARAM) $input;
}
#else
%typemap(in) STRINGPARAM
{
    //out typemap - LINUX (DOTNETCORE)
    $1 = (STRINGPARAM) X2W((XMLCh*)$input);
}
#endif
#else
%typemap(in) STRINGPARAM
{
    $1 = (STRINGPARAM) $input;
}
#endif

///////////////////////////////////////////////////////////
// STRING "out" typemap
// Marshal a string returned by C++ to CSharp
//
#if defined(DOTNETCORE)
#if defined(WIN32)
%typemap(out) STRING
{
    //out typemap - WIN32 (DOTNETCORE)
    $result = SWIG_csharp_wstring_callback(result.c_str());
}
#else
%typemap(out) STRING
{
    //out typemap - LINUX (DOTNETCORE)
    xstring u16String;
    UnicodeString::UTF32toUTF16((const LCh*) result.c_str(), u16String);
    $result = SWIG_csharp_wstring_callback(u16String.c_str());
}
#endif
#else
%typemap(out) STRING
{
    $result = SWIG_csharp_wstring_callback(result.c_str());
}
#endif

///////////////////////////////////////////////////////////
// BYTE_ARRAY_OUT "cstype" typemap
// Type substitution in .NET and proxy code
//
%typemap(cstype) BYTE_ARRAY_OUT "Byte[]"
%typemap(imtype) BYTE_ARRAY_OUT "Byte[]"
%typemap(ctype)  BYTE_ARRAY_OUT "unsigned char*"

///////////////////////////////////////////////////////////
// BYTE_ARRAY_IN "cstype" typemap
// Type substitution in .NET and proxy code
//
%typemap(cstype) BYTE_ARRAY_IN "Byte[]"
%typemap(imtype) BYTE_ARRAY_IN "Byte[]"
%typemap(ctype)  BYTE_ARRAY_IN "unsigned char*"

///////////////////////////////////////////////////////////
// Global functions
//
void MgInitializeWebTier(STRINGPARAM configFile);
