using OSGeo.MapGuide;
using OSGeo.MapGuide.Test;
using OSGeo.MapGuide.Test.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace TestRunner
{
    //TODO: This test runner does not support generation/update mode yet. Please use the existing PHP test runner for doing this.

    public class Program
    {
        static MgUserInformation userInfo;
        static MgSiteConnection siteConn;

        class PlatformFactory : IPlatformFactory
        {
            private MgSiteConnection _siteConn;

            public PlatformFactory(MgSiteConnection siteConn)
            {
                _siteConn = siteConn;
            }

            public MgService CreateService(int serviceType)
            {
                return _siteConn.CreateService(serviceType);
            }

            public MgMapBase CreateMap(MgResourceIdentifier mapDefinition)
            {
                var map = new MgMap(_siteConn);
                map.Create(mapDefinition, mapDefinition.Name);
                return map;
            }

            public MgMapBase CreateMap(string coordSys, MgEnvelope env, string name)
            {
                var map = new MgMap(_siteConn);
                map.Create(coordSys, env, name);
                return map;
            }

            public MgLayerBase CreateLayer(MgResourceIdentifier resId)
            {
                MgResourceService resSvc = (MgResourceService)_siteConn.CreateService(MgServiceType.ResourceService);
                return new MgLayer(resId, resSvc);
            }
        }

        //Usage: MgTestRunner.exe <webconfig.ini path> <MENTOR_DICTIONARY_PATH> [test log path]
#if DNXCORE50
        static int Main(string[] args)
#else
        static void Main(string[] args)
#endif
        {
            if (args.Length >= 2 && args.Length <= 3)
            {
                string webconfig = args[0];
                string logFile = "UnitTests.log";
                if (args.Length == 3)
                    logFile = args[2];

                int failures = 0;
                using (var logger = new TestLoggerFile(logFile, false))
                {
#if DNXCORE50
                    try
                    {
#endif

                        logger.Write("Run started: {0}\n\n", DateTime.Now.ToString());

#if DNXCORE50
                        Environment.SetEnvironmentVariable("MENTOR_DICTIONARY_PATH", args[1]);
#else
                        Environment.SetEnvironmentVariable("MENTOR_DICTIONARY_PATH", args[1], EnvironmentVariableTarget.Process);
#endif

                        MgCoordinateSystemFactory csFactory = new MgCoordinateSystemFactory();
                        Console.WriteLine($"Using CS Library: {csFactory.GetBaseLibrary()}");

                        MapGuideApi.MgInitializeWebTier(args[0]);
                        userInfo = new MgUserInformation("Administrator", "admin");
                        siteConn = new MgSiteConnection();
                        siteConn.Open(userInfo);

                        var factory = new PlatformFactory(siteConn);

                        int testsRun = 0;
                        bool isEnterprise = false;
                        failures += ExecuteTest(ApiTypes.Platform, $"{TestDataRoot.Path}/ResourceService/ResourceServiceTest.dump", ref testsRun, logger, isEnterprise);
                        failures += ExecuteTest(ApiTypes.Platform, $"{TestDataRoot.Path}/DrawingService/DrawingServiceTest.dump", ref testsRun, logger, isEnterprise);
                        failures += ExecuteTest(ApiTypes.Platform, $"{TestDataRoot.Path}/FeatureService/FeatureServiceTest.dump", ref testsRun, logger, isEnterprise);
                        failures += ExecuteTest(ApiTypes.Platform, $"{TestDataRoot.Path}/SiteService/SiteServiceTest.dump", ref testsRun, logger, isEnterprise);
                        failures += ExecuteTest(ApiTypes.Platform, $"{TestDataRoot.Path}/MappingService/MappingServiceTest.dump", ref testsRun, logger, isEnterprise);
                        failures += ExecuteTest(ApiTypes.Platform, $"{TestDataRoot.Path}/ServerAdmin/ServerAdminTest.dump", ref testsRun, logger, isEnterprise);
                        failures += ExecuteTest(ApiTypes.Platform, $"{TestDataRoot.Path}/MapLayer/MapLayerTest.dump", ref testsRun, logger, isEnterprise);
                        failures += ExecuteTest(ApiTypes.Platform, $"{TestDataRoot.Path}/WebLayout/WebLayoutTest.dump", ref testsRun, logger, isEnterprise);
                        failures += ExecuteTest(ApiTypes.Platform, $"{TestDataRoot.Path}/Unicode/UnicodeTest.dump", ref testsRun, logger, isEnterprise);
                        //Run auxillary tests not part of the SQLite-defined suite
                        failures += CommonTests.Execute(factory, logger, ref testsRun);
                        failures += MapGuideTests.Execute(factory, logger, ref testsRun);
                        logger.Write("\n\nTests failed/run: {0}/{1}\n", failures, testsRun);
                        Console.Write("\n\nTests failed/run: {0}/{1}\n", failures, testsRun);
                        logger.Write("Run ended: {0}\n\n", DateTime.Now.ToString());

#if DNXCORE50
                    }
                    catch (Exception ex)
                    {
                        Environment.FailFast("Exception occurred", ex);
                    }
#endif
                }
#if DNXCORE50
                return failures;
#else
                Environment.ExitCode = failures;
#endif
            }
            else
            {
                Console.WriteLine("Usage: MgTestRunner.exe <webconfig.ini path> <MENTOR_DICTIONARY_PATH> [test log path]");
#if DNXCORE50
                return 1;
#else
                Environment.ExitCode = 1;
#endif
            }
        }

        private static int ExecuteTest(string apiType, string dumpFile, ref int testsRun, TestLoggerFile logger, bool isEnterprise)
        {
            ITestExecutorCollection exec = null;
            if (apiType == ApiTypes.Platform)
                exec = new MapGuideTestExecutorCollection(userInfo, siteConn);

            int ret = 0;
            if (exec != null)
            {
                //"validate" is currently the only test execution mode supported
                exec.Initialize("validate", dumpFile);
                ret += exec.Execute(ref testsRun, logger, isEnterprise);
                exec.Cleanup();
            }
            return ret;
        }
    }
}
