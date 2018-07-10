# Java wrapper notes

This document describes the Java language binding for the MapGuide API

# Usage

Reference `MapGuideApi.jar` like you would any other java jar library and make sure that the `java.library.path` of your root Java application contains the path to:

 * `MapGuideJavaApi.dll` and supporting dlls on Windows
 * `libMapGuideJavaApi.so` on Linux. The zip package includes distro-specific builds of this library, make sure to use the correct library for your distro. All builds of this library have their RPATH set to `/usr/local/mapguideopensource-3.1.1/lib` and `/usr/local/mapguideopensource-3.1.1/webserverextensions/lib`, so any dependent libraries of `libMapGuideJavaApi.so` will be automatically detected and loaded assuming you have MapGuide Open Source 3.1.1 already installed.

# Overview of differences

This wrapper is based on the `MapGuideJavaApiEx` variant of the official Java binding ([original RFC here](https://trac.osgeo.org/mapguide/wiki/MapGuideRfc129)), and carries most of its changes/differences:

## 1. Minimum Java version

This binding was built with JDK 7

## 2. `MgException`/`AppThrowable` is no longer a checked exception

`AppThrowable` now extends `RuntimeException` making it (and `MgException` and its subclasses) unchecked exceptions, all methods in the MapGuide API no longer have the (`throws MgException`) clause.

## 3. Method names follow Java naming conventions

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

## 4. `java.util.Collection<T>` support

The following MapGuide collection classes now implement `java.util.Collection<T>`:

 - `MgBatchPropertyCollection` (T is `MgPropertyCollection`)
 - `MgClassDefinitionCollection` (T is `MgClassDefinition`)
 - `MgFeatureSchemaCollection` (T is `MgFeatureSchema`)
 - `MgPropertyCollection` (T is `MgProperty`)
 - `MgStringCollection` (T is `String`)
 
## 5. `java.util.Iterable<T>` support

The following classes now implement `java.util.Iterable<T>` allowing them to be used in an enhanced for-loop

 - `MgReadOnlyLayerCollection` (T is `MgLayerBase`)

Having `java.util.Iterable<T>` means that such instances can be be looped using the [enhanced for loop](https://blogs.oracle.com/corejavatechtips/using-enhanced-for-loops-with-your-classes) like so:

```
MgReadOnlyLayerCollection readOnlyLayers = ...;
for (MgLayerBase layer : readOnlyLayers) {
    ...
}
```

As `java.util.Collection<T>` inherits from `java.util.Iterable<T>`, such implementing classes can be used with the enhanced for loop as well.

## 6. Renamed methods

To avoid naming conflicts with SWIG generated code and methods from inherited java classes or interfaces as a result of the above changes, the following class methods have been renamed in the Java MapGuide API:

 - `MgException.GetStackTrace`        is now `MgException.getExceptionStackTrace`
 - `MgBatchPropertyCollection.Add`    is now `MgBatchPropertyCollection.addItem`
 - `MgClassDefinitionCollection.Add`  is now `MgClassDefinitionCollection.addItem`
 - `MgFeatureSchemaCollection.Add`    is now `MgFeatureSchemaCollection.addItem`
 - `MgIntCollection.Add`              is now `MgIntCollection.addItem`
 - `MgPropertyCollection.Add`         is now `MgPropertyCollection.addItem`
 - `MgStringCollection.Add`           is now `MgStringCollection.addItem`

## 7. The following classes implement `java.lang.AutoCloseable` and can be used with [try-with-resources](https://docs.oracle.com/javase/tutorial/essential/exceptions/tryResourceClose.html) statements:

 - `MgReader`
 - `MgFeatureReader`
 - `MgDataReader`
 - `MgSqlDataReader`
 - `MgLongTransactionReader`
 - `MgSpatialContextReader`

## 8. Tightened encapsulation

The SWIG-generated constructor for every proxy class is no longer `public`. This constructor was always reserved for use by SWIG.