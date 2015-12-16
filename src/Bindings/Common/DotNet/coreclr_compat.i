/**
 * coreclr_compat.i
 *
 * This overrides the standard pointer marshaling to revert back to System.IntPtr instead of 
 * System.Runtime.InteropServices.HandleRef as the latter is not supported on .net Core
 *
 * NOTE: Only covers whatever's necessary so that proxy classes in the MapGuide API no longer
 * use HandleRefs
 */

/* Non primitive types */
%typemap(ctype) SWIGTYPE "void *"
%typemap(imtype) SWIGTYPE "global::System.IntPtr"
%typemap(cstype) SWIGTYPE "$&csclassname"

%typemap(ctype) SWIGTYPE [] "void *"
%typemap(imtype) SWIGTYPE [] "global::System.IntPtr"
%typemap(cstype) SWIGTYPE [] "$csclassname"

%typemap(ctype) SWIGTYPE * "void *"
%typemap(imtype) SWIGTYPE * "global::System.IntPtr"
%typemap(cstype) SWIGTYPE * "$csclassname"

%typemap(ctype) SWIGTYPE & "void *"
%typemap(imtype) SWIGTYPE & "global::System.IntPtr"
%typemap(cstype) SWIGTYPE & "$csclassname"

%typemap(ctype) SWIGTYPE && "void *"
%typemap(imtype) SWIGTYPE && "global::System.IntPtr"
%typemap(cstype) SWIGTYPE && "$csclassname"

// csbody typemaps... these are in macros so that the visibility of the methods can be easily changed by users.

%define SWIG_BACKCOMPAT_CSBODY_PROXY(PTRCTOR_VISIBILITY, CPTR_VISIBILITY, TYPE...)
// Proxy classes (base classes, ie, not derived classes)
%typemap(csbody) TYPE %{
  private global::System.IntPtr swigCPtr;
  protected bool swigCMemOwn;

  PTRCTOR_VISIBILITY $csclassname(global::System.IntPtr cPtr, bool cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = cPtr;
  }

  CPTR_VISIBILITY static global::System.IntPtr getCPtr($csclassname obj) {
    return (obj == null) ? global::System.IntPtr.Zero : obj.swigCPtr;
  }
%}

// Derived proxy classes
%typemap(csbody_derived) TYPE %{
  private global::System.IntPtr swigCPtr;

  PTRCTOR_VISIBILITY $csclassname(global::System.IntPtr cPtr, bool cMemoryOwn) : base($imclassname.$csclazznameSWIGUpcast(cPtr), cMemoryOwn) {
    swigCPtr = cPtr;
  }

  CPTR_VISIBILITY static global::System.IntPtr getCPtr($csclassname obj) {
    return (obj == null) ? global::System.IntPtr.Zero : obj.swigCPtr;
  }
%}
%enddef

%define SWIG_BACKCOMPAT_CSBODY_TYPEWRAPPER(PTRCTOR_VISIBILITY, DEFAULTCTOR_VISIBILITY, CPTR_VISIBILITY, TYPE...)
// Typewrapper classes
%typemap(csbody) TYPE *, TYPE &, TYPE &&, TYPE [] %{
  private global::System.IntPtr swigCPtr;

  PTRCTOR_VISIBILITY $csclassname(global::System.IntPtr cPtr, bool futureUse) {
    swigCPtr = cPtr;
  }

  DEFAULTCTOR_VISIBILITY $csclassname() {
    swigCPtr = global::System.IntPtr.Zero;
  }

  CPTR_VISIBILITY static global::System.IntPtr getCPtr($csclassname obj) {
    return (obj == null) ? global::System.IntPtr.Zero : obj.swigCPtr;
  }
%}

%typemap(csbody) TYPE (CLASS::*) %{
  private string swigCMemberPtr;

  PTRCTOR_VISIBILITY $csclassname(string cMemberPtr, bool futureUse) {
    swigCMemberPtr = cMemberPtr;
  }

  DEFAULTCTOR_VISIBILITY $csclassname() {
    swigCMemberPtr = null;
  }

  CPTR_VISIBILITY static string getCMemberPtr($csclassname obj) {
    return obj.swigCMemberPtr;
  }
%}
%enddef

/* Set the default csbody typemaps to use internal visibility.
   Use the macros to change to public if using multiple modules. */
SWIG_BACKCOMPAT_CSBODY_PROXY(internal, internal, SWIGTYPE)
SWIG_BACKCOMPAT_CSBODY_TYPEWRAPPER(internal, protected, internal, SWIGTYPE)

%typemap(csdestruct, methodname="Dispose", methodmodifiers="public") SWIGTYPE {
    lock(this) {
      if (swigCPtr != global::System.IntPtr.Zero) {
        if (swigCMemOwn) {
          swigCMemOwn = false;
          $imcall;
        }
        swigCPtr = global::System.IntPtr.Zero;
      }
      global::System.GC.SuppressFinalize(this);
    }
  }

%typemap(csdestruct_derived, methodname="Dispose", methodmodifiers="public") SWIGTYPE {
    lock(this) {
      if (swigCPtr != global::System.IntPtr.Zero) {
        if (swigCMemOwn) {
          swigCMemOwn = false;
          $imcall;
        }
        swigCPtr = global::System.IntPtr.Zero;
      }
      global::System.GC.SuppressFinalize(this);
      base.Dispose();
    }
  }