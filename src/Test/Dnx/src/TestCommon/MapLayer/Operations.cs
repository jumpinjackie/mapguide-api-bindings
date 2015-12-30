using OSGeo.MapGuide.Test.Common;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;

namespace OSGeo.MapGuide.Test.Operations
{
    public class GetMapExtent : MapLayerOperationExecutor<GetMapExtent>
    {
        public GetMapExtent(MgResourceService resSvc, string vm, IMapCreator creator)
            : base(resSvc, vm, creator)
        {
        }

        protected override string[] ParameterNames => new string[] { "MAPDEFINITION" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                this.CreateMapFromResource(param);
                var extent = _map.GetMapExtent();
                return new TestResult(CommonUtility.MgEnvelopeToString(extent), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex);
            }
        }
    }

    public class GetCoordinateSystem : MapLayerOperationExecutor<GetCoordinateSystem>
    {
        public GetCoordinateSystem(MgResourceService resSvc, string vm, IMapCreator creator)
            : base(resSvc, vm, creator)
        {
        }

        protected override string[] ParameterNames => new string[] { "MAPDEFINITION" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                this.CreateMapFromResource(param);
                return new TestResult(_map.GetMapSRS(), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex);
            }
        }
    }

    public class GetMapName : MapLayerOperationExecutor<GetMapName>
    {
        public GetMapName(MgResourceService resSvc, string vm, IMapCreator creator)
            : base(resSvc, vm, creator)
        {
        }

        protected override string[] ParameterNames => new string[] { "MAPDEFINITION" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                this.CreateMapFromResource(param);
                return new TestResult(_map.GetName(), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex);
            }
        }
    }

    public class GetLayers : MapLayerOperationExecutor<GetLayers>
    {
        public GetLayers(MgResourceService resSvc, string vm, IMapCreator creator)
            : base(resSvc, vm, creator)
        {
        }

        protected override string[] ParameterNames => new string[] { "MAPDEFINITION" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                this.CreateMapFromResource(param);
                var layers = _map.GetLayers();
                var names = new List<string>();
                for (int i = 0; i < layers.GetCount(); i++)
                {
                    var layer = layers.GetItem(i);
                    names.Add(layer.GetName());
                }

                return new TestResult(string.Join("/", names.ToArray()), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex);
            }
        }
    }

    public class GetGroups : MapLayerOperationExecutor<GetGroups>
    {
        public GetGroups(MgResourceService resSvc, string vm, IMapCreator creator)
            : base(resSvc, vm, creator)
        {
        }

        protected override string[] ParameterNames => new string[] { "MAPDEFINITION" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                this.CreateMapFromResource(param);
                var groups = _map.GetLayerGroups();
                var names = new List<string>();
                for (int i = 0; i < groups.GetCount(); i++)
                {
                    var group = groups.GetItem(i);
                    names.Add(group.GetName());
                }

                return new TestResult(string.Join("/", names.ToArray()), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex);
            }
        }
    }

    public class GetLayerVisibility : MapLayerOperationExecutor<GetLayerVisibility>
    {
        public GetLayerVisibility(MgResourceService resSvc, string vm, IMapCreator creator)
            : base(resSvc, vm, creator)
        {
        }

        protected override string[] ParameterNames => new string[] { "MAPDEFINITION", "LAYERNAME" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                this.CreateMapFromResource(param);
                string layerName = param["LAYERNAME"];

                var layer = this.FindLayer(layerName);
                if (layer == null)
                    return new TestResult("***Unknown Layer***", "text/plain");
                return new TestResult(CommonUtility.BooleanToString(layer.GetVisible()), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex);
            }
        }
    }

    public class GetDisplayInLegend : MapLayerOperationExecutor<GetDisplayInLegend>
    {
        public GetDisplayInLegend(MgResourceService resSvc, string vm, IMapCreator creator)
            : base(resSvc, vm, creator)
        {
        }

        protected override string[] ParameterNames => new string[] { "MAPDEFINITION", "LAYERNAME" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                this.CreateMapFromResource(param);
                string layerName = param["LAYERNAME"];

                var layer = this.FindLayer(layerName);
                if (layer == null)
                    return new TestResult("***Unknown Layer***", "text/plain");
                return new TestResult(CommonUtility.BooleanToString(layer.GetDisplayInLegend()), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex);
            }
        }
    }

    public class GetLegendLabel : MapLayerOperationExecutor<GetLegendLabel>
    {
        public GetLegendLabel(MgResourceService resSvc, string vm, IMapCreator creator)
            : base(resSvc, vm, creator)
        {
        }

        protected override string[] ParameterNames => new string[] { "MAPDEFINITION", "LAYERNAME" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                this.CreateMapFromResource(param);
                string layerName = param["LAYERNAME"];

                var layer = this.FindLayer(layerName);
                if (layer == null)
                    return new TestResult("***Unknown Layer***", "text/plain");
                return new TestResult(layer.GetLegendLabel(), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex);
            }
        }
    }

    public class GetLayerDefinition : MapLayerOperationExecutor<GetLayerDefinition>
    {
        public GetLayerDefinition(MgResourceService resSvc, string vm, IMapCreator creator)
            : base(resSvc, vm, creator)
        {
        }

        protected override string[] ParameterNames => new string[] { "MAPDEFINITION", "LAYERNAME" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                this.CreateMapFromResource(param);
                string layerName = param["LAYERNAME"];

                var layer = this.FindLayer(layerName);
                if (layer == null)
                    return new TestResult("***Unknown Layer***", "text/plain");
                var ldfId = layer.GetLayerDefinition();
                return new TestResult(ldfId.ToString(), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex);
            }
        }
    }

    public class IsLayerVisible : MapLayerOperationExecutor<IsLayerVisible>
    {
        public IsLayerVisible(MgResourceService resSvc, string vm, IMapCreator creator)
            : base(resSvc, vm, creator)
        {
        }

        protected override string[] ParameterNames => new string[] { "MAPDEFINITION", "LAYERNAME" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                this.CreateMapFromResource(param);
                string layerName = param["LAYERNAME"];

                var layer = this.FindLayer(layerName);
                if (layer == null)
                    return new TestResult("***Unknown Layer***", "text/plain");
                return new TestResult(CommonUtility.BooleanToString(layer.IsVisible()), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex);
            }
        }
    }

    public class AddLayerGroup : MapLayerOperationExecutor<AddLayerGroup>
    {
        public AddLayerGroup(MgResourceService resSvc, string vm, IMapCreator creator)
            : base(resSvc, vm, creator)
        {
        }

        protected override string[] ParameterNames => new string[] { "MAPDEFINITION", "GROUPNAME", "PARENTGROUPNAME" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                this.CreateMapFromResource(param);
                
                string groupName = param["GROUPNAME"];
                string parentGroupName = param["PARENTGROUPNAME"];

                var groups = _map.GetLayerGroups();
                var group = new MgLayerGroup(groupName);
                if (!string.IsNullOrEmpty(parentGroupName))
                {
                    var parentGroup = groups.GetItem(parentGroupName);
                    group.SetGroup(parentGroup);
                }
                groups.Add(group);

                return new TestResult(groups.GetCount().ToString(), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex);
            }
        }
    }

    public class AddLayer : MapLayerOperationExecutor<AddLayer>
    {
        public AddLayer(MgResourceService resSvc, string vm, IMapCreator creator)
            : base(resSvc, vm, creator)
        {
        }

        protected override string[] ParameterNames => new string[] { "MAPDEFINITION", "LAYERDEFINITION", "GROUPNAME" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                this.CreateMapFromResource(param);
                string layerDefinition = param["LAYERDEFINITION"];
                string groupName = param["GROUPNAME"];

                var ldfId = new MgResourceIdentifier(layerDefinition);
                var layer = _creator.CreateLayer(ldfId);

                if (!string.IsNullOrEmpty(groupName))
                {
                    var groups = _map.GetLayerGroups();
                    var gidx = groups.IndexOf(groupName);
                    if (gidx >= 0)
                        layer.SetGroup(groups.GetItem(gidx));
                }

                var layers = _map.GetLayers();
                layers.Add(layer);

                return new TestResult(layers.GetCount().ToString(), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex);
            }
        }
    }

    public class HideGroup : MapLayerOperationExecutor<HideGroup>
    {
        public HideGroup(MgResourceService resSvc, string vm, IMapCreator creator)
            : base(resSvc, vm, creator)
        {
        }

        protected override string[] ParameterNames => new string[] { "MAPDEFINITION", "GROUPNAME" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                this.CreateMapFromResource(param);
                string groupName = param["GROUPNAME"];

                var groups = _map.GetLayerGroups();
                var group = groups.GetItem(groupName);

                group.SetVisible(false);
                return new TestResult(CommonUtility.BooleanToString(group.GetVisible()), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex);
            }
        }
    }

    public class ShowGroup : MapLayerOperationExecutor<ShowGroup>
    {
        public ShowGroup(MgResourceService resSvc, string vm, IMapCreator creator)
            : base(resSvc, vm, creator)
        {
        }

        protected override string[] ParameterNames => new string[] { "MAPDEFINITION", "GROUPNAME" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                this.CreateMapFromResource(param);
                string groupName = param["GROUPNAME"];

                var groups = _map.GetLayerGroups();
                var group = groups.GetItem(groupName);

                group.SetVisible(true);
                return new TestResult(CommonUtility.BooleanToString(group.GetVisible()), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex);
            }
        }
    }

    public class GetViewCenter : MapLayerOperationExecutor<GetViewCenter>
    {
        public GetViewCenter(MgResourceService resSvc, string vm, IMapCreator creator)
            : base(resSvc, vm, creator)
        {
        }

        protected override string[] ParameterNames => new string[] { "MAPDEFINITION" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                this.CreateMapFromResource(param);
                return new TestResult(CommonUtility.MgPointToString(_map.GetViewCenter()), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex);
            }
        }
    }

    public class GetViewScale : MapLayerOperationExecutor<GetViewScale>
    {
        public GetViewScale(MgResourceService resSvc, string vm, IMapCreator creator)
            : base(resSvc, vm, creator)
        {
        }

        protected override string[] ParameterNames => new string[] { "MAPDEFINITION" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                this.CreateMapFromResource(param);
                return new TestResult(_map.GetViewScale().ToString(CultureInfo.InvariantCulture), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex);
            }
        }
    }

    public class GetDataExtent : MapLayerOperationExecutor<GetDataExtent>
    {
        public GetDataExtent(MgResourceService resSvc, string vm, IMapCreator creator)
            : base(resSvc, vm, creator)
        {
        }

        protected override string[] ParameterNames => new string[] { "MAPDEFINITION" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                this.CreateMapFromResource(param);

                var extent = _map.GetDataExtent();
                return new TestResult(CommonUtility.MgEnvelopeToString(extent), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex);
            }
        }
    }

    public class RemoveGroup : MapLayerOperationExecutor<RemoveGroup>
    {
        public RemoveGroup(MgResourceService resSvc, string vm, IMapCreator creator)
            : base(resSvc, vm, creator)
        {
        }

        protected override string[] ParameterNames => new string[] { "MAPDEFINITION", "GROUPNAME" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                this.CreateMapFromResource(param);
                string groupName = param["GROUPNAME"];

                var groups = _map.GetLayerGroups();
                var group = groups.GetItem(groupName);

                groups.Remove(group);

                return new TestResult("", "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex);
            }
        }
    }

    public class LayerExists : MapLayerOperationExecutor<LayerExists>
    {
        public LayerExists(MgResourceService resSvc, string vm, IMapCreator creator)
            : base(resSvc, vm, creator)
        {
        }

        protected override string[] ParameterNames => new string[] { "MAPDEFINITION", "LAYERNAME" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                this.CreateMapFromResource(param);
                string layerName = param["LAYERNAME"];

                var layer = this.FindLayer(layerName);

                return new TestResult(CommonUtility.BooleanToString(layer != null), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex);
            }
        }
    }

    public class GetLayerFeatureSource : MapLayerOperationExecutor<GetLayerFeatureSource>
    {
        public GetLayerFeatureSource(MgResourceService resSvc, string vm, IMapCreator creator)
            : base(resSvc, vm, creator)
        {
        }

        protected override string[] ParameterNames => new string[] { "MAPDEFINITION", "LAYERNAME" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                this.CreateMapFromResource(param);
                string layerName = param["LAYERNAME"];

                var layer = this.FindLayer(layerName);
                if (layer == null)
                    return new TestResult("***Unknown Layer***", "text/plain");
                return new TestResult(layer.GetFeatureSourceId(), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex);
            }
        }
    }

    public class GetLayerFeatureClass : MapLayerOperationExecutor<GetLayerFeatureClass>
    {
        public GetLayerFeatureClass(MgResourceService resSvc, string vm, IMapCreator creator)
            : base(resSvc, vm, creator)
        {
        }

        protected override string[] ParameterNames => new string[] { "MAPDEFINITION", "LAYERNAME" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                this.CreateMapFromResource(param);
                string layerName = param["LAYERNAME"];

                var layer = this.FindLayer(layerName);
                return new TestResult(layer.GetFeatureClassName(), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex);
            }
        }
    }
}
