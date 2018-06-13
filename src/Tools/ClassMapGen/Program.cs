using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using Newtonsoft.Json;
using System.Text;

namespace ClassMapGen
{
    public class ModuleDef
    {
        public string Name { get; set; }

        public Dictionary<int, string> Classes { get; set; }
    }

    public class MasterClassMap
    {
        public List<ModuleDef> Modules { get; set; }
    }

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

            string phpOut = Path.Combine(srcBase, "Bindings/Php/PhpClassMap.cpp");
            string dotNetOut = Path.Combine(srcBase, "Bindings/DotNet/MapGuideDotNetApi/custom/MgClassMap.cs");
            string javaOut = Path.Combine(srcBase, "Bindings/Java/org/osgeo/mapguide/ObjectFactory.java");

            var phpTpl = new StringBuilder(File.ReadAllText("Data/Templates/php.txt"));
            var dotNetTpl = new StringBuilder(File.ReadAllText("Data/Templates/dotnet.txt"));
            var javaTpl = new StringBuilder(File.ReadAllText("Data/Templates/java.txt"));

            MasterClassMap clsMap = JsonConvert.DeserializeObject<MasterClassMap>(File.ReadAllText("Data/classmap_master.json"));

            var foundation = clsMap.Modules.FirstOrDefault(m => m.Name == "Foundation");
            var geometry = clsMap.Modules.FirstOrDefault(m => m.Name == "Geometry");
            var platform = clsMap.Modules.FirstOrDefault(m => m.Name == "PlatformBase");
            var mapguide = clsMap.Modules.FirstOrDefault(m => m.Name == "MapGuideCommon");
            var web = clsMap.Modules.FirstOrDefault(m => m.Name == "Web");

            int foundationAdded = 0;
            int geometryAdded = 0;
            int platformAdded = 0;
            int mapguideAdded = 0;
            int webAdded = 0;

            var classMapMaster = new Dictionary<int, string>();
            var classMapMasterReverse = new SortedDictionary<string, int>();

            foreach (var kvp in foundation.Classes)
            {
                if (classMapMaster.TryAdd(kvp.Key, kvp.Value))
                    foundationAdded++;
            }
            foreach (var kvp in geometry.Classes)
            {
                if (classMapMaster.TryAdd(kvp.Key, kvp.Value))
                    geometryAdded++;
            }
            foreach (var kvp in platform.Classes)
            {
                if (classMapMaster.TryAdd(kvp.Key, kvp.Value))
                    platformAdded++;
            }
            foreach (var kvp in mapguide.Classes)
            {
                if (classMapMaster.TryAdd(kvp.Key, kvp.Value))
                    mapguideAdded++;
            }
            foreach (var kvp in web.Classes)
            {
                if (classMapMaster.TryAdd(kvp.Key, kvp.Value))
                    webAdded++;
            }

            //Now populate reverse map
            foreach (var kvp in classMapMaster)
            {
                classMapMasterReverse[kvp.Value] = kvp.Key;
            }

            Console.WriteLine($"Foundation: {foundationAdded} classes added");
            Console.WriteLine($"Geometry: {geometryAdded} classes added");
            Console.WriteLine($"PlatformBase: {platformAdded} classes added");
            Console.WriteLine($"MapGuideCommon: {mapguideAdded} classes added");
            Console.WriteLine($"Web: {webAdded} classes added");

            Console.WriteLine($"Class map has {classMapMaster.Count} classes");

            var phpClassMaps = new StringBuilder();
            string PHP_INDENT = "    ";
            string DOTNET_INDENT = "            ";
            string JAVA_INDENT = "            ";

            //PHP
            foreach (var kvp in classMapMasterReverse)
            {
                phpClassMaps.AppendLine($"{PHP_INDENT}classNameMap[{kvp.Value}] = \"_p_{kvp.Key}\";");
            }

            phpTpl.Replace("$CLASS_NAME_MAP_BODY$", phpClassMaps.ToString());

            var dotNetClassMaps = new StringBuilder();
            
            //.net
            foreach (var kvp in classMapMasterReverse)
            {
                dotNetClassMaps.AppendLine($"{DOTNET_INDENT}classNameMap[{kvp.Value}] = \"OSGeo.MapGuide.{kvp.Key}\";");
            }

            dotNetTpl.Replace("$CLASS_NAME_MAP_BODY$", dotNetClassMaps.ToString());

            var javaClassMaps = new StringBuilder(); 

            //Java
            foreach (var kvp in classMapMasterReverse)
            {
                javaClassMaps.AppendLine($"{JAVA_INDENT}classMap.put(new Integer({kvp.Value}), Class.forName(\"org.osgeo.mapguide.{kvp.Key}\").getConstructor(new Class[] {{ Long.TYPE, Boolean.TYPE }}));");
            }

            javaTpl.Replace("$CLASS_NAME_MAP_BODY$", javaClassMaps.ToString());

            File.WriteAllText(phpOut, phpTpl.ToString());
            Console.WriteLine($"Written: {phpOut}");
            File.WriteAllText(dotNetOut, dotNetTpl.ToString());
            Console.WriteLine($"Written: {dotNetOut}");
            File.WriteAllText(javaOut, javaTpl.ToString());
            Console.WriteLine($"Written: {javaOut}");

            return 0;
        }
    }
}
