﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace OSGeo.MapGuide.Test
{
    public static class MapGuideResources
    {
        public const string ResourceHeaderTemplate = @"<?xml version=""1.0""?>
<ResourceDocumentHeader xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema"" xsi:noNamespaceSchemaLocation=""ResourceDocumentHeader-1.0.0.xsd"">
  <Security>
    <Inherited>true</Inherited>
  </Security>
  <Metadata>
    <Simple>
      <Property>
        <Name>{0}</Name>
        <Value>{1}</Value>
      </Property>
    </Simple>
  </Metadata>
</ResourceDocumentHeader>";

        public const string UT_BaseMap = @"<?xml version=""1.0"" encoding=""UTF-8""?>
<MapDefinition xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xsi:noNamespaceSchemaLocation=""MapDefinition-3.0.0.xsd"" version=""3.0.0"">
  <Name>Base Map</Name>
  <CoordinateSystem>GEOGCS[&quot; LL84&quot;,DATUM[&quot;WGS 84&quot;,SPHEROID[&quot;WGS 84&quot;,6378137,298.25722293287],TOWGS84[0, 0, 0, 0, 0, 0, 0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;Degrees&quot;,0.01745329252]]</CoordinateSystem>
  <Extents>
    <MinX>-87.79786601383196</MinX>
    <MaxX>-87.66452777186925</MaxX>
    <MinY>43.6868578621819</MinY>
    <MaxY>43.8037962206133</MaxY>
  </Extents>
  <BackgroundColor>FFF7E1D2</BackgroundColor>
  <TileSetSource>
    <ResourceId>{0}</ResourceId>
  </TileSetSource>
</MapDefinition>";

        public const string UT_BaseMap_TSD = @"<?xml version=""1.0"" encoding=""UTF-8""?>
<TileSetDefinition xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xsi:noNamespaceSchemaLocation=""TileSetDefinition-3.0.0.xsd"">
  <TileStoreParameters>
    <TileProvider>Default</TileProvider>
    <Parameter>
      <Name>TilePath</Name>
      <Value>%MG_TILE_CACHE_PATH%</Value>
    </Parameter>
    <Parameter>
      <Name>TileWidth</Name>
      <Value>256</Value>
    </Parameter>
    <Parameter>
      <Name>TileHeight</Name>
      <Value>256</Value>
    </Parameter>
    <Parameter>
      <Name>TileFormat</Name>
      <Value>PNG</Value>
    </Parameter>
    <Parameter>
      <Name>FiniteScaleList</Name>
      <Value>200000,100000,50000,25000,12500,6250,3125,1562.5,781.25,390.625</Value>
    </Parameter>
    <Parameter>
      <Name>CoordinateSystem</Name>
      <Value>{0}</Value>
    </Parameter>
  </TileStoreParameters>
  <Extents>
    <MinX>{1}</MinX>
    <MaxX>{3}</MaxX>
    <MinY>{2}</MinY>
    <MaxY>{4}</MaxY>
  </Extents>
  <BaseMapLayerGroup>
    <Name>BaseLayers</Name>
    <Visible>true</Visible>
    <ShowInLegend>true</ShowInLegend>
    <ExpandInLegend>true</ExpandInLegend>
    <LegendLabel>Base Layers</LegendLabel>
    <BaseMapLayer>
      <Name>Parcels</Name>
      <ResourceId>Library://UnitTests/Layers/Parcels.LayerDefinition</ResourceId>
      <Selectable>true</Selectable>
      <ShowInLegend>true</ShowInLegend>
      <LegendLabel>Parcels</LegendLabel>
      <ExpandInLegend>false</ExpandInLegend>
    </BaseMapLayer>
    <BaseMapLayer>
      <Name>VotingDistricts</Name>
      <ResourceId>Library://UnitTests/Layers/VotingDistricts.LayerDefinition</ResourceId>
      <Selectable>true</Selectable>
      <ShowInLegend>true</ShowInLegend>
      <LegendLabel>Voting Districts</LegendLabel>
      <ExpandInLegend>false</ExpandInLegend>
    </BaseMapLayer>
  </BaseMapLayerGroup>
</TileSetDefinition>";

        public const string UT_LinkedTileSet = @"<?xml version=""1.0"" encoding=""UTF-8""?>
<MapDefinition xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xsi:noNamespaceSchemaLocation=""MapDefinition-3.0.0.xsd"" version=""3.0.0"">
  <Name>Base Map linked to Tile Set</Name>
  <CoordinateSystem>{0}</CoordinateSystem>
  <Extents>
    <MinX>{1}</MinX>
    <MaxX>{3}</MaxX>
    <MinY>{2}</MinY>
    <MaxY>{4}</MaxY>
  </Extents>
  <BackgroundColor>FFF7E1D2</BackgroundColor>
  <TileSetSource>
    <ResourceId>{5}</ResourceId>
  </TileSetSource>
</MapDefinition>";

        public const string UT_XYZ = @"<?xml version=""1.0"" encoding=""UTF-8""?>
<TileSetDefinition xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xsi:noNamespaceSchemaLocation=""TileSetDefinition-3.0.0.xsd"">
  <TileStoreParameters>
    <TileProvider>XYZ</TileProvider>
    <Parameter>
      <Name>TilePath</Name>
      <Value>%MG_TILE_CACHE_PATH%</Value>
    </Parameter>
    <Parameter>
      <Name>TileFormat</Name>
      <Value>PNG</Value>
    </Parameter>
  </TileStoreParameters>
  <Extents>
    <MinX>-87.79786601383196</MinX>
    <MaxX>-87.66452777186925</MaxX>
    <MinY>43.6868578621819</MinY>
    <MaxY>43.8037962206133</MaxY>
  </Extents>
  <BaseMapLayerGroup>
    <Name>BaseLayers</Name>
    <Visible>true</Visible>
    <ShowInLegend>true</ShowInLegend>
    <ExpandInLegend>true</ExpandInLegend>
    <LegendLabel>Base Layers</LegendLabel>
    <BaseMapLayer>
      <Name>Parcels</Name>
      <ResourceId>Library://UnitTests/Layers/Parcels.LayerDefinition</ResourceId>
      <Selectable>true</Selectable>
      <ShowInLegend>true</ShowInLegend>
      <LegendLabel>Parcels</LegendLabel>
      <ExpandInLegend>false</ExpandInLegend>
    </BaseMapLayer>
    <BaseMapLayer>
      <Name>VotingDistricts</Name>
      <ResourceId>Library://UnitTests/Layers/VotingDistricts.LayerDefinition</ResourceId>
      <Selectable>true</Selectable>
      <ShowInLegend>true</ShowInLegend>
      <LegendLabel>Voting Districts</LegendLabel>
      <ExpandInLegend>false</ExpandInLegend>
    </BaseMapLayer>
  </BaseMapLayerGroup>
</TileSetDefinition>";
    }
}