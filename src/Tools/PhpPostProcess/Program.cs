using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Threading.Tasks;

namespace PhpPostProcess
{
    class Program
    {
        static async Task<int> Main(string[] args)
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
            var originalLines = await File.ReadAllLinesAsync(phpApi);
            var buffer = new StringBuilder();

            var traits = new HashSet<string>();
            foreach (var line in originalLines)
            {
                CheckTraits(line, traits);
                buffer.AppendLine(line);
                ApplyTraits(line, buffer, traits);
            }

            await File.WriteAllTextAsync(phpApi, buffer.ToString());
            return 0;
        }

        static void ApplyTraits(ReadOnlySpan<char> line, StringBuilder buffer, HashSet<string> traits)
        {
            var idx = line.IndexOf("class ");
            if (idx >= 0) //Found a class definition
            {
                var slice = line.Slice(idx + 6 /* "class " */);
                var nIdx = slice.IndexOf(" ");
                if (nIdx >= 0)
                {
                    var substr = slice.Slice(0, nIdx);
                    string className = new string(substr);
                    if (traits.Contains(className))
                    {
                        buffer.AppendLine("    use " + className + "Patched; /* Inserted by PhpPostProcess tool */");
                        Console.WriteLine("Applying trait for: " + className);
                    }
                }
            }
        }

        static void CheckTraits(ReadOnlySpan<char> line, HashSet<string> traits)
        {
            var idx = line.IndexOf("trait ");
            if (idx >= 0)
            {
                var slice = line.Slice(idx + 6 /* "trait " */);
                var nIdx = slice.IndexOf(" ");
                if (nIdx > 7)
                {
                    //Traits follow a naming convention of *ClassName*Patched
                    var substr = slice.Slice(0, nIdx - 7 /* "Patched " */);

                    string trait = new string(substr);
                    traits.Add(trait);
                    Console.WriteLine("Found trait: " + trait);
                }
            }
        }
    }
}
