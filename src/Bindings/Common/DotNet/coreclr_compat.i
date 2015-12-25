/**
 * coreclr_compat.i
 *
 * SWIG typemaps and macros for CoreCLR support
 *
 * NOTE: SWIG must be run with SWIG_CSHARP_NO_EXCEPTION_HELPER defined
 */

/**
 * .net reverse string marshaling
 *
 * For reasons unknown, the default SWIG string helper produces garbage from our returned strings. This is probably
 * due to our APIs returning STL strings and lifetime issues that make it incompatible.
 *
 * We know the impl from our modified version works so this is that implementation
 */
%insert(runtime) %{
/* Callback for returning strings to C# without leaking memory */
typedef void * (SWIGSTDCALL* SWIG_CSharpMgStringHelperCallback)(int);
static SWIG_CSharpMgStringHelperCallback mg_string_callback = NULL;
%}

%pragma(csharp) imclasscode=%{
    class MgStringHelper 
    {
        public delegate global::System.IntPtr MgStringDelegate(int len);
        
        static MgStringDelegate stringDelegate = new MgStringDelegate(CreateString);

        [global::System.Runtime.InteropServices.DllImport("$dllimport", EntryPoint="MgRegisterStringCallback_$module")]
        public static extern void MgRegisterStringCallback_$module(MgStringDelegate stringDelegate);

        static global::System.IntPtr CreateString(int len)
        {
            return global::System.Runtime.InteropServices.Marshal.AllocCoTaskMem(len);
        }

        static MgStringHelper()
        {
            MgRegisterStringCallback_$module(stringDelegate);
        }
    }

    static MgStringHelper stringHelper = new MgStringHelper();
%}

%insert(runtime) %{
#ifdef __cplusplus
extern "C" 
#endif
SWIGEXPORT void SWIGSTDCALL MgRegisterStringCallback_$module(SWIG_CSharpMgStringHelperCallback callback)
{
    mg_string_callback = callback;
}
%}

/**
 * .net Exception hierarchy
 *
 * By default MgException inherits from MgSerializable. For it to be throwable in .net, we have to break
 * the inheritance chain and have MgException derive from our ManagedException base exception class instead
 *
 * Breaking the MgSerializable inheritance chain is inconsequential as the methods provided by MgSerializable
 * are not available for managed code consumption
 */
%typemap(csbase, replace="1") MgException "ManagedException"

/**
 * Exception propagation support
 */
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
            global::System.Exception ex = OSGeo.MapGuide.MgObjectFactory.CreateObject<global::System.Exception>(exPtr);
            if (ex != null)
                SWIGPendingException.Set(ex);
            else //Shouldn't get here
                SWIGPendingException.Set(new global::System.Exception("Attempted to construct a .net proxy of " + className + ", but instance is not an exception type"));
        }
        
        static MgExceptionHelper()
        {
            SWIGRegisterMgExceptionCallback_$module(mgExceptionDelegate);
        }
    }
    
    protected static MgExceptionHelper mgExceptionHelper = new MgExceptionHelper();
    
    internal class SWIGPendingException
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
        //AddRef the exception as this is a Ptr<> it will auto-unref when leaving the method
        (*mgException).AddRef();
        char* exClassName = mgException->GetMultiByteClassName();
        mg_exception_callback(mgException.p, exClassName);
    }
}

/**
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

/**
 * .net polymorphism support
 *
 * We leverage the fact that every object type derives from MgObject which can describe its own class name
 * We use this information to determine what .net proxy class to create when any method returns a Mg* class
 */

//Insert the necessary helper functions on the native side to assist
//
//NOTE: extern "C" not required as SWIG will already take care of that
%insert(header) %{

#ifdef __cplusplus
extern "C"
#endif
SWIGEXPORT int SWIGSTDCALL GetClassId(void* ptrObj)
{
    return ((MgObject*)ptrObj)->GetClassId();
}

#ifdef __cplusplus
extern "C"
#endif
SWIGEXPORT void* SWIGSTDCALL GetClassName(void* ptrObj)
{
    void* result = NULL;
    STRING clsName = ((MgObject*)ptrObj)->GetClassName();
    result = mg_string_callback((int)(clsName.length()+1)*sizeof(wchar_t));
#ifdef _WIN32
    wcscpy((wchar_t*)result, clsName.c_str());
#else
    xstring u16String;
    UnicodeString::UTF32toUTF16((const LCh*) clsName.c_str(), u16String);
    result = mg_string_callback((int)(u16String.length()+1)*sizeof(LCh));
    XMLString::copyString((XMLCh*)result, u16String.c_str());
#endif
    return result;
}

%}

//Override the default typemap.
%typemap(csout) SWIGTYPE * 
{
    var objPtr = $imcall;$excode
    if (objPtr == global::System.IntPtr.Zero)
    {
        return null;
    }
    else
    {
        var result = MgObjectFactory.CreateObject<$csclassname>(objPtr);
        return result;
    }
}

%pragma(csharp) imclasscode=%{
    [global::System.Runtime.InteropServices.DllImport("$dllimport", EntryPoint="GetClassId")]
    internal static extern int GetClassId(global::System.IntPtr objPtr);

    [global::System.Runtime.InteropServices.DllImport("$dllimport", EntryPoint="GetClassName")]
    internal static extern global::System.IntPtr GetClassName(global::System.IntPtr objPtr);
%}