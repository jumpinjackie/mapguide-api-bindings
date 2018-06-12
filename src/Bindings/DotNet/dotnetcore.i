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
%include "MapGuideApi_Properties.i"
%include "../Common/DotNet/string.i"
%include "../Common/DotNet/coreclr_compat.i"
%include "../Common/DotNet/sugar.i"
%include "../Common/DotNet/custom.i"

// Add default namespaces for all generated proxies
%typemap(csimports) SWIGTYPE %{
using System;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Collections.Generic;
//These warnings are false positives as a result of SWIG generated code
#pragma warning disable 0108, 0114
%}

%pragma(csharp) moduleimports=%{
using System;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Collections.Generic;
%}

// These methods have to be invoked C-style
%ignore MgObject::GetClassId;
%ignore MgObject::GetClassName;

%include "../Common/refcount.i"

// Have these collections implement the .net collection interfaces
IMPLEMENT_LIST(MgClassDefinitionCollection, MgClassDefinition)
IMPLEMENT_LIST(MgFeatureSchemaCollection, MgFeatureSchema)
IMPLEMENT_LIST(MgPropertyDefinitionCollection, MgPropertyDefinition)
IMPLEMENT_LIST(MgPropertyCollection, MgProperty)
IMPLEMENT_LIST(MgStringCollection, String)
IMPLEMENT_LIST(MgLayerCollection, MgLayerBase)
IMPLEMENT_LIST(MgLayerGroupCollection, MgLayerGroup)
IMPLEMENT_LIST(MgStringPropertyCollection, MgStringProperty)
IMPLEMENT_LIST(MgFeatureCommandCollection, MgFeatureCommand)
IMPLEMENT_LIST(MgMapCollection, MgMapBase)
IMPLEMENT_LIST(MgMapPlotCollection, MgMapPlot)
//IMPLEMENT_LIST(MgBatchPropertyCollection, MgPropertyCollection)
IMPLEMENT_LIST(MgIntCollection, int)
IMPLEMENT_LIST(MgCoordinateCollection, MgCoordinate)
IMPLEMENT_LIST(MgPointCollection, MgPoint)
IMPLEMENT_LIST(MgLineStringCollection, MgLineString)
IMPLEMENT_LIST(MgLinearRingCollection, MgLinearRing)
IMPLEMENT_LIST(MgCurveRingCollection, MgCurveRing)
IMPLEMENT_LIST(MgCurveStringCollection, MgCurveString)
IMPLEMENT_LIST(MgCurveSegmentCollection, MgCurveSegment)
IMPLEMENT_LIST(MgCurvePolygonCollection, MgCurvePolygon)
IMPLEMENT_LIST(MgPolygonCollection, MgPolygon)
IMPLEMENT_LIST(MgGeometryCollection, MgGeometry)
IMPLEMENT_READONLY_LIST(MgReadOnlyLayerCollection, MgLayerBase)

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
    if (NULL == $input)
    {
        $1 = STRINGPARAM(L"");
    }
    else
    {
        $1 = (STRINGPARAM) X2W((XMLCh*)$input);
    }
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
    $result = mg_string_callback((int)($1.length()+1)*sizeof(wchar_t));
    wcscpy((wchar_t*)$result, $1.c_str());
}
#else
%typemap(out) STRING
{
    //out typemap - LINUX (DOTNETCORE)
    xstring u16String;
    UnicodeString::UTF32toUTF16((const LCh*) $1.c_str(), u16String);
    $result = mg_string_callback((int)(u16String.length()+1)*sizeof(LCh));
    XMLString::copyString((XMLCh*)$result, u16String.c_str());
}
#endif
#else
%typemap(out) STRING
{
    $result = mg_string_callback((int)($1.length()+1)*sizeof(wchar_t));
    wcscpy((wchar_t*)$result, $1.c_str());
}
#endif

///////////////////////////////////////////////////////////
// BYTE_ARRAY_OUT "cstype" typemap
// Type substitution in .NET and proxy code
//
%typemap(cstype) BYTE_ARRAY_OUT "global::System.Byte[]"
%typemap(imtype) BYTE_ARRAY_OUT "global::System.Byte[]"
%typemap(ctype)  BYTE_ARRAY_OUT "unsigned char*"

///////////////////////////////////////////////////////////
// BYTE_ARRAY_IN "cstype" typemap
// Type substitution in .NET and proxy code
//
%typemap(cstype) BYTE_ARRAY_IN "global::System.Byte[]"
%typemap(imtype) BYTE_ARRAY_IN "global::System.Byte[]"
%typemap(ctype)  BYTE_ARRAY_IN "unsigned char*"

///////////////////////////////////////////////////////////
// Global functions
//
void MgInitializeWebTier(STRINGPARAM configFile);
