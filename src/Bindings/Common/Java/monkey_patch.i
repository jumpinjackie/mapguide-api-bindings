/**
 * Apply a global firstlowercase naming convention
 */
%rename("%(firstlowercase)s",%$isfunction) "";

//---------------------- Renames to avoid Java/C++ API clashes ---------------------------//

/**
 * Rename SWIG's "delete" to "destroy". However the typemaps to do this cannot just rename the thing
 * we have to repeat the expected implementation verbatim with the new name
 */
%typemap(javafinalize) SWIGTYPE %{
  protected void finalize() {
    destroy();  // renamed to prevent conflict with existing delete method
  }
%}
%typemap(javadestruct, methodname="destroy", methodmodifiers="public synchronized") SWIGTYPE
{
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        $jnicall;
      }
      swigCPtr = 0;
    }
}
%typemap(javadestruct_derived, methodname="destroy", methodmodifiers="public synchronized") SWIGTYPE
{
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        $jnicall;
      }
      swigCPtr = 0;
    }
    super.destroy();
}

//Already defined in Java Exception so rename our proxy method
%rename(getExceptionStackTrace) MgException::GetStackTrace;

//If we want to implement java.util.Collection, we need to rename this incompatible API (as add() is expected to 
//return boolean in the java.util.Collection API)
%rename(addItem) MgBatchPropertyCollection::Add;
%rename(addItem) MgClassDefinitionCollection::Add;
%rename(addItem) MgFeatureSchemaCollection::Add;
%rename(addItem) MgPropertyDefinitionCollection::Add;
%rename(addItem) MgIntCollection::Add;
%rename(addItem) MgPropertyCollection::Add;
%rename(addItem) MgStringCollection::Add;
%rename(addItem) MgLayerCollection::Add;
%rename(addItem) MgLayerGroupCollection::Add;