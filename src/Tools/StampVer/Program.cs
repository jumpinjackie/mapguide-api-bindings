using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;

namespace StampVer
{
    public class Program
    {
        class Arguments
        {
            public string SourceDir { get; set; }

            public Version Version { get; set; }
        }

        static Arguments Parse(string [] args)
        {
            if (args.Length != 5)
                throw new Exception($"Unexpected number of arguments. Expected 5. Got {args.Length}");

            string sourceDir = args[0];
            if (!Directory.Exists(sourceDir))
                throw new DirectoryNotFoundException($"Source directory not found: {sourceDir}");

            Version ver = new Version($"{args[1]}.{args[2]}.{args[3]}.{args[4]}");
            return new Arguments()
            {
                SourceDir = sourceDir,
                Version = ver
            };
        }

        public static int Main(string [] args)
        {
            Arguments arg = null;

            try
            {
                arg = Parse(args);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"ERROR: {ex.Message}");
                Console.WriteLine($"Usage: StampVer [source directory] [ver:major] [ver:minor] [ver:build] [ver:rev]");
                return 1;
            }

            StampAssemblyInfo(arg.Version, GetFullPath(arg, "Bindings/DotNet/MapGuideDotNetApi/Properties/AssemblyInfo.cs"));
            StampProjectFile(arg.Version, GetFullPath(arg, "Bindings/DotNet/MapGuideDotNetApi/MapGuideDotNetApi.csproj"));

            return 0;
        }
        
        static string GetFullPath(Arguments arg, string relPath)
        {
            var path = Path.Combine(arg.SourceDir, relPath);
            return Path.GetFullPath(path);
        }

        static void StampProjectFile(Version ver, string path)
        {
            if (!File.Exists(path))
            {
                Console.WriteLine($"WARNING: File not found ({path}). Skipping");
                return;
            }
            var asmVerRegx = new Regex(@"<Version>\d+\.\d+\.\d+\.\d+</Version>");
            string asmVerReplace = $"<Version>{ver.ToString()}</Version>";
            string content = asmVerRegx.Replace(File.ReadAllText(path), asmVerReplace);
            File.WriteAllText(path, content);
            Console.WriteLine($"Updated: {path}");
        }

        static void StampAssemblyInfo(Version ver, string path)
        {
            if (!File.Exists(path))
            {
                Console.WriteLine($"WARNING: File not found ({path}). Skipping");
                return;
            }
            var asmVerRegx = new Regex(@"Version\(\""\d+\.\d+\.\d+\.\d+\""\)");
            string asmVerReplace = $"Version(\"{ver.ToString()}\")";
            string content = asmVerRegx.Replace(File.ReadAllText(path), asmVerReplace);
            File.WriteAllText(path, content);
            Console.WriteLine($"Updated: {path}");
        }
    }
}