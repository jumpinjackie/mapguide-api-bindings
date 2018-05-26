using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace OSGeo.MapGuide.Test.Common
{
    public static class TestDataRoot
    {
        static TestDataRoot()
        {
            //Path = "../../../../TestData";
            Path = "D:/Workspace/mapguide-api-bindings/src/TestData";
        }

        public static string Path { get; set; }
    }
}
