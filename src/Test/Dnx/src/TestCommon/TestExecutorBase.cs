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

        protected abstract NameValueCollection CollectParameters(int paramSetId);

        protected virtual void CleanParamSet(NameValueCollection param) { }

        protected abstract TestResult ExecuteInternal(NameValueCollection param);

        public TestResult Execute(int paramSetId, ITestLogger logger)
        {
            var param = CollectParameters(paramSetId);

            CleanParamSet(param);

            //Log param set
            logger.WriteLine($"ParamSet: {paramSetId}");
            foreach (string key in param.Keys)
            {
                logger.WriteLine($"    {key}: {(param[key] == null ? "<null>" : param[key])}");
            }
            logger.WriteLine("\n\n");

            return ExecuteInternal(param);
        }

        public abstract void Dispose();
    }
}
