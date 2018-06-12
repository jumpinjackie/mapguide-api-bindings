/**
 * Apply a global firstlowercase naming convention
 */
%rename("%(firstlowercase)s",%$isfunction) "";

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

//---------------------- Renames to avoid Java/C++ API clashes ---------------------------//

//Already defined in Java Exception so rename our proxy method
%rename(getExceptionStackTrace) MgException::GetStackTrace;

//delete() is the name of the standard SWIG release method called on finalize(). Unfortunately this conflicts with
//MgPropertyDefinition::Delete, MgClassDefinition::Delete and MgFeatureSchema::Delete when java proxy clases for these
//classes are generated
//
//So rename the java proxies to these methods. This is the most minimally destructive change of all the available options
//available to us
%rename(markAsDeleted) MgPropertyDefinition::Delete;
%rename(markAsDeleted) MgClassDefinition::Delete;
%rename(markAsDeleted) MgFeatureSchema::Delete;

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