/**
 * coreclr_compat.i
 *
 * This overrides the standard pointer marshaling to revert back to System.IntPtr instead of 
 * System.Runtime.InteropServices.HandleRef as the latter is not supported on .net Core
 *
 * NOTE: Only covers whatever's necessary so that proxy classes in the MapGuide API no longer
 * use HandleRefs
 *
 * NOTE: SWIG must be run with SWIG_CSHARP_NO_EXCEPTION_HELPER defined
 */

//We need to break the inheritance hierarchy of MgException so that it is an actual
//CLR exception type
%typemap(csbase, replace="1") MgException "ManagedException"

%insert(runtime) %{

typedef void (SWIGSTDCALL* SWIG_CSharpMgExceptionCallback_t)(const void*, const char*); 

static SWIG_CSharpMgExceptionCallback_t mg_exception_callback = NULL;

#ifdef __cplusplus
extern "C" 
#endif
SWIGEXPORT void SWIGSTDCALL SWIGRegisterMgExceptionCallback_$module(SWIG_CSharpMgExceptionCallback_t callback)
{
    mg_exception_callback = callback;
}
%}

%pragma(csharp) imclasscode=%{
    protected class MgExceptionHelper {
        public delegate void MgExceptionDelegate(global::System.IntPtr exPtr, string className);
        
        static MgExceptionDelegate mgExceptionDelegate = new MgExceptionDelegate(SetPendingMgException);
        
        [global::System.Runtime.InteropServices.DllImport("$dllimport", EntryPoint="SWIGRegisterMgExceptionCallback_$module")]
        static extern void SWIGRegisterMgExceptionCallback_$module(MgExceptionDelegate mgDelegate);
        
        static void SetPendingMgException(global::System.IntPtr exPtr, string className)
        {
            //IMPORTANT: It is imperative that nothing throws here as while such behavior is acceptable on Windows, in
            //CoreCLR on Linux such a throw is treated as a native throw and will crash the running application with SIGABRT
            //
            //See: https://github.com/dotnet/coreclr/issues/2263
            //
            //SWIG by default will use SWIGPendingException to "stash" exceptions to be rethrown later on
            //we will use the same mechanism
        
            string qualifiedName = "OSGeo.MapGuide." + className;
            global::System.Type exType = global::System.Type.GetType(qualifiedName);
            if (exType == null)
            {
                object[] args = new object[2] { exPtr, true /* ownMemory */ };
                global::System.Exception ex = global::System.Activator.CreateInstance(exType, args) as global::System.Exception;
                if (ex != null)
                    SWIGPendingException.Set(ex);
                else //Shouldn't get here
                    SWIGPendingException.Set(new global::System.Exception("Attempted to construct a .net proxy of " + qualifiedName + ", but instance is not an exception type"));
            }
            else
            {
                SWIGPendingException.Set(new global::System.Exception("Attempted to construct a .net proxy of " + qualifiedName + ", but no such type exists"));
            } 
        }
        
        static MgExceptionHelper()
        {
            SWIGRegisterMgExceptionCallback_$module(mgExceptionDelegate);
        }
    }
    
    protected static MgExceptionHelper mgExceptionHelper = new MgExceptionHelper();
    
    public class SWIGPendingException
    {
        [global::System.ThreadStatic]
        private static global::System.Exception pendingException = null;
        private static int numExceptionsPending = 0;

        public static bool Pending
        {
            get
            {
                bool pending = false;
                if (numExceptionsPending > 0)
                if (pendingException != null)
                pending = true;
                return pending;
            } 
        }

        public static void Set(global::System.Exception e)
        {
            if (pendingException != null)
                throw new global::System.Exception("FATAL: An earlier pending exception from unmanaged code was missed and thus not thrown (" + pendingException.ToString() + ")", e);
            pendingException = e;
            lock(typeof($imclassname))
            {
                numExceptionsPending++;
            }
        }

        public static global::System.Exception Retrieve()
        {
            global::System.Exception e = null;
            if (numExceptionsPending > 0) 
            {
                if (pendingException != null) 
                {
                    e = pendingException;
                    pendingException = null;
                    lock(typeof($imclassname))
                    {
                        numExceptionsPending--;
                    }
                }
            }
            return e;
        }
    }
%}

// Exception support
%exception {
    MG_TRY()
        $action
    MG_CATCH(L"$wrapname")
    if (mgException != NULL) {
        char* exClassName = mgException->GetMultiByteClassName();
        mg_exception_callback(mgException.p, exClassName);
    }
}

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
    lock(this) 
    {
      //Unlike the standard Dispose() implemented generated by SWIG, we are reversing the order
      //so that the top-most parent Dispose() is the one that will be called first, which will
      //be Dispose() of MgDisposable, that will perform the necessary release of the underlying
      //pointer
      global::System.GC.SuppressFinalize(this);
      base.Dispose();
      if (swigCPtr != global::System.IntPtr.Zero) {
        if (swigCMemOwn) {
          swigCMemOwn = false;
          //Anything derived from MgDisposable can simply chain up to the parent Dispose()
          //where it will be properly de-referenced', otherwise call the SWIG generated
          //free function
          //
          //HACK: This should not be a runtime check, it should be a check we should ideally do from SWIG
          if (!typeof(MgDisposable).GetTypeInfo().IsAssignableFrom(typeof($csclassname).GetTypeInfo())) {
            $imcall;
          }
        }
        swigCPtr = global::System.IntPtr.Zero;
      }
    }
  }