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

            /*
            string phpApi = Path.Combine(srcBase, "MapGuideApi.php");
            var buffer = new StringBuilder(File.ReadAllText(phpApi));

            FixInheritance(buffer);

            File.WriteAllText(phpApi, buffer.ToString());
            */
            return 0;
        }
    }
}
