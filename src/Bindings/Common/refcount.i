/**
 * refcount.i
 *
 * Common refcounting module applicable for all language targets
 */

// SWIG is refcounting aware and since our C++ classes follow a refcounting scheme
// we can tap into this feature
//
// NOTE: We don't implement ref because anything from the native boundary is already AddRef'd
// All the managed layer should do when Disposed or GC'd is to make sure it is released
%feature("ref")   MgDisposable "RefCount($this);"
%feature("unref") MgDisposable "ReleaseObject($this);"

%runtime %{
#include "Foundation.h"

#if defined(REFCOUNTING_DIAGNOSTICS)
INT32 RefCount(MgDisposable* obj)
{
    INT32 rc = obj->GetRefCount();
#if defined(SWIGPHP)
    zend_printf("[zend]: Ref-count for instance of (%s): %p - %d\n", obj->GetMultiByteClassName(), (void*)obj, rc);
#else
    printf("[native]: Ref-count for instance of (%s): %p - %d\n", obj->GetMultiByteClassName(), (void*)obj, rc);
#endif
    return rc;
}

void ReleaseObject(MgDisposable* obj)
{
    INT32 rc = obj->GetRefCount();
#if defined(SWIGPHP)
    zend_printf("[zend]: Releasing instance of (%s): %p (%d -> %d)\n", obj->GetMultiByteClassName(), (void*)obj, rc, rc - 1);
#else
    printf("[native]: Releasing instance of (%s): %p (%d -> %d)\n", obj->GetMultiByteClassName(), (void*)obj, rc, rc - 1);
#endif
    SAFE_RELEASE(obj);
}
#else
#define RefCount(obj)
void ReleaseObject(MgDisposable* obj)
{
    SAFE_RELEASE(obj);
}
#endif
%}