package org.osgeo.mapguide;

import java.util.*;
import java.lang.reflect.*;

public class ObjectFactory
{
    public static Object createObject(int id, long cptr, boolean ownCptr)
    {
        Constructor ctor = (Constructor)classMap.get(new Integer(id));
        if(ctor == null)
            return null;
        try
        {
            return ctor.newInstance(new Object[] { new Long(cptr), new Boolean(ownCptr) });
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return null;
        }
    }


    protected static Hashtable classMap;

    static
    {
        classMap = new Hashtable();
        try
        {
            classMap.put(new Integer(20004), getSWIGCtor("MgAgfReaderWriter"));
            classMap.put(new Integer(20005), getSWIGCtor("MgAggregateGeometry"));
            classMap.put(new Integer(1500), getSWIGCtor("MgApplicationException"));
            classMap.put(new Integer(20006), getSWIGCtor("MgArcSegment"));
            classMap.put(new Integer(1501), getSWIGCtor("MgArgumentOutOfRangeException"));
            classMap.put(new Integer(10500), getSWIGCtor("MgArrayTypeMismatchException"));
            classMap.put(new Integer(30000), getSWIGCtor("MgAuthenticationFailedException"));
            classMap.put(new Integer(1005), getSWIGCtor("MgBatchPropertyCollection"));
            classMap.put(new Integer(10252), getSWIGCtor("MgBlobProperty"));
            classMap.put(new Integer(10253), getSWIGCtor("MgBooleanProperty"));
            classMap.put(new Integer(10254), getSWIGCtor("MgByteProperty"));
            classMap.put(new Integer(1250), getSWIGCtor("MgByteReader"));
            classMap.put(new Integer(1257), getSWIGCtor("MgByteSink"));
            classMap.put(new Integer(1251), getSWIGCtor("MgByteSource"));
            classMap.put(new Integer(11750), getSWIGCtor("MgClassDefinition"));
            classMap.put(new Integer(11780), getSWIGCtor("MgClassDefinitionCollection"));
            classMap.put(new Integer(1502), getSWIGCtor("MgClassNotFoundException"));
            classMap.put(new Integer(10255), getSWIGCtor("MgClobProperty"));
            classMap.put(new Integer(10250), getSWIGCtor("MgColor"));
            classMap.put(new Integer(1503), getSWIGCtor("MgConfigurationException"));
            classMap.put(new Integer(1504), getSWIGCtor("MgConfigurationLoadFailedException"));
            classMap.put(new Integer(1505), getSWIGCtor("MgConfigurationSaveFailedException"));
            classMap.put(new Integer(30001), getSWIGCtor("MgConnectionFailedException"));
            classMap.put(new Integer(30002), getSWIGCtor("MgConnectionNotOpenException"));
            classMap.put(new Integer(20003), getSWIGCtor("MgCoordinate"));
            classMap.put(new Integer(20009), getSWIGCtor("MgCoordinateIterator"));
            classMap.put(new Integer(20500), getSWIGCtor("MgCoordinateSystem"));
            classMap.put(new Integer(20504), getSWIGCtor("MgCoordinateSystemCatalog"));
            classMap.put(new Integer(20506), getSWIGCtor("MgCoordinateSystemCategory"));
            classMap.put(new Integer(20510), getSWIGCtor("MgCoordinateSystemCategoryDictionary"));
            classMap.put(new Integer(21000), getSWIGCtor("MgCoordinateSystemComputationFailedException"));
            classMap.put(new Integer(21001), getSWIGCtor("MgCoordinateSystemConversionFailedException"));
            classMap.put(new Integer(20507), getSWIGCtor("MgCoordinateSystemDatum"));
            classMap.put(new Integer(20512), getSWIGCtor("MgCoordinateSystemDatumDictionary"));
            classMap.put(new Integer(20511), getSWIGCtor("MgCoordinateSystemDictionary"));
            classMap.put(new Integer(20521), getSWIGCtor("MgCoordinateSystemDictionaryUtility"));
            classMap.put(new Integer(20509), getSWIGCtor("MgCoordinateSystemEllipsoid"));
            classMap.put(new Integer(20513), getSWIGCtor("MgCoordinateSystemEllipsoidDictionary"));
            classMap.put(new Integer(20514), getSWIGCtor("MgCoordinateSystemEnum"));
            classMap.put(new Integer(20515), getSWIGCtor("MgCoordinateSystemEnumInteger32"));
            classMap.put(new Integer(20501), getSWIGCtor("MgCoordinateSystemFactory"));
            classMap.put(new Integer(20516), getSWIGCtor("MgCoordinateSystemFilter"));
            classMap.put(new Integer(20517), getSWIGCtor("MgCoordinateSystemFilterInteger32"));
            classMap.put(new Integer(20505), getSWIGCtor("MgCoordinateSystemFormatConverter"));
            classMap.put(new Integer(20542), getSWIGCtor("MgCoordinateSystemGeodeticAnalyticalTransformDefParams"));
            classMap.put(new Integer(20543), getSWIGCtor("MgCoordinateSystemGeodeticInterpolationTransformDefParams"));
            classMap.put(new Integer(20544), getSWIGCtor("MgCoordinateSystemGeodeticMultipleRegressionTransformDefParams"));
            classMap.put(new Integer(20533), getSWIGCtor("MgCoordinateSystemGeodeticPath"));
            classMap.put(new Integer(20535), getSWIGCtor("MgCoordinateSystemGeodeticPathDictionary"));
            classMap.put(new Integer(20534), getSWIGCtor("MgCoordinateSystemGeodeticPathElement"));
            classMap.put(new Integer(20508), getSWIGCtor("MgCoordinateSystemGeodeticTransformation"));
            classMap.put(new Integer(20536), getSWIGCtor("MgCoordinateSystemGeodeticTransformDef"));
            classMap.put(new Integer(20540), getSWIGCtor("MgCoordinateSystemGeodeticTransformDefDictionary"));
            classMap.put(new Integer(20545), getSWIGCtor("MgCoordinateSystemGeodeticTransformGridFile"));
            classMap.put(new Integer(20532), getSWIGCtor("MgCoordinateSystemGridBase"));
            classMap.put(new Integer(20524), getSWIGCtor("MgCoordinateSystemGridBoundary"));
            classMap.put(new Integer(20529), getSWIGCtor("MgCoordinateSystemGridLine"));
            classMap.put(new Integer(20526), getSWIGCtor("MgCoordinateSystemGridLineCollection"));
            classMap.put(new Integer(20530), getSWIGCtor("MgCoordinateSystemGridRegion"));
            classMap.put(new Integer(20527), getSWIGCtor("MgCoordinateSystemGridRegionCollection"));
            classMap.put(new Integer(20525), getSWIGCtor("MgCoordinateSystemGridSpecification"));
            classMap.put(new Integer(20531), getSWIGCtor("MgCoordinateSystemGridTick"));
            classMap.put(new Integer(20528), getSWIGCtor("MgCoordinateSystemGridTickCollection"));
            classMap.put(new Integer(21002), getSWIGCtor("MgCoordinateSystemInitializationFailedException"));
            classMap.put(new Integer(21003), getSWIGCtor("MgCoordinateSystemLoadFailedException"));
            classMap.put(new Integer(20518), getSWIGCtor("MgCoordinateSystemMathComparator"));
            classMap.put(new Integer(20502), getSWIGCtor("MgCoordinateSystemMeasure"));
            classMap.put(new Integer(21004), getSWIGCtor("MgCoordinateSystemMeasureFailedException"));
            classMap.put(new Integer(20522), getSWIGCtor("MgCoordinateSystemMgrs"));
            classMap.put(new Integer(20520), getSWIGCtor("MgCoordinateSystemProjectionInformation"));
            classMap.put(new Integer(20503), getSWIGCtor("MgCoordinateSystemTransform"));
            classMap.put(new Integer(21005), getSWIGCtor("MgCoordinateSystemTransformFailedException"));
            classMap.put(new Integer(20519), getSWIGCtor("MgCoordinateSystemUnitInformation"));
            classMap.put(new Integer(20048), getSWIGCtor("MgCoordinateXY"));
            classMap.put(new Integer(20051), getSWIGCtor("MgCoordinateXYM"));
            classMap.put(new Integer(20049), getSWIGCtor("MgCoordinateXYZ"));
            classMap.put(new Integer(20050), getSWIGCtor("MgCoordinateXYZM"));
            classMap.put(new Integer(20010), getSWIGCtor("MgCurve"));
            classMap.put(new Integer(20011), getSWIGCtor("MgCurvePolygon"));
            classMap.put(new Integer(20047), getSWIGCtor("MgCurvePolygonCollection"));
            classMap.put(new Integer(20012), getSWIGCtor("MgCurveRing"));
            classMap.put(new Integer(20052), getSWIGCtor("MgCurveRingCollection"));
            classMap.put(new Integer(20013), getSWIGCtor("MgCurveSegment"));
            classMap.put(new Integer(20041), getSWIGCtor("MgCurveSegmentCollection"));
            classMap.put(new Integer(20014), getSWIGCtor("MgCurveString"));
            classMap.put(new Integer(20043), getSWIGCtor("MgCurveStringCollection"));
            classMap.put(new Integer(11751), getSWIGCtor("MgDataPropertyDefinition"));
            classMap.put(new Integer(11773), getSWIGCtor("MgDataReader"));
            classMap.put(new Integer(1256), getSWIGCtor("MgDateTime"));
            classMap.put(new Integer(1506), getSWIGCtor("MgDateTimeException"));
            classMap.put(new Integer(10256), getSWIGCtor("MgDateTimeProperty"));
            classMap.put(new Integer(30003), getSWIGCtor("MgDbException"));
            classMap.put(new Integer(30004), getSWIGCtor("MgDbXmlException"));
            classMap.put(new Integer(1507), getSWIGCtor("MgDecryptionException"));
            classMap.put(new Integer(11775), getSWIGCtor("MgDeleteFeatures"));
            classMap.put(new Integer(1508), getSWIGCtor("MgDirectoryNotFoundException"));
            classMap.put(new Integer(1000), getSWIGCtor("MgDisposableCollection"));
            classMap.put(new Integer(1509), getSWIGCtor("MgDivideByZeroException"));
            classMap.put(new Integer(1510), getSWIGCtor("MgDomainException"));
            classMap.put(new Integer(10257), getSWIGCtor("MgDoubleProperty"));
            classMap.put(new Integer(30700), getSWIGCtor("MgDrawingService"));
            classMap.put(new Integer(1511), getSWIGCtor("MgDuplicateDirectoryException"));
            classMap.put(new Integer(1512), getSWIGCtor("MgDuplicateFileException"));
            classMap.put(new Integer(30005), getSWIGCtor("MgDuplicateGroupException"));
            classMap.put(new Integer(30006), getSWIGCtor("MgDuplicateNameException"));
            classMap.put(new Integer(1513), getSWIGCtor("MgDuplicateObjectException"));
            classMap.put(new Integer(30007), getSWIGCtor("MgDuplicateParameterException"));
            classMap.put(new Integer(30008), getSWIGCtor("MgDuplicateRepositoryException"));
            classMap.put(new Integer(10501), getSWIGCtor("MgDuplicateResourceDataException"));
            classMap.put(new Integer(10502), getSWIGCtor("MgDuplicateResourceException"));
            classMap.put(new Integer(30009), getSWIGCtor("MgDuplicateRoleException"));
            classMap.put(new Integer(30010), getSWIGCtor("MgDuplicateServerException"));
            classMap.put(new Integer(30011), getSWIGCtor("MgDuplicateSessionException"));
            classMap.put(new Integer(30012), getSWIGCtor("MgDuplicateUserException"));
            classMap.put(new Integer(30013), getSWIGCtor("MgDwfException"));
            classMap.put(new Integer(30014), getSWIGCtor("MgDwfSectionNotFoundException"));
            classMap.put(new Integer(30015), getSWIGCtor("MgDwfSectionResourceNotFoundException"));
            classMap.put(new Integer(30901), getSWIGCtor("MgDwfVersion"));
            classMap.put(new Integer(10503), getSWIGCtor("MgEmptyFeatureSetException"));
            classMap.put(new Integer(1514), getSWIGCtor("MgEncryptionException"));
            classMap.put(new Integer(30016), getSWIGCtor("MgEndOfStreamException"));
            classMap.put(new Integer(20001), getSWIGCtor("MgEnvelope"));
            classMap.put(new Integer(1515), getSWIGCtor("MgException"));
            classMap.put(new Integer(10504), getSWIGCtor("MgFdoException"));
            classMap.put(new Integer(11772), getSWIGCtor("MgFeatureAggregateOptions"));
            classMap.put(new Integer(11774), getSWIGCtor("MgFeatureCommandCollection"));
            classMap.put(new Integer(31001), getSWIGCtor("MgFeatureInformation"));
            classMap.put(new Integer(11764), getSWIGCtor("MgFeatureProperty"));
            classMap.put(new Integer(11771), getSWIGCtor("MgFeatureQueryOptions"));
            classMap.put(new Integer(11753), getSWIGCtor("MgFeatureReader"));
            classMap.put(new Integer(11778), getSWIGCtor("MgFeatureSchema"));
            classMap.put(new Integer(11779), getSWIGCtor("MgFeatureSchemaCollection"));
            classMap.put(new Integer(11754), getSWIGCtor("MgFeatureService"));
            classMap.put(new Integer(10505), getSWIGCtor("MgFeatureServiceException"));
            classMap.put(new Integer(11786), getSWIGCtor("MgFileFeatureSourceParams"));
            classMap.put(new Integer(1516), getSWIGCtor("MgFileIoException"));
            classMap.put(new Integer(1517), getSWIGCtor("MgFileNotFoundException"));
            classMap.put(new Integer(20016), getSWIGCtor("MgGeometricEntity"));
            classMap.put(new Integer(11756), getSWIGCtor("MgGeometricPropertyDefinition"));
            classMap.put(new Integer(20019), getSWIGCtor("MgGeometry"));
            classMap.put(new Integer(20020), getSWIGCtor("MgGeometryCollection"));
            classMap.put(new Integer(20021), getSWIGCtor("MgGeometryComponent"));
            classMap.put(new Integer(21006), getSWIGCtor("MgGeometryException"));
            classMap.put(new Integer(20002), getSWIGCtor("MgGeometryFactory"));
            classMap.put(new Integer(11758), getSWIGCtor("MgGeometryProperty"));
            classMap.put(new Integer(11785), getSWIGCtor("MgGeometryTypeInfo"));
            classMap.put(new Integer(30018), getSWIGCtor("MgGroupNotFoundException"));
            classMap.put(new Integer(11782), getSWIGCtor("MgGwsFeatureReader"));
            classMap.put(new Integer(40000), getSWIGCtor("MgHttpHeader"));
            classMap.put(new Integer(40006), getSWIGCtor("MgHttpPrimitiveValue"));
            classMap.put(new Integer(40004), getSWIGCtor("MgHttpRequest"));
            classMap.put(new Integer(40002), getSWIGCtor("MgHttpRequestMetadata"));
            classMap.put(new Integer(40001), getSWIGCtor("MgHttpRequestParam"));
            classMap.put(new Integer(40005), getSWIGCtor("MgHttpResponse"));
            classMap.put(new Integer(40003), getSWIGCtor("MgHttpResult"));
            classMap.put(new Integer(1518), getSWIGCtor("MgIndexOutOfRangeException"));
            classMap.put(new Integer(11776), getSWIGCtor("MgInsertFeatures"));
            classMap.put(new Integer(10258), getSWIGCtor("MgInt16Property"));
            classMap.put(new Integer(10259), getSWIGCtor("MgInt32Property"));
            classMap.put(new Integer(10260), getSWIGCtor("MgInt64Property"));
            classMap.put(new Integer(10000), getSWIGCtor("MgIntCollection"));
            classMap.put(new Integer(1519), getSWIGCtor("MgInvalidArgumentException"));
            classMap.put(new Integer(1520), getSWIGCtor("MgInvalidCastException"));
            classMap.put(new Integer(21007), getSWIGCtor("MgInvalidCoordinateSystemException"));
            classMap.put(new Integer(21008), getSWIGCtor("MgInvalidCoordinateSystemTypeException"));
            classMap.put(new Integer(21009), getSWIGCtor("MgInvalidCoordinateSystemUnitsException"));
            classMap.put(new Integer(30019), getSWIGCtor("MgInvalidDwfPackageException"));
            classMap.put(new Integer(30020), getSWIGCtor("MgInvalidDwfSectionException"));
            classMap.put(new Integer(30021), getSWIGCtor("MgInvalidFeatureSourceException"));
            classMap.put(new Integer(30022), getSWIGCtor("MgInvalidIpAddressException"));
            classMap.put(new Integer(30023), getSWIGCtor("MgInvalidLicenseException"));
            classMap.put(new Integer(30024), getSWIGCtor("MgInvalidLogEntryException"));
            classMap.put(new Integer(10507), getSWIGCtor("MgInvalidMapDefinitionException"));
            classMap.put(new Integer(1522), getSWIGCtor("MgInvalidOperationException"));
            classMap.put(new Integer(30026), getSWIGCtor("MgInvalidPasswordException"));
            classMap.put(new Integer(30027), getSWIGCtor("MgInvalidPrintLayoutFontSizeUnitsException"));
            classMap.put(new Integer(30028), getSWIGCtor("MgInvalidPrintLayoutPositionUnitsException"));
            classMap.put(new Integer(30029), getSWIGCtor("MgInvalidPrintLayoutSizeUnitsException"));
            classMap.put(new Integer(1523), getSWIGCtor("MgInvalidPropertyTypeException"));
            classMap.put(new Integer(10508), getSWIGCtor("MgInvalidRepositoryNameException"));
            classMap.put(new Integer(10509), getSWIGCtor("MgInvalidRepositoryTypeException"));
            classMap.put(new Integer(10510), getSWIGCtor("MgInvalidResourceDataNameException"));
            classMap.put(new Integer(10511), getSWIGCtor("MgInvalidResourceDataTypeException"));
            classMap.put(new Integer(10512), getSWIGCtor("MgInvalidResourceNameException"));
            classMap.put(new Integer(10513), getSWIGCtor("MgInvalidResourcePathException"));
            classMap.put(new Integer(10514), getSWIGCtor("MgInvalidResourcePreProcessingTypeException"));
            classMap.put(new Integer(10515), getSWIGCtor("MgInvalidResourceTypeException"));
            classMap.put(new Integer(30031), getSWIGCtor("MgInvalidServerNameException"));
            classMap.put(new Integer(1524), getSWIGCtor("MgInvalidStreamHeaderException"));
            classMap.put(new Integer(1525), getSWIGCtor("MgIoException"));
            classMap.put(new Integer(31300), getSWIGCtor("MgKmlService"));
            classMap.put(new Integer(30501), getSWIGCtor("MgLayer"));
            classMap.put(new Integer(12003), getSWIGCtor("MgLayerBase"));
            classMap.put(new Integer(12002), getSWIGCtor("MgLayerCollection"));
            classMap.put(new Integer(12001), getSWIGCtor("MgLayerGroup"));
            classMap.put(new Integer(12004), getSWIGCtor("MgLayerGroupCollection"));
            classMap.put(new Integer(10517), getSWIGCtor("MgLayerNotFoundException"));
            classMap.put(new Integer(30904), getSWIGCtor("MgLayout"));
            classMap.put(new Integer(1526), getSWIGCtor("MgLengthException"));
            classMap.put(new Integer(30032), getSWIGCtor("MgLicenseException"));
            classMap.put(new Integer(30033), getSWIGCtor("MgLicenseExpiredException"));
            classMap.put(new Integer(20023), getSWIGCtor("MgLinearRing"));
            classMap.put(new Integer(20053), getSWIGCtor("MgLinearRingCollection"));
            classMap.put(new Integer(20024), getSWIGCtor("MgLinearSegment"));
            classMap.put(new Integer(20042), getSWIGCtor("MgLineString"));
            classMap.put(new Integer(20044), getSWIGCtor("MgLineStringCollection"));
            classMap.put(new Integer(1527), getSWIGCtor("MgLogicException"));
            classMap.put(new Integer(11766), getSWIGCtor("MgLongTransactionReader"));
            classMap.put(new Integer(30500), getSWIGCtor("MgMap"));
            classMap.put(new Integer(12000), getSWIGCtor("MgMapBase"));
            classMap.put(new Integer(12005), getSWIGCtor("MgMapCollection"));
            classMap.put(new Integer(30900), getSWIGCtor("MgMappingService"));
            classMap.put(new Integer(30905), getSWIGCtor("MgMapPlot"));
            classMap.put(new Integer(30906), getSWIGCtor("MgMapPlotCollection"));
            classMap.put(new Integer(20029), getSWIGCtor("MgMultiCurvePolygon"));
            classMap.put(new Integer(20030), getSWIGCtor("MgMultiCurveString"));
            classMap.put(new Integer(20031), getSWIGCtor("MgMultiGeometry"));
            classMap.put(new Integer(20032), getSWIGCtor("MgMultiLineString"));
            classMap.put(new Integer(20033), getSWIGCtor("MgMultiPoint"));
            classMap.put(new Integer(20034), getSWIGCtor("MgMultiPolygon"));
            classMap.put(new Integer(1528), getSWIGCtor("MgNotFiniteNumberException"));
            classMap.put(new Integer(1529), getSWIGCtor("MgNotImplementedException"));
            classMap.put(new Integer(1530), getSWIGCtor("MgNullArgumentException"));
            classMap.put(new Integer(1531), getSWIGCtor("MgNullPropertyValueException"));
            classMap.put(new Integer(1532), getSWIGCtor("MgNullReferenceException"));
            classMap.put(new Integer(1533), getSWIGCtor("MgObjectNotFoundException"));
            classMap.put(new Integer(11759), getSWIGCtor("MgObjectPropertyDefinition"));
            classMap.put(new Integer(30035), getSWIGCtor("MgOperationProcessingException"));
            classMap.put(new Integer(1534), getSWIGCtor("MgOutOfMemoryException"));
            classMap.put(new Integer(1535), getSWIGCtor("MgOutOfRangeException"));
            classMap.put(new Integer(1536), getSWIGCtor("MgOverflowException"));
            classMap.put(new Integer(30604), getSWIGCtor("MgPackageStatusInformation"));
            classMap.put(new Integer(11788), getSWIGCtor("MgParameter"));
            classMap.put(new Integer(10004), getSWIGCtor("MgParameterCollection"));
            classMap.put(new Integer(30036), getSWIGCtor("MgParameterNotFoundException"));
            classMap.put(new Integer(30037), getSWIGCtor("MgPathTooLongException"));
            classMap.put(new Integer(1537), getSWIGCtor("MgPlatformNotSupportedException"));
            classMap.put(new Integer(30902), getSWIGCtor("MgPlotSpecification"));
            classMap.put(new Integer(20000), getSWIGCtor("MgPoint"));
            classMap.put(new Integer(20045), getSWIGCtor("MgPointCollection"));
            classMap.put(new Integer(20035), getSWIGCtor("MgPolygon"));
            classMap.put(new Integer(20046), getSWIGCtor("MgPolygonCollection"));
            classMap.put(new Integer(30039), getSWIGCtor("MgPortNotAvailableException"));
            classMap.put(new Integer(30040), getSWIGCtor("MgPrintToScaleModeNotSelectedException"));
            classMap.put(new Integer(31400), getSWIGCtor("MgProfilingService"));
            classMap.put(new Integer(2000), getSWIGCtor("MgProperty"));
            classMap.put(new Integer(1002), getSWIGCtor("MgPropertyCollection"));
            classMap.put(new Integer(2002), getSWIGCtor("MgPropertyDefinition"));
            classMap.put(new Integer(10001), getSWIGCtor("MgPropertyDefinitionCollection"));
            classMap.put(new Integer(11769), getSWIGCtor("MgRaster"));
            classMap.put(new Integer(11770), getSWIGCtor("MgRasterProperty"));
            classMap.put(new Integer(11768), getSWIGCtor("MgRasterPropertyDefinition"));
            classMap.put(new Integer(12006), getSWIGCtor("MgReadOnlyLayerCollection"));
            classMap.put(new Integer(20037), getSWIGCtor("MgRegion"));
            classMap.put(new Integer(31002), getSWIGCtor("MgRenderingOptions"));
            classMap.put(new Integer(31000), getSWIGCtor("MgRenderingService"));
            classMap.put(new Integer(30041), getSWIGCtor("MgRepositoryCreationFailedException"));
            classMap.put(new Integer(30042), getSWIGCtor("MgRepositoryNotFoundException"));
            classMap.put(new Integer(30043), getSWIGCtor("MgRepositoryNotOpenException"));
            classMap.put(new Integer(30044), getSWIGCtor("MgRepositoryOpenFailedException"));
            classMap.put(new Integer(11526), getSWIGCtor("MgResource"));
            classMap.put(new Integer(10518), getSWIGCtor("MgResourceBusyException"));
            classMap.put(new Integer(10519), getSWIGCtor("MgResourceDataNotFoundException"));
            classMap.put(new Integer(11500), getSWIGCtor("MgResourceIdentifier"));
            classMap.put(new Integer(10520), getSWIGCtor("MgResourceNotFoundException"));
            classMap.put(new Integer(11501), getSWIGCtor("MgResourceService"));
            classMap.put(new Integer(1538), getSWIGCtor("MgResourcesException"));
            classMap.put(new Integer(1539), getSWIGCtor("MgResourcesLoadFailedException"));
            classMap.put(new Integer(1540), getSWIGCtor("MgResourceTagNotFoundException"));
            classMap.put(new Integer(20038), getSWIGCtor("MgRing"));
            classMap.put(new Integer(30045), getSWIGCtor("MgRoleNotFoundException"));
            classMap.put(new Integer(1541), getSWIGCtor("MgRuntimeException"));
            classMap.put(new Integer(30502), getSWIGCtor("MgSelection"));
            classMap.put(new Integer(12007), getSWIGCtor("MgSelectionBase"));
            classMap.put(new Integer(30607), getSWIGCtor("MgServerAdmin"));
            classMap.put(new Integer(30046), getSWIGCtor("MgServerNotFoundException"));
            classMap.put(new Integer(30047), getSWIGCtor("MgServerNotOnlineException"));
            classMap.put(new Integer(11251), getSWIGCtor("MgService"));
            classMap.put(new Integer(10521), getSWIGCtor("MgServiceNotAvailableException"));
            classMap.put(new Integer(10522), getSWIGCtor("MgServiceNotSupportedException"));
            classMap.put(new Integer(30048), getSWIGCtor("MgSessionExpiredException"));
            classMap.put(new Integer(30052), getSWIGCtor("MgSessionNotFoundException"));
            classMap.put(new Integer(10261), getSWIGCtor("MgSingleProperty"));
            classMap.put(new Integer(30605), getSWIGCtor("MgSite"));
            classMap.put(new Integer(30601), getSWIGCtor("MgSiteConnection"));
            classMap.put(new Integer(30608), getSWIGCtor("MgSiteInfo"));
            classMap.put(new Integer(11761), getSWIGCtor("MgSpatialContextReader"));
            classMap.put(new Integer(11762), getSWIGCtor("MgSqlDataReader"));
            classMap.put(new Integer(1542), getSWIGCtor("MgStreamIoException"));
            classMap.put(new Integer(1003), getSWIGCtor("MgStringCollection"));
            classMap.put(new Integer(2001), getSWIGCtor("MgStringProperty"));
            classMap.put(new Integer(10003), getSWIGCtor("MgStringPropertyCollection"));
            classMap.put(new Integer(1543), getSWIGCtor("MgSystemException"));
            classMap.put(new Integer(1544), getSWIGCtor("MgTemporaryFileNotAvailableException"));
            classMap.put(new Integer(1545), getSWIGCtor("MgThirdPartyException"));
            classMap.put(new Integer(31200), getSWIGCtor("MgTileService"));
            classMap.put(new Integer(11787), getSWIGCtor("MgTransaction"));
            classMap.put(new Integer(30049), getSWIGCtor("MgUnauthorizedAccessException"));
            classMap.put(new Integer(1547), getSWIGCtor("MgUnclassifiedException"));
            classMap.put(new Integer(1548), getSWIGCtor("MgUnderflowException"));
            classMap.put(new Integer(30056), getSWIGCtor("MgUnknownTileProviderException"));
            classMap.put(new Integer(30057), getSWIGCtor("MgUnsupportedTileProviderException"));
            classMap.put(new Integer(11777), getSWIGCtor("MgUpdateFeatures"));
            classMap.put(new Integer(30050), getSWIGCtor("MgUriFormatException"));
            classMap.put(new Integer(30606), getSWIGCtor("MgUserInformation"));
            classMap.put(new Integer(10523), getSWIGCtor("MgUserNotFoundException"));
            classMap.put(new Integer(11257), getSWIGCtor("MgWarnings"));
            classMap.put(new Integer(50005), getSWIGCtor("MgWebBufferCommand"));
            classMap.put(new Integer(50000), getSWIGCtor("MgWebCommand"));
            classMap.put(new Integer(50012), getSWIGCtor("MgWebCommandCollection"));
            classMap.put(new Integer(50015), getSWIGCtor("MgWebCommandWidget"));
            classMap.put(new Integer(50025), getSWIGCtor("MgWebContextMenu"));
            classMap.put(new Integer(50016), getSWIGCtor("MgWebFlyoutWidget"));
            classMap.put(new Integer(50009), getSWIGCtor("MgWebGetPrintablePageCommand"));
            classMap.put(new Integer(50011), getSWIGCtor("MgWebHelpCommand"));
            classMap.put(new Integer(50022), getSWIGCtor("MgWebInformationPane"));
            classMap.put(new Integer(50003), getSWIGCtor("MgWebInvokeScriptCommand"));
            classMap.put(new Integer(50004), getSWIGCtor("MgWebInvokeUrlCommand"));
            classMap.put(new Integer(50026), getSWIGCtor("MgWebLayout"));
            classMap.put(new Integer(50008), getSWIGCtor("MgWebMeasureCommand"));
            classMap.put(new Integer(50007), getSWIGCtor("MgWebPrintCommand"));
            classMap.put(new Integer(50002), getSWIGCtor("MgWebSearchCommand"));
            classMap.put(new Integer(50006), getSWIGCtor("MgWebSelectWithinCommand"));
            classMap.put(new Integer(50014), getSWIGCtor("MgWebSeparatorWidget"));
            classMap.put(new Integer(50023), getSWIGCtor("MgWebTaskBar"));
            classMap.put(new Integer(50017), getSWIGCtor("MgWebTaskBarWidget"));
            classMap.put(new Integer(50024), getSWIGCtor("MgWebTaskPane"));
            classMap.put(new Integer(50021), getSWIGCtor("MgWebToolBar"));
            classMap.put(new Integer(50019), getSWIGCtor("MgWebUiPane"));
            classMap.put(new Integer(50020), getSWIGCtor("MgWebUiSizablePane"));
            classMap.put(new Integer(50001), getSWIGCtor("MgWebUiTargetCommand"));
            classMap.put(new Integer(50010), getSWIGCtor("MgWebViewOptionsCommand"));
            classMap.put(new Integer(50013), getSWIGCtor("MgWebWidget"));
            classMap.put(new Integer(50018), getSWIGCtor("MgWebWidgetCollection"));
            classMap.put(new Integer(20040), getSWIGCtor("MgWktReaderWriter"));
            classMap.put(new Integer(1549), getSWIGCtor("MgXmlException"));
            classMap.put(new Integer(1550), getSWIGCtor("MgXmlParserException"));

        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
    }

    private static Constructor getSWIGCtor(String className) throws ClassNotFoundException, Exception
    {
        Constructor swigCtor = null;
        Constructor[] cons = Class.forName("org.osgeo.mapguide." + className).getDeclaredConstructors();
        for (int i = 0; i < cons.length; i++)
        {
            Class[] parameterTypes = cons[i].getParameterTypes();
            if (parameterTypes.length == 2 && parameterTypes[0].equals(Long.TYPE) && parameterTypes[1].equals(Boolean.TYPE))
            {
                swigCtor = cons[i];
                swigCtor.setAccessible(true); //This ctor will be protected, so we need to make it accessible
            }
        }
        if (swigCtor == null)
        {
            throw new Exception("Could not find the expected internal SWIG constructor for class: " + className);
        }
        return swigCtor;
    }
}
