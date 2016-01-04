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
using System.Reflection;
using System.Linq;
using System.Runtime.InteropServices;

namespace OSGeo.MapGuide
{
    internal static class MgObjectFactory 
    {
        static string GetClassName(IntPtr objPtr)
        {
            IntPtr cPtr = MapGuideDotNetUnmanagedApiPINVOKE.GetClassName(objPtr);
            string str = Marshal.PtrToStringUni(cPtr);
            Marshal.FreeCoTaskMem(cPtr);
            return str;
        }
    
        internal static T CreateObject<T>(IntPtr objPtr) where T : class
        {
            T obj = null;
            int clsId = MapGuideDotNetUnmanagedApiPINVOKE.GetClassId(objPtr);
            string typeName = MgClassMap.GetTypeName(clsId);
            if (typeName == null) //Shouldn't happen. But if it did, this would mean we missed a spot when compiling class ids
            {
                throw new Exception("Could not resolve .net type for this unmanaged pointer. The unmanaged pointer reported a class ID of: " + clsId);
            }
            
            var type = Type.GetType(typeName);
            if (type == null) //Shouldn't happen. But if it did, this would mean we didn't expose this class to SWIG
            {
                throw new Exception("The type " + typeName + " does not exist. The unmanaged pointer reported a class ID of: " + clsId);
            }
            else
            {
                object[] args = new object[] 
                {
                    objPtr,
                    true /* ownMemory */
                };
                
                //The constructor we require has been assigned internal visibility by SWIG. We could change it to public, but the internal
                //visibility is the ideal one for purposes of encapulsation (this is internal use only). So instead of Activator.CreateInstance()
                //which does not work with internal constructors, we'll find the ctor ourselves and invoke it.
                var flags = BindingFlags.NonPublic | BindingFlags.Public | BindingFlags.Instance;
                var ctors = type.GetConstructors(flags);
                var ctor = ctors.FirstOrDefault(ci =>
                                {
                                    var parms = ci.GetParameters();
                                    if (parms.Length == 2)
                                    {
                                        return parms[0].ParameterType == typeof(IntPtr) &&
                                               parms[1].ParameterType == typeof(bool);
                                    }
                                    return false;
                                });
                if (ctor == null)
                    throw new Exception("Could not find required constructor among " + ctors.Length + " constructors with signature (IntPtr, bool) on type: " + type.Name);
                    
                obj = ctor.Invoke(args) as T;
                if (obj == null)
                    throw new Exception("Could not create an instance of type " + typeof(T).Name + " (concrete type: " + type.Name + "). The unmanaged pointer reported a class ID of: " + clsId);
            }
            return obj;
        }
    } 
}