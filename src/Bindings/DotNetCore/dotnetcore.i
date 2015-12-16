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

///////////////////////////////////////////////////////////
// STRINGPARAM "in" typemap
// Marshal a C++ style string to a wstring
// Allocate temporary memory only when required, otherwise
// use a buffer on the stack
//
%typemap(in) STRINGPARAM
{
#if defined(DOTNETCORE)
#if defined(WIN32)
    //out typemap - WIN32 (DOTNETCORE)
    $1 = (STRINGPARAM) $input;
#else
    //out typemap - LINUX (DOTNETCORE)
    $1 = (STRINGPARAM) X2W((XMLCh*)$input);
#endif
#else
    $1 = (STRINGPARAM) $input;
#endif
}

///////////////////////////////////////////////////////////
// STRING "out" typemap
// Marshal a string returned by C++ to CSharp
//
%typemap(out) STRING
{
#if defined(DOTNETCORE)
#if defined(WIN32)
    //out typemap - WIN32 (DOTNETCORE)
    $result = SWIG_csharp_wstring_callback((int)(result.length()+1)*sizeof(wchar_t));
    wcscpy((wchar_t*)$result, result.c_str());
#else
    //out typemap - LINUX (DOTNETCORE)
    xstring u16String;
    UnicodeString::UTF32toUTF16((const LCh*) result.c_str(), u16String);
    $result = SWIG_csharp_wstring_callback((int)(u16String.length()+1)*sizeof(LCh));
    //wcscpy((wchar_t*)$result, u16String.c_str());
    XMLString::copyString((XMLCh*)$result, u16String.c_str());
#endif
#else
    $result = SWIG_csharp_wstring_callback((int)(result.length()+1)*sizeof(wchar_t));
    wcscpy((wchar_t*)$result, result.c_str());
#endif
}

#if defined(DOTNETCORE)
// Special csout typemaps for .net core
//
// Because of (https://github.com/dotnet/coreclr/issues/2263), the existing exception propagation
// mechanism does not work for us as the <throw .net proxy exception in reverse PInvoke callback>
// part of the exception propagation crashes the CoreCLR on Linux with SIGABRT, so for .net Core
// we have to rearchitect how we propagate exceptions to .net
//
// Our rearchitected approach involves passing in a new struct (MgExceptionStatus) with each P/Invoke method
// call that will capture:
//
//   - Whether an exception was thrown
//   - The class id of the caught exception (so we know what .net proxy exception type to construct/re-throw)
//   - The pointer of the caught exception (to house in the .net proxy exception)
//
// Rather than hack our (already heavily hacked) version of SWIG, we'll actually use the
// customization features of SWIG that's available to us. In our case, the use of csout typemaps
// to augment the proxy code to:
//
//   1. Initialize an MgExceptionStatus struct.
//   2. Pass this in with the P/Invoke method call ($imcall)
//   3. Pass the struct to an MgExceptionHelper class that will figure out what appropriate .net exception class to re-throw 
//      if one was caught on the native side
//
// But the above paragraph is slightly false, as we did have to hack our copy of SWIG to insert the required
// ref struct parameter in all $imcall instances (which will happen with SWIG is invoked with a new -coreclr flag)
//
// I guess this is the consequence of having a heavily-modified version of SWIG (with a questionable audit trail of modifications), because
// the SWIG 1.3 documentation refers to a SWIG_CSharpSetPendingExceptionArgument native helper that does pretty much what we're after, but
// combing through the sources of our modified SWIG shows no references to this exception helper infrastrucutre!
//
%typemap(csout) void
{
    var status = new $imclassname.MgExceptionStatus(false, 0, IntPtr.Zero);
    $imcall;
    $imclassname.MgExceptionHelper.ThrowExceptionIfRequired(status);
}

// Generic typemap for any pointer type
//
// NOTES:
//
//  - The result variable from the $imcall must be always "cPtr" as that is what the SWIG-generated code will refer to
//  - new $csclassname(cPtr, $owner) will be replaced with a createObject() call by the SWIG-generated code
%typemap(csout) SWIGTYPE * 
{
    var status = new $imclassname.MgExceptionStatus(false, 0, IntPtr.Zero);
    var cPtr = $imcall;
    //Check and re-throw .net proxy if an exception was caught
    $imclassname.MgExceptionHelper.ThrowExceptionIfRequired(status);
    //Otherwise, it's okay to wrap and return our result
    $csclassname result = (cPtr == IntPtr.Zero) ? null : (new $csclassname(cPtr, $owner));
    return result;
}

%typemap(csout) int
{
    var status = new $imclassname.MgExceptionStatus(false, 0, IntPtr.Zero);
    var result = $imcall;
    $imclassname.MgExceptionHelper.ThrowExceptionIfRequired(status);
    return result;
}

%typemap(csout) double
{
    var status = new $imclassname.MgExceptionStatus(false, 0, IntPtr.Zero);
    var result = $imcall;
    $imclassname.MgExceptionHelper.ThrowExceptionIfRequired(status);
    return result;
}

%typemap(csout) float
{
    var status = new $imclassname.MgExceptionStatus(false, 0, IntPtr.Zero);
    var result = $imcall;
    $imclassname.MgExceptionHelper.ThrowExceptionIfRequired(status);
    return result;
}

%typemap(csout) short
{
    var status = new $imclassname.MgExceptionStatus(false, 0, IntPtr.Zero);
    var result = $imcall;
    $imclassname.MgExceptionHelper.ThrowExceptionIfRequired(status);
    return result;
}

%typemap(csout) bool
{
    var status = new $imclassname.MgExceptionStatus(false, 0, IntPtr.Zero);
    var result = $imcall;
    $imclassname.MgExceptionHelper.ThrowExceptionIfRequired(status);
    return result;
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
