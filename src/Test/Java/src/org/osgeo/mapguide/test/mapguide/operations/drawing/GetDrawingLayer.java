package org.osgeo.mapguide.test.mapguide.operations.drawing;

import java.util.*;
import com.almworks.sqlite4java.*;
import org.osgeo.mapguide.*;
import org.osgeo.mapguide.test.*;
import org.osgeo.mapguide.test.common.*;

public class GetDrawingLayer extends DrawingServiceOperationExecutor
{
    public GetDrawingLayer(MgDrawingService drawSvc, String vm)
    {
        super("GetDrawingLayer", drawSvc, vm);
    }

    public TestResult Execute(int paramSetId)
    {
        try
        {
            HashMap<String, String> param = new HashMap<String, String>();
            ReadParameterValue(paramSetId, "RESOURCEID", param);
            ReadParameterValue(paramSetId, "SECTION", param);
            ReadParameterValue(paramSetId, "LAYER", param);

            MgResourceIdentifier resId = null;
            if (param.get("RESOURCEID") != null)
            {
                resId = new MgResourceIdentifier(param.get("RESOURCEID"));
            }

            MgByteReader reader = _drawingService.getLayer(resId, param.get("SECTION"), param.get("LAYER"));
            return TestResult.FromByteReader(reader, "GETDRAWINGLAYER");
        }
        catch (MgException ex)
        {
            return TestResult.FromMgException(ex);
        }
    }
}