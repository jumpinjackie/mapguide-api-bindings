using OSGeo.MapGuide.Test.Common;
using System;
using System.Reflection;

namespace OSGeo.MapGuide.Test
{
    //Defines tests outside of the SQLite-based test suite

    public class MapGuideTests
    {
        public static int Execute(IPlatformFactory factory, ITestLogger logger, ref int testsRun)
        {
            int failures = 0;
            var types = typeof(MapGuideTests).GetTypeInfo().Assembly.GetTypes();
            foreach (var type in types)
            {
                if (typeof(IExternalTest).IsAssignableFrom(type) && type.GetTypeInfo().IsClass && !type.GetTypeInfo().IsAbstract)
                {
                    var test = (IExternalTest)Activator.CreateInstance(type);
                    try
                    {
                        logger.WriteLine("****** Executing MapGuide test: " + type.Name + " *********");
                        Console.WriteLine("Executing external MapGuide test: " + type.Name);
                        test.Execute(factory, logger);
                    }
                    catch (AssertException ex)
                    {
                        logger.WriteLine("Assertion failure: " + ex.Message);
                        failures++;
                    }
                    catch (Exception ex)
                    {
                        logger.WriteLine("General failure: " + ex.ToString());
                        failures++;
                    }
                    finally
                    {
                        testsRun++;
                    }
                }
            }
            return failures;
        }
    }
}
