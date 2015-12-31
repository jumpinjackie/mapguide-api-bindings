using OSGeo.MapGuide.Test.Common;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Threading.Tasks;

namespace OSGeo.MapGuide.Test.Operations
{
    public class DescribeDrawing : DrawingServiceOperationExecutor<DescribeDrawing>
    {
        public DescribeDrawing(MgDrawingService drawSvc, string vm)
            : base(drawSvc, vm)
        {
        }

        protected override string[] ParameterNames => new string[] { "RESOURCEID" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgResourceIdentifier resId = param.TryGetResourceId("RESOURCEID");

                MgByteReader reader = _drawingService.DescribeDrawing(resId);
                return TestResult.FromByteReader(reader);
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class GetDrawing : DrawingServiceOperationExecutor<GetDrawing>
    {
        public GetDrawing(MgDrawingService drawSvc, string vm)
            : base(drawSvc, vm)
        {
        }

        protected override string[] ParameterNames => new string[] { "RESOURCEID" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgResourceIdentifier resId = param.TryGetResourceId("RESOURCEID");

                MgByteReader reader = _drawingService.GetDrawing(resId);
                return TestResult.FromByteReader(reader, "GETDRAWING");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class EnumerateDrawingLayers : DrawingServiceOperationExecutor<EnumerateDrawingLayers>
    {
        public EnumerateDrawingLayers(MgDrawingService drawSvc, string vm)
            : base(drawSvc, vm)
        {
        }

        protected override string[] ParameterNames => new string[] { "RESOURCEID", "SECTION" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgResourceIdentifier resId = param.TryGetResourceId("RESOURCEID");

                MgStringCollection coll = _drawingService.EnumerateLayers(resId, param["SECTION"] ?? "");
                MgByteReader reader = coll?.ToXml();
                return TestResult.FromByteReader(reader);
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class GetDrawingLayer : DrawingServiceOperationExecutor<GetDrawingLayer>
    {
        public GetDrawingLayer(MgDrawingService drawSvc, string vm)
            : base(drawSvc, vm)
        {
        }

        protected override string[] ParameterNames => new string[] { "RESOURCEID", "SECTION", "LAYER" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgResourceIdentifier resId = param.TryGetResourceId("RESOURCEID");

                MgByteReader reader = _drawingService.GetLayer(resId, param["SECTION"], param["LAYER"]);
                return TestResult.FromByteReader(reader, "GETDRAWINGLAYER");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class GetDrawingSection : DrawingServiceOperationExecutor<GetDrawingSection>
    {
        public GetDrawingSection(MgDrawingService drawSvc, string vm)
            : base(drawSvc, vm)
        {
        }

        protected override string[] ParameterNames => new string[] { "RESOURCEID", "SECTION" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgResourceIdentifier resId = param.TryGetResourceId("RESOURCEID");

                MgByteReader reader = _drawingService.GetSection(resId, param["SECTION"]);
                return TestResult.FromByteReader(reader, "GETDRAWINGSECTION");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class EnumerateDrawingSections : DrawingServiceOperationExecutor<EnumerateDrawingSections>
    {
        public EnumerateDrawingSections(MgDrawingService drawSvc, string vm)
            : base(drawSvc, vm)
        {
        }

        protected override string[] ParameterNames => new string[] { "RESOURCEID" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgResourceIdentifier resId = param.TryGetResourceId("RESOURCEID");

                MgByteReader reader = _drawingService.EnumerateSections(resId);
                return TestResult.FromByteReader(reader);
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class EnumerateDrawingSectionResources : DrawingServiceOperationExecutor<EnumerateDrawingSectionResources>
    {
        public EnumerateDrawingSectionResources(MgDrawingService drawSvc, string vm)
            : base(drawSvc, vm)
        {
        }

        protected override string[] ParameterNames => new string[] { "RESOURCEID", "SECTION" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgResourceIdentifier resId = param.TryGetResourceId("RESOURCEID");

                MgByteReader reader = _drawingService.EnumerateSectionResources(resId, param["SECTION"] ?? "");
                return TestResult.FromByteReader(reader);
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class GetDrawingSectionResource : DrawingServiceOperationExecutor<GetDrawingSectionResource>
    {
        public GetDrawingSectionResource(MgDrawingService drawSvc, string vm)
            : base(drawSvc, vm)
        {
        }

        protected override string[] ParameterNames => new string[] { "RESOURCEID", "RESOURCENAME" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgResourceIdentifier resId = param.TryGetResourceId("RESOURCEID");

                MgByteReader reader = _drawingService.GetSectionResource(resId, param["RESOURCENAME"]);
                return TestResult.FromByteReader(reader, "GETDRAWINGSECTIONRESOURCE");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }
}
