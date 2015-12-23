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
namespace OSGeo.MapGuide
{
    internal static class MgObjectFactory 
    {
        static string GetClassName(global::System.IntPtr objPtr)
        {
            global::System.IntPtr cPtr = MapGuideDotNetCoreUnmanagedApiPINVOKE.GetClassName(objPtr);
            string str = global::System.Runtime.InteropServices.Marshal.PtrToStringAnsi(cPtr);
            global::System.Runtime.InteropServices.Marshal.FreeCoTaskMem(cPtr);
            return str;
        }
    
        internal static T CreateObject<T>(global::System.IntPtr objPtr) where T : class
        {
            T obj = null;
            int clsId = MapGuideDotNetCoreUnmanagedApiPINVOKE.GetClassId(objPtr);
            string className = GetClassName(objPtr);
            string typeName = "OSGeo.MapGuide." + className;
            var type = global::System.Type.GetType(typeName);
            if (type == null)
            {
                throw new global::System.Exception("The type " + typeName + " does not exist");
            }
            else
            {
                object[] args = new object[] 
                {
                    objPtr,
                    true /* ownMemory */
                };
                obj = global::System.Activator.CreateInstance(type, args) as T;
                if (obj == null)
                    throw new global::System.Exception("Could not create an instance of type " + typeof(T).Name + ". The requested class ID is: " + clsId + ". The internal pointer reported a class name of: " + className);
            }
            return obj;
        }
    } 
}