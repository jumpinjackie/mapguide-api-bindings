# Java wrapper notes

This document describes the Java language binding for the MapGuide API

# Overview of differences

This wrapper is based on the `MapGuideJavaApiEx` experimental variant of the official Java binding, and carries most of its changes/differences:

1. `MgException`/`AppThrowable` is no longer a checked exception

`AppThrowable` now extends `RuntimeException` making it (and `MgException` and its subclasses) unchecked exceptions, all methods in the MapGuide API no longer have the (`throws MgException`) clause.

2. Method names follow Java naming conventions

All method names in the Java proxy classes are now in lowerCamelCase instead of the MapGuide-default UpperCamelCase

 eg. Instead of this:
```
    MgSiteConnection siteConn = new MgSiteConnection();
    MgUserInformation userInfo = new MgUserInfomration(sessionId);
    siteConn.Open(userInfo);
    MgFeatureService featureSvc = (MgFeatureService)siteConn.CreateService(MgServiceType.FeatureService);
    MgFeatureSchemaCollection schema = featureSvc.DescribeSchema(new MgResourceIdentifier("Library://Samples/Sheboygan/Data/Parcels.FeatureSource"), "SHP_Schema");
```
 It is now this:
```
    MgSiteConnection siteConn = new MgSiteConnection();
    MgUserInformation userInfo = new MgUserInfomration(sessionId);
    siteConn.open(userInfo); //Note the lowercase
    MgFeatureService featureSvc = (MgFeatureService)siteConn.createService(MgServiceType.FeatureService); //Note the lowercase
    MgFeatureSchemaCollection schema = featureSvc.describeSchema(new MgResourceIdentifier("Library://Samples/Sheboygan/Data/Parcels.FeatureSource"), "SHP_Schema"); //Note the lowercase
```

The `MgInitializeWebTier` entry point also obeys this convention (now named `mgInitializeWebTier`)

3. The following MapGuide collection classes now implement `java.util.Collection<T>`:

 - `MgBatchPropertyCollection` (T is `MgPropertyCollection`)
 - `MgClassDefinitionCollection` (T is `MgClassDefinition`)
 - `MgFeatureSchemaCollection` (T is `MgFeatureSchema`)
 - `MgPropertyCollection` (T is `MgProperty`)
 - `MgStringCollection` (T is `String`)
 
4. The following classes now implement `java.util.Iterable<T>` allowing them to be used in an enhanced for-loop

 - `MgReadOnlyLayerCollection` (T is `MgLayerBase`)

5. To avoid naming conflicts with SWIG generated code and methods from inherited java classes or interfaces as a result of the above changes, the following class methods have been renamed in the Java MapGuide API:

 - `MgException.GetStackTrace`        is now `MgException.getExceptionStackTrace`
 - `MgBatchPropertyCollection.Add`    is now `MgBatchPropertyCollection.addItem`
 - `MgClassDefinitionCollection.Add`  is now `MgClassDefinitionCollection.addItem`
 - `MgFeatureSchemaCollection.Add`    is now `MgFeatureSchemaCollection.addItem`
 - `MgIntCollection.Add`              is now `MgIntCollection.addItem`
 - `MgPropertyCollection.Add`         is now `MgPropertyCollection.addItem`
 - `MgStringCollection.Add`           is now `MgStringCollection.addItem`

6. The following classes implement `java.lang.AutoCloseable` and can be used with try-with-resources statements:

 - `MgReader`
 - `MgFeatureReader`
 - `MgDataReader`
 - `MgSqlDataReader`
 - `MgLongTransactionReader`
 - `MgSpatialContextReader`

7. Tightened encapsulation

The SWIG-generated constructor for every proxy class is no longer `public`. This constructor was always reserved for use by SWIG.