/**
 * pointer.i
 *
 * Generic pointer typemap for MgObject-derived classes (ie. Everything in the MapGuide API)
 */

///////////////////////////////////////////////////////////
// Custom generic pointer typemap. This overrides the default
// typemap to support downcasting
//
%typemap(out) SWIGTYPE* 
{
    const char* retClassName = ResolveMgClassName(static_cast<MgObject*>($1)->GetClassId());
    swig_type_info* ty = NULL;
    if (NULL != retClassName)
    {
        ty = SWIG_TypeQuery(retClassName);
    }
    if (NULL == ty) //Fallback to original descriptor
    {
        ty = $1_descriptor;
    }
    SWIG_SetPointerZval(return_value, (void *)$1, ty, $owner);
    RefCount($1);
}