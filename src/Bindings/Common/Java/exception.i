/**
 * exception.i
 *
 * Exception support
 */

/**
 * Java Exception hierarchy
 *
 * By default MgException inherits from MgSerializable. For it to be throwable in Java, we have to break
 * the inheritance chain and have MgException derive from our AppThrowable base exception class instead
 *
 * Breaking the MgSerializable inheritance chain is inconsequential as the methods provided by MgSerializable
 * are not available for managed code consumption
 */
%typemap(javabase, replace="1") MgException "AppThrowable"

%insert(header) %{
void ThrowJavaExceptionWrapper(JNIEnv *jenv, MgException* e) 
{
    std::string exName = "org/osgeo/mapguide/";
    exName += e->GetMultiByteClassName();
    jclass exCls = jenv->FindClass(exName.c_str());
    jmethodID ctorId = jenv->GetMethodID(exCls, "<init>", "(JZ)V");
    jthrowable exObj = (jthrowable)jenv->NewObject(exCls, ctorId, (jlong)e, (jboolean)1);
    jenv->Throw(exObj);
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
        ThrowJavaExceptionWrapper(jenv, mgException);
    }
}