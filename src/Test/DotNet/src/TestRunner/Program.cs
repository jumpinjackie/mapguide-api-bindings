using CommandLine;
using OSGeo.MapGuide;
using OSGeo.MapGuide.Test;
using OSGeo.MapGuide.Test.Common;
using System;
using System.IO;

namespace TestRunner
{
    //TODO: This test runner does not support generation/update mode yet. Please use the existing PHP test runner for doing this.

    class Options
    {
        [Option("web-config-path", Required = true, HelpText = "Path to webconfig.ini")]
        public string WebConfigPath { get; set; }

        [Option("dictionary-path", Required = true, HelpText = "CS-Map Dictionary Path")]
        public string DictionaryPath { get; set; }

        [Option("test-data-root", Required = true, HelpText = "Root path of test data files")]
        public string TestDataRoot { get; set; }

        [Option("log-path", Required = false, HelpText = "Custom log path. If not set, will default to UnitTests.log on the current directory")]
        public string LogPath { get; set; }
    }


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
        static int Main(string[] args)
        {
            int exitCode = 0;
            Parser.Default.ParseArguments<Options>(args)
                .WithParsed(opts =>
                {
                    exitCode = Run(opts);
                });

            return exitCode;
        }

        static int Run(Options options)
        {
            if (!File.Exists(options.WebConfigPath))
            {
                Console.WriteLine("webconfig.ini not found");
                return 1;
            }
            if (!Directory.Exists(options.DictionaryPath))
            {
                Console.WriteLine("CS-Map Dictionary Path not found");
                return 1;
            }
            if (!File.Exists(Path.Combine(options.TestDataRoot, $"ResourceService{Path.DirectorySeparatorChar}ResourceServiceTest.dump")))
            {
                Console.WriteLine("Bad test data root path");
                return 1;
            }

            string webconfig = options.WebConfigPath;
            string logFile = options.LogPath;
            if (string.IsNullOrEmpty(logFile))
                logFile = "UnitTests.log";

            TestDataRoot.Path = options.TestDataRoot;

            int failures = 0;
            using (var logger = new TestLoggerFile(logFile, false))
            {

                logger.Write("Run started: {0}\n\n", DateTime.Now.ToString());

                Environment.SetEnvironmentVariable("MENTOR_DICTIONARY_PATH", options.DictionaryPath, EnvironmentVariableTarget.Process);

                MgCoordinateSystemFactory csFactory = new MgCoordinateSystemFactory();
                Console.WriteLine($"Using CS Library: {csFactory.GetBaseLibrary()}");

                MapGuideApi.MgInitializeWebTier(options.WebConfigPath);
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
            }
            //Environment.ExitCode = failures;
            return failures;
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
