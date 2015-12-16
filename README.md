# mapguide-api-bindings

Language bindings for the MapGuide API

# Motivation

We currently use a heavily modified version of [SWIG](http://swig.org) to generate 
language bindings for the [MapGuide](http://mapguide.osgeo.org) API

This modified version of SWIG is extermely old and has an unclear audit trail of modifications
which makes it difficult for us to expand language support beyond what we currently support:

 * PHP (5.5.x)
 * Java
 * .net (Full Framework)

# Supported Platforms

Our current focus of this project is to use the current version of SWIG (3.0.7 as of writing) to generate
MapGuide API bindings to support the following languages/platforms:

 * .net Core (Windows and Linux)
 
Eventually reaching platform parity with our existing offerings:

 * PHP (5.5.x)
 * Java
 * .net (Full Framework)

With future experimental (a.k.a Use at your own risk) support for other platforms that a current and unmodified SWIG can offer us:

 * Ruby
 * Python
 * node.js
 * and much more!