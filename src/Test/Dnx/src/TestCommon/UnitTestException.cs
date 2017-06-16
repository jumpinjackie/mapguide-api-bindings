using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace OSGeo.MapGuide.Test.Common
{
    public class UnitTestException : Exception
    {
        public UnitTestException() { }
        public UnitTestException(string message) : base(message) { }
        public UnitTestException(string message, Exception inner) : base(message, inner) { }
    }
}
