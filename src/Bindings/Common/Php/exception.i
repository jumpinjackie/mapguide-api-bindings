/**
 * exception.i
 *
 * Exception support
 */

%insert(header) %{
void ThrowPhpExceptionWrapper(MgException* e) 
{
    const char* exClassName = ResolveMgClassName(static_cast<MgObject*>(e)->GetClassId());
    swig_type_info* ty = SWIG_TypeQuery(exClassName);
    if (NULL == ty)
    {
        std::string msg = "Tried to throw ";
        msg += exClassName;
        msg += ", but no PHP proxy class definition could be found";
        zend_throw_exception(zend_ce_exception, msg.c_str(), 0);
    }
    else
    {
        zval obj;
        SWIG_SetPointerZval(&obj, (void *)e, ty, 1);
        zend_throw_exception_object(&obj);
    }
}
%}

%exception {
    MG_TRY()
        $action
    MG_CATCH(L"$wrapname")
    if (mgException != NULL) {
        //AddRef the exception as this is a Ptr<> it will auto-unref when leaving the method
        (*mgException).AddRef();
        ThrowPhpExceptionWrapper(mgException); 
    }
}