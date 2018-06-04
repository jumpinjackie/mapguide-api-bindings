using System;
using System.IO;
using System.Text;

namespace PhpPostProcess
{
    class Program
    {
        static int Main(string[] args)
        {
            string srcBase = null;
            if (args.Length == 1)
            {
                srcBase = args[0];
            }
            if (!Directory.Exists(srcBase))
            {
                Console.WriteLine($"ERROR: Source base directory not found: {srcBase}");
                return 1;
            }

            string phpApi = Path.Combine(srcBase, "MapGuideApi.php");
            var buffer = new StringBuilder(File.ReadAllText(phpApi));

            FixInheritance(buffer);

            File.WriteAllText(phpApi, buffer.ToString());

            return 0;
        }

        private static void FixInheritance(StringBuilder buffer)
        {
            buffer.Replace("abstract class MgDrawingService", "class MgDrawingService");
            buffer.Replace("abstract class MgFeatureService", "class MgFeatureService");
            buffer.Replace("abstract class MgKmlService", "class MgKmlService");
            buffer.Replace("abstract class MgMappingService", "class MgMappingService");
            buffer.Replace("abstract class MgProfilingService", "class MgProfilingService");
            buffer.Replace("abstract class MgRenderingService", "class MgRenderingService");
            buffer.Replace("abstract class MgTileService", "class MgTileService");
            buffer.Replace("abstract class MgResourceService", "class MgResourceService");
        }
    }
}
