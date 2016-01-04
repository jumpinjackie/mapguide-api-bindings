//
//  Copyright (C) 2004-2015 by Autodesk, Inc.
//
//  This library is free software; you can redistribute it and/or
//  modify it under the terms of version 2.1 of the GNU Lesser
//  General Public License as published by the Free Software Foundation.
//
//  This library is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
//  Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public
//  License along with this library; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
//
using System;
using System.IO;
using System.Reflection;

namespace OSGeo.MapGuide
{
    /// <summary>
    /// This is the entry point of the MapGuide API
    /// </summary>
    public class MapGuideApi
    {
        static MapGuideApi()
        {
            
        }
        
        /// <summary>
        /// Initializes the MapGuide Web Tier APIs. You must call this method before using any other class or method
        /// in the MapGuide API
        /// </summary>
        /// <param name="configFile">The path to the web tier configuration file</param>
        /// <remarks>Subsequent calls do nothing and return immediately</remarks>
        public static void MgInitializeWebTier(string configFile) {
            MapGuideDotNetCoreUnmanagedApiPINVOKE.MgInitializeWebTier(configFile);
        }
    }
}