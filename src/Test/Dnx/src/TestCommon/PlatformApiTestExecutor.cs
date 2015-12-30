using OSGeo.MapGuide.Test.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Collections.Specialized;

namespace OSGeo.MapGuide.Test.Operations
{
    /// <summary>
    /// The base class of all MapGuide API test executors
    /// </summary>
    public abstract class PlatformApiTestExecutor : TestExecutorBase
    {
        protected string _unitTestVmPath;
        private SqliteDb _unitTestDb;
        protected SqliteVm _unitTestVm;

        protected PlatformApiTestExecutor(string opName, string apiType, string unitTestVm)
        {
            _opName = opName;
            _apiType = apiType;
            _unitTestVmPath = unitTestVm;

            _unitTestDb = new SqliteDb();
            _unitTestDb.Open(_unitTestVmPath);

            _unitTestVm = new SqliteVm(_unitTestDb, true);
        }

        protected virtual string[] ParameterNames => new string[0];

        protected virtual string[] PathParameterNames => new string[0];

        protected override NameValueCollection CollectParameters(int paramSetId)
        {
            var param = new NameValueCollection();
            var fp = this.PathParameterNames;

            foreach (var name in this.ParameterNames.Concat(new string[] { "OPERATION" }))
            {
                _unitTestVm.ReadParameterValue(paramSetId, name, param, fp.Contains(name));
            }

            return param;
        }

        protected override void CleanParamSet(NameValueCollection param)
        {
            foreach (var name in this.PathParameterNames)
            {
                if (param[name] != null)
                    param[name] = CommonUtility.GetPath(param[name]);
            }
        }

        public override void Dispose()
        {
            _unitTestVm.SqlFinalize();
            _unitTestVm = null;
            try
            {
                _unitTestDb.Close();
            }
            catch { }
            _unitTestDb = null;
        }

        private string _apiType;

        public override string Api
        {
            get { return _apiType; }
        }

        private string _opName;

        public override string OperationName
        {
            get { return _opName; }
        }
    }
}
