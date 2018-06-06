/**
 * exception.i
 *
 * Exception support
 */

//To make MgException a throwable PHP exception, we need to break its inheritance chain
//which means we have to ignore MgSerializable. Although this is part of the public API
//surface, it is nothing more than a "marker" base class for internal server/webtier
//plumbing, none of which concerns and MapGuide application built on top of this. This
//will affect the inheritance chain of other classes, but once again due to the "marker"
//nature of this class, the breakage of this inheritance chain is inconsequential.
%ignore MgSerializable;

//Now that the inheritance chain has been broken, we can re-base MgException on top of
//PHP exception
%feature("exceptionclass") MgException;

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
        zend_class_entry* ce = NULL;
        const char* origClsName = e->GetMultiByteClassName();
        zend_string * classname = zend_string_init(origClsName, strlen(origClsName), 0);
        ce = zend_lookup_class(classname);
        zend_string_release(classname);

        if (NULL == ce)
        {
            std::string msg = "Tried to throw ";
            msg += exClassName;
            msg += ", but no PHP proxy class definition could be found";
            zend_throw_exception(zend_ce_exception, msg.c_str(), 0);
        }
        else
        {
            zval obj;
            zval cPtr;
            SWIG_SetPointerZval(&cPtr, (void *)e, ty, 1);
            object_init_ex(&obj, ce);
            add_property_zval(&obj, "_cPtr", &cPtr);
            zend_throw_exception_object(&obj);
        }
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
        RefCount(mgException);
        ThrowPhpExceptionWrapper(mgException);
        goto thrown; //thrown is a SWIG-generated label
    }
}