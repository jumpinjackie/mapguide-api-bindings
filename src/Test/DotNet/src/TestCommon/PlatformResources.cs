﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace OSGeo.MapGuide.Test.Common
{
    public static class PlatformResources
    {
        public const string TestLayer = @"<?xml version=""1.0"" encoding=""utf-8""?>
<LayerDefinition xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema"" version=""1.0.0"" xsi:noNamespaceSchemaLocation=""LayerDefinition-1.0.0.xsd"">
  <VectorLayerDefinition>
    <ResourceId>{0}</ResourceId>
    <FeatureName>{1}</FeatureName>
    <FeatureNameType>FeatureClass</FeatureNameType>
    <Geometry>{2}</Geometry>
    <VectorScaleRange>
      <PointTypeStyle>
        <DisplayAsText>false</DisplayAsText>
        <AllowOverpost>false</AllowOverpost>
        <PointRule>
          <LegendLabel />
          <PointSymbolization2D>
            <Mark>
              <Unit>Points</Unit>
              <SizeContext>DeviceUnits</SizeContext>
              <SizeX>10</SizeX>
              <SizeY>10</SizeY>
              <Rotation>0</Rotation>
              <Shape>Square</Shape>
              <Fill>
                <FillPattern>Solid</FillPattern>
                <ForegroundColor>ffffffff</ForegroundColor>
                <BackgroundColor>ffffffff</BackgroundColor>
              </Fill>
              <Edge>
                <LineStyle>Solid</LineStyle>
                <Thickness>1</Thickness>
                <Color>ff000000</Color>
                <Unit>Points</Unit>
              </Edge>
            </Mark>
          </PointSymbolization2D>
        </PointRule>
      </PointTypeStyle>
      <LineTypeStyle>
        <LineRule>
          <LegendLabel />
          <LineSymbolization2D>
            <LineStyle>Solid</LineStyle>
            <Thickness>1</Thickness>
            <Color>ff000000</Color>
            <Unit>Points</Unit>
          </LineSymbolization2D>
        </LineRule>
      </LineTypeStyle>
      <AreaTypeStyle>
        <AreaRule>
          <LegendLabel />
          <AreaSymbolization2D>
            <Fill>
              <FillPattern>Solid</FillPattern>
              <ForegroundColor>ffffffff</ForegroundColor>
              <BackgroundColor>ffffffff</BackgroundColor>
            </Fill>
            <Stroke>
              <LineStyle>Solid</LineStyle>
              <Thickness>1</Thickness>
              <Color>ff000000</Color>
              <Unit>Points</Unit>
            </Stroke>
          </AreaSymbolization2D>
        </AreaRule>
      </AreaTypeStyle>
    </VectorScaleRange>
  </VectorLayerDefinition>
</LayerDefinition>";

        public const string TestMapDef = @"<?xml version=""1.0"" encoding=""utf-8""?>
<MapDefinition xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema"" version=""2.4.0"" xsi:noNamespaceSchemaLocation=""MapDefinition-2.4.0.xsd"">
  <Name>Test Map</Name>
  <CoordinateSystem>{0}</CoordinateSystem>
  <Extents>
    <MinX>{1}</MinX>
    <MaxX>{2}</MaxX>
    <MinY>{3}</MinY>
    <MaxY>{4}</MaxY>
  </Extents>
  <BackgroundColor>ffffffff</BackgroundColor>
</MapDefinition>";
    }
}