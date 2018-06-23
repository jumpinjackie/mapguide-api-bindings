using System;
using System.Runtime.InteropServices;
using OSGeo.MapGuide;

namespace TestMisc
{
    class Program
    {
        static void TestBody(string webConfigPath)
        {
            MapGuideApi.MgInitializeWebTier(webConfigPath);
            Console.WriteLine("[dotnet]: Initialized");
            var user = new MgUserInformation("Anonymous", "");
            var conn = new MgSiteConnection();
            conn.Open(user);
            // Create a session repository
            var site = conn.GetSite();
            var sessionID = site.CreateSession();
            Console.WriteLine($"[dotnet]: Created session: {sessionID}");
            user.SetMgSessionId(sessionID);
            // Get an instance of the required services.
            var resourceService = (MgResourceService)conn.CreateService(MgServiceType.ResourceService);
            Console.WriteLine("[dotnet]: Created Resource Service");
            var mappingService = (MgMappingService)conn.CreateService(MgServiceType.MappingService);
            Console.WriteLine("[dotnet]: Created Mapping Service");
            var resId = new MgResourceIdentifier("Library://UnitTest/");
            Console.WriteLine("[dotnet]: Enumeratin'");
            var resources = resourceService.EnumerateResources(resId, -1, "");
            Console.WriteLine(resources.ToString());
            Console.WriteLine("[dotnet]: Coordinate System");
            var csFactory = new MgCoordinateSystemFactory();
            Console.WriteLine("[dotnet]: CS Catalog");
            var catalog = csFactory.GetCatalog();
            Console.WriteLine("[dotnet]: Category Dictionary");
            var catDict = catalog.GetCategoryDictionary();
            Console.WriteLine("[dotnet]: CS Dictionary");
            var csDict = catalog.GetCoordinateSystemDictionary();
            Console.WriteLine("[dotnet]: Datum Dictionary");
            var datumDict = catalog.GetDatumDictionary();
            Console.WriteLine("[dotnet]: Coordinate System - LL84");
            var cs1 = csFactory.CreateFromCode("LL84");
            Console.WriteLine("[dotnet]: Coordinate System - WGS84.PseudoMercator");
            var cs2 = csFactory.CreateFromCode("WGS84.PseudoMercator");
            Console.WriteLine("[dotnet]: Make xform");
            var xform = csFactory.GetTransform(cs1, cs2);
            Console.WriteLine("[dotnet]: WKT reader");
            var wktRw = new MgWktReaderWriter();
            Console.WriteLine("[dotnet]: WKT Point");
            var pt = (MgPoint)wktRw.Read("POINT (1 2)");
            var coord = pt.GetCoordinate();
            Console.WriteLine($"[dotnet]: X: {coord.X}, Y: {coord.Y}");
            site.DestroySession(sessionID);
            Console.WriteLine($"[dotnet]: Destroyed session {sessionID}");
            Console.WriteLine("[dotnet]: Test byte reader");
            var bytes = System.Text.Encoding.UTF8.GetBytes("abcd1234");
            var bs = new MgByteSource(bytes, bytes.Length);
            var content = "";
            var br = bs.GetReader();
            byte[] buffer = new byte[2];
            int read = br.Read(buffer, 2);
            while (read > 0)
            {
                var sbuf = System.Text.Encoding.UTF8.GetString(buffer);
                Console.WriteLine("Buffer: " + sbuf);
                content += sbuf;
                read = br.Read(buffer, 2);
            }
            Console.WriteLine("[dotnet]: Test byte reader 2");
            var bs2 = new MgByteSource(bytes, bytes.Length);
            content = "";
            var br2 = bs2.GetReader();
            buffer = new byte[3];
            read = br2.Read(buffer, 3);
            while (read > 0)
            {
                var sbuf = System.Text.Encoding.UTF8.GetString(buffer, 0, read);
                Console.WriteLine("Buffer: " + sbuf);
                content += sbuf;
                read = br2.Read(buffer, 3);
            }
            var agfRw = new MgAgfReaderWriter();
            Console.WriteLine("[dotnet]: Trigger an exception");
            try
            {
                agfRw.Read(null);
            }
            catch (MgException ex)
            {
                Console.WriteLine("[dotnet]: MgException caught");
                Console.WriteLine($"[dotnet]: MgException - Message: {ex.GetExceptionMessage()}");
                Console.WriteLine($"[dotnet]: MgException - Details: {ex.GetDetails()}");
                Console.WriteLine($"[dotnet]: MgException - Stack: {ex.GetStackTrace()}");
            }
            Console.WriteLine("[dotnet]: Trigger another exception");
            try
            {
                var r = new MgResourceIdentifier("");
            }
            catch (MgException ex)
            {
                Console.WriteLine("[dotnet]: MgException caught");
                Console.WriteLine($"[dotnet]: MgException - Message: {ex.GetExceptionMessage()}");
                Console.WriteLine($"[dotnet]: MgException - Details: {ex.GetDetails()}");
                Console.WriteLine($"[dotnet]: MgException - Stack: {ex.GetStackTrace()}");
            }
        }

        static void Main(string[] args)
        {
            string path = args[0];
            if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
            {
                Console.WriteLine($"Running on Windows: {path}");
            }
            else
            {
                Console.WriteLine($"Running on Linux: {path}");
            }
            TestBody(path);
            //If you have built the .net SWIG glue wrapper with REFCOUNTING_DIAGNOSTICS, then
            //you should be seeing a whole bunch of refcounting chatter, which is verification
            //that we are actually releasing our unmanaged resources 
            GC.Collect();
            GC.WaitForPendingFinalizers();
        }
    }
}
