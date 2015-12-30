using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace OSGeo.MapGuide.Test.Common
{
    /// <summary>
    /// Encapsulates a unit test result
    /// </summary>
    public class TestResult
    {
        public object ResultData
        {
            get;
            private set;
        }

        public string ContentType
        {
            get;
            private set;
        }

        public string HttpStatusCode
        {
            get;
            private set;
        }

        public TestResult(string resultData = "", string contentType = "", string statusCode = "")
        {
            this.IsException = false;
            this.ResultData = resultData;
            this.ContentType = contentType;
            this.HttpStatusCode = statusCode;
        }

        public static TestResult FromByteReader(MgByteReader byteReader, string operation = "")
        {
            try
            {
                TestResult res = new TestResult();
                if (byteReader != null)
                {
                    res.ContentType = byteReader.GetMimeType();
                    if (res.ContentType == MgMimeType.Html ||
                        res.ContentType == MgMimeType.Json ||
                        res.ContentType == MgMimeType.Kml ||
                        res.ContentType == MgMimeType.Text ||
                        res.ContentType == MgMimeType.Xml)
                    {
                        res.ResultData = byteReader.ToString();
                    }
                    else
                    {
                        MgByteSink sink = new MgByteSink(byteReader);
                        string path = operation + Guid.NewGuid().ToString() + "Result.bin";
                        if (string.IsNullOrEmpty(operation))
                            path = Path.GetTempFileName();
                        sink.ToFile(path);
                        res.ResultData = File.ReadAllBytes(path);
                        if (string.IsNullOrEmpty(operation))
                            File.Delete(path);
                        else
                            System.Diagnostics.Debug.WriteLine(string.Format("[MgTestRunner]: Check out {0} if binary comparison results are strange", path));
                        /*
                        byte[] bytes = new byte[byteReader.GetLength()];
                        byteReader.Read(bytes, bytes.Length);
                        res.ResultData = bytes;
                        */
                    }
                }
                return res;
            }
            catch (MgException ex)
            {
                return FromMgException(ex);
            }
        }

        public bool IsException
        {
            get;
            private set;
        }

        public string FullExceptionDetails
        {
            get;
            private set;
        }

        public static TestResult FromMgException(MgException ex)
        {
            //Need to be lowercase to satisfy a PHP-ism. Ugh!
            var res = new TestResult(ex.GetType().Name.ToLower(), "text/plain");
            res.IsException = true;
            res.FullExceptionDetails = ex.ToString();
            return res;
        }

        public static TestResult FromException(Exception ex)
        {
            var res = new TestResult(ex.Message, "text/plain");
            res.IsException = true;
            res.FullExceptionDetails = ex.ToString();
            return res;
        }
    }
}
