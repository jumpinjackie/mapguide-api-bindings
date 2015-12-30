using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Threading.Tasks;

namespace OSGeo.MapGuide.Test.Common
{
    public abstract class TestExecutorBase : ITestExecutor
    {
        public abstract string Api
        {
            get;
        }

        public abstract string OperationName
        {
            get;
        }

        protected virtual string[] ParameterNames => new string[0];

        protected virtual string[] PathParameterNames => new string[0];

        protected abstract NameValueCollection CollectParameters(int paramSetId);

        protected virtual void CleanParamSet(NameValueCollection param) { }

        protected abstract TestResult ExecuteInternal(NameValueCollection param);

        static bool PathExists(string val) => !string.IsNullOrEmpty(val) ? System.IO.File.Exists(val) : false;

        public TestResult Execute(int paramSetId, ITestLogger logger)
        {
            var param = CollectParameters(paramSetId);
            var fp = this.PathParameterNames;

            CleanParamSet(param);

            //Log param set
            logger.WriteLine($"ParamSet: {paramSetId}");
            foreach (string key in param.Keys)
            {
                if (fp.Contains(key))
                    logger.WriteLine($"    {key}: {(param[key] == null ? "<null>" : param[key])} [Exists: {PathExists(param[key])}]");
                else
                    logger.WriteLine($"    {key}: {(param[key] == null ? "<null>" : param[key])}");
            }
            logger.WriteLine("\n\n");

            return ExecuteInternal(param);
        }

        public abstract void Dispose();
    }
}
