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
            IntPtr cPtr = MapGuideDotNetCoreUnmanagedApiPINVOKE.GetClassName(objPtr);
            string str = Marshal.PtrToStringUni(cPtr);
            Marshal.FreeCoTaskMem(cPtr);
            return str;
        }
    
        internal static T CreateObject<T>(IntPtr objPtr) where T : class
        {
            T obj = null;
            //int clsId = MapGuideDotNetCoreUnmanagedApiPINVOKE.GetClassId(objPtr);
            string className = GetClassName(objPtr);
            
            //DIRTY HACK: 
            //
            //In vanilla SWIG, there doesn't appear to be a way to intercept and capture the value of the m_cls_id member of 
            //each class that is to be wrapped. The version of SWIG in the MapGuide Oem source tree is able to do this as it 
            //was modified to look for this member and be able to construct the appropriate class id -> class name map which 
            //the original .net wrapper uses to resolve the appropriate System.Type for any IntPtr we get back from the
            //P/Invoke boundary
            //
            //What that means in this implementation is that certain classes can lie about what class names they are returning
            //due to declaring their correct class name but re-using the same class id as its parent class.
            //
            //Fortunately, this problem only really applies to a really small set of classes: The proxy classes in the
            //MapGuideCommon component. So until we can find a way to generate this class id -> System.Type mapping (as the
            //reported class id and not class name is the ultimate source of truth) with vanilla SWIG, we'll do the dirtiest
            //alternative: Just replace MgProxyClassName with MgClassName because ultimately this is the System.Type we are
            //after for such classes. All other classes *should* cleanly resolve to their System.Type counterparts.
            //
            if (className.StartsWith("MgProxy"))
            {
                className = className.Replace("MgProxy", "Mg");
            }
            
            string typeName = "OSGeo.MapGuide." + className;
            var type = Type.GetType(typeName);
            if (type == null)
            {
                //throw new Exception("The type " + typeName + " does not exist. The requested class ID is: " + clsId + ". The internal unmanaged pointer reported a class name of: " + className);
                throw new Exception("The type " + typeName + " does not exist. The internal unmanaged pointer reported a class name of: " + className);
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
                    throw new Exception("Could not create an instance of type " + typeof(T).Name + " (concrete type: " + type.Name + "). The internal unmanaged pointer reported a class name of: " + className);
                    //throw new Exception("Could not create an instance of type " + typeof(T).Name + ". The requested class ID is: " + clsId + ". The internal unmanaged pointer reported a class name of: " + className);
            }
            return obj;
        }
    } 
}