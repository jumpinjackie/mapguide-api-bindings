# .net wrapper notes

This document describes the .net language binding for the MapGuide API

# Differences from the official .net binding

 * General
    * This binding is back to being a monolithic assembly. A split assembly layout is not possible due to missing types in .net Core that made this possible in the full framework (eg. AppDomain)
    * In line with the .net core build system, the unit of consumption is a nuget package.
    * The nuget package contains both x86 and x64 windows binaries and because it targets `netstandard2.0` it can be used in both .net Core and Full Framework.
 * API
    * General
       * The ```(IntPtr cPtr, bool memOwn)``` constructor signature is no longer public. This was always for SWIG internal use and should not be public. 
    * MgColor
       * There is no overload that accepts ```System.Drawing.Color``` as a parameter. (```System.Drawing``` does not exist in .net core)
    * MgStringCollection
       * Implements ```IList<string>```
       * Optional constructor no longer takes a ```StringCollection```, but a ```IEnumerable<string>```
       * Implicit conversion operators have been removed
 * New APIs
    * `MgReadOnlyStream`: A convenience `System.IO.Stream` adapter over any `MgByteReader` instance.