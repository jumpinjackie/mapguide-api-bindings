# .net Core wrapper notes

This document describes the .net Core language binding for the MapGuide API

# Differences from the official .net binding

 * General
    * This binding is a monolithic assembly. A split assembly layout for .net Core is not possible due to missing types that made this possible in the full framework (eg. AppDomain)
    * In line with the .net core build system, the unit of consumption is a nuget package.
 * API
    * General
       * The ```(IntPtr cPtr, bool memOwn)``` constructor signature is no longer public. This was always for SWIG internal use. 
    * MgColor
       * There is no overload that accepts System.Drawing.Color as a parameter. (System.Drawing does not exist in .net core)
    * MgStringCollection
       * Implements ```IList<string>```
       * Optional constructor no longer takes a ```StringCollection```, but a ```IEnumerable<string>```
       * Implicit conversion operators have been removed