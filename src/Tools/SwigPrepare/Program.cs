using System;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml;

namespace SwigPrepare
{
    public class Program
    {
        static string GetFullPath(params string[] parts) => Path.GetFullPath(Path.Combine(parts));

        static void FixHeaderNodes(XmlNodeList nodes, string sdkRoot)
        {
            foreach (XmlNode node in nodes)
            {
                string path = node.Attributes["path"].Value;

                //Replace known relative paths
                path.Replace("../../../Common", $"{sdkRoot}/Inc/Common")
                    .Replace("../WebApp", $"{sdkRoot}/Inc/Web/WebApp")
                    .Replace("../HttpHandler", $"{sdkRoot}/Inc/Web/HttpHandler");

                node.Attributes["path"].Value = path;
            }
        }

        public static int Main(string [] args)
        {
            if (args.Length != 2)
            {
                Console.WriteLine("Usage: SwigPrepare [sdk path] [target dir]");
                return 1;
            }

            string sdkRoot = args[0];
            string targetDir = args[1];
            if (!Directory.Exists(sdkRoot))
            {
                Console.WriteLine($"Directory not found: {sdkRoot}");
                return 1;
            }
            if (!Directory.Exists(targetDir))
            {
                Directory.CreateDirectory(targetDir);
                Console.WriteLine($"Created directory: {targetDir}");
            }

            //Normalize on / as separator
            sdkRoot = sdkRoot.Replace("\\", "/");

            string fConstants = Path.GetFullPath(Path.Combine(sdkRoot, "SWIG/Constants.xml"));
            string fMapGuideApiGen = Path.GetFullPath(Path.Combine(sdkRoot, "SWIG/MapGuideApiGen.xml"));

            if (!File.Exists(fConstants))
            {
                Console.WriteLine($"File not found: {fConstants}");
                return 1;
            }

            if (!File.Exists(fMapGuideApiGen))
            {
                Console.WriteLine($"File not found: {fMapGuideApiGen}");
                return 1;
            }
            
            StringBuilder sbConstants = new StringBuilder(File.ReadAllText(fConstants));
            StringBuilder sbMapGuideApiGen = new StringBuilder(File.ReadAllText(fMapGuideApiGen));

            sbMapGuideApiGen
                //Add extra STRINGPARAM typedef for .net Core
                .Replace("#if defined(PHP) || defined(JAVA)",
                         "#if defined(PHP) || defined(JAVA) || defined(DOTNETCORE)")
                //Patch STRINGPARAM typedef for PHP
                .Replace("typedef char*         STRINGPARAM;",
                         "typedef std::wstring STRINGPARAM;")
                //Comment out class id includes
                .Replace("%include \"../../../Common", "//%include \"../../../Common")
                .Replace("%include \"../WebApp", "//%include \"../WebApp")
                .Replace("%include \"../HttpHandler", "//%include \"../HttpHandler")
                //Fix header relative paths
                .Replace("<Header path=\"../../../Common", $"<Header path=\"{sdkRoot}/Inc/Common")
                .Replace("<Header path=\"../WebApp", $"<Header path=\"{sdkRoot}/Inc/Web/WebApp")
                .Replace("<Header path=\"../HttpHandler", $"<Header path=\"{sdkRoot}/Inc/Web/HttpHandler")
                //#elseif must've been valid in our custom version of SWIG we're using. Not here
                .Replace("#elseif", "#elif");

            sbConstants
                //Fix header relative paths
                .Replace("<Header path=\"../../../Common", $"<Header path=\"{sdkRoot}/Inc/Common")
                .Replace("<Header path=\"../WebApp", $"<Header path=\"{sdkRoot}/Inc/Web/WebApp")
                .Replace("<Header path=\"../HttpHandler", $"<Header path=\"{sdkRoot}/Inc/Web/HttpHandler");

            /*
            XmlNodeList constHeaders = constants.GetElementsByTagName("Header");
            XmlNodeList apigenHeaders = apigen.GetElementsByTagName("Header");

            XmlNode swigInline = apigen.GetElementsByTagName("SwigInline")[0];
            XmlNode cppInline = apigen.GetElementsByTagName("CppInline")[0];

            //Add extra STRINGPARAM typedef for .net Core
            StringBuilder cppInlineContent = new StringBuilder(cppInline.InnerText);
            cppInlineContent
                .Replace("#if defined(PHP) || defined(JAVA)", 
                         "#if defined(PHP) || defined(JAVA) || (defined(DOTNETCORE) && !defined(_WIN32))");

            cppInline.InnerText = cppInlineContent.ToString();

            //Comment out class id includes
            StringBuilder swigInlineContent = new StringBuilder(swigInline.InnerText);
            swigInlineContent
                .Replace("%include \"../../../Common", "//%include \"../../../Common")
                .Replace("%include \"../WebApp", "//%include \"../WebApp")
                .Replace("%include \"../HttpHandler", "//%include \"../HttpHandler");

            swigInline.InnerText = swigInlineContent.ToString();

            //Fix relative header paths
            FixHeaderNodes(constHeaders, sdkRoot);
            FixHeaderNodes(apigenHeaders, sdkRoot);
            */

            File.WriteAllText(GetFullPath(targetDir, "Constants.xml"), sbConstants.ToString());
            Console.WriteLine($"Saved: {GetFullPath(targetDir, "Constants.xml")}");

            File.WriteAllText(GetFullPath(targetDir, "MapGuideApiGen.xml"), sbMapGuideApiGen.ToString());
            Console.WriteLine($"Saved: {GetFullPath(targetDir, "MapGuideApiGen.xml")}");

            return 0;
        }
    }
}
