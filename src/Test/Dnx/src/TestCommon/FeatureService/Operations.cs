using OSGeo.MapGuide.Test.Common;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Threading.Tasks;

namespace OSGeo.MapGuide.Test.Operations
{
    public class GetFeatureProviders : FeatureServiceOperationExecutor<GetFeatureProviders>
    {
        public GetFeatureProviders(MgFeatureService featSvc, string unitTestVm)
            : base(featSvc, unitTestVm)
        {

        }

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgByteReader reader = _featureService.GetFeatureProviders();
                return TestResult.FromByteReader(null);
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
            catch (Exception ex)
            {
                return TestResult.FromException(ex);
            }
        }
    }

    public class GetProviderCapabilities : FeatureServiceOperationExecutor<GetProviderCapabilities>
    {
        public GetProviderCapabilities(MgFeatureService featSvc, string unitTestVm)
            : base(featSvc, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "PROVIDER" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgByteReader reader = _featureService.GetCapabilities(param["PROVIDER"] ?? "");
                return TestResult.FromByteReader(reader);
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
            catch (Exception ex)
            {
                return TestResult.FromException(ex);
            }
        }
    }

    public class GetConnectionPropertyValues : FeatureServiceOperationExecutor<GetConnectionPropertyValues>
    {
        public GetConnectionPropertyValues(MgFeatureService featSvc, string unitTestVm)
            : base(featSvc, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "PROVIDER", "PROPERTY", "CONNECTIONSTRING" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgStringCollection result = _featureService.GetConnectionPropertyValues(param["PROVIDER"], param["PROPERTY"], param["CONNECTIONSTRING"]);
                return new TestResult(CommonUtility.MgStringCollectionToString(result), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
            catch (Exception ex)
            {
                return TestResult.FromException(ex);
            }
        }
    }

    public class DescribeFeatureSchema : FeatureServiceOperationExecutor<DescribeFeatureSchema>
    {
        public DescribeFeatureSchema(MgFeatureService featSvc, string unitTestVm)
            : base(featSvc, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "RESOURCEID", "SCHEMA" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgResourceIdentifier resId = param.TryGetResourceId("RESOURCEID");

                string result = _featureService.DescribeSchemaAsXml(resId, param["SCHEMA"]);

                return new TestResult(result, "text/xml");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
            catch (Exception ex)
            {
                return TestResult.FromException(ex);
            }
        }
    }

    public class SelectFeatures : FeatureServiceOperationExecutor<SelectFeatures>
    {
        public SelectFeatures(MgFeatureService featSvc, string unitTestVm)
            : base(featSvc, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "RESOURCEID", "CLASSNAME", "PROPERTIES", "FILTER" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgResourceIdentifier resId = param.TryGetResourceId("RESOURCEID");

                MgFeatureQueryOptions query = new MgFeatureQueryOptions();
                //TODO: Set query options
                if (param["FILTER"] != null)
                {
                    query.SetFilter(param["FILTER"]);
                }

                //PROPERTIES should be stored in the database as comma separated string without spaces
                if (param["PROPERTIES"] != null)
                {
                    string[] props = param["PROPERTIES"].Split(',');
                    foreach (var p in props)
                    {
                        query.AddFeatureProperty(p);
                    }
                }

                MgFeatureReader reader = _featureService.SelectFeatures(resId, param["CLASSNAME"], query);
                MgByteReader byteReader = reader.ToXml();
                reader.Close();
                return TestResult.FromByteReader(byteReader);
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
            catch (Exception ex)
            {
                return TestResult.FromException(ex);
            }
        }
    }

    public class SelectAggregates : FeatureServiceOperationExecutor<SelectAggregates>
    {
        public SelectAggregates(MgFeatureService featSvc, string unitTestVm)
            : base(featSvc, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "RESOURCEID", "CLASSNAME" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgResourceIdentifier resId = param.TryGetResourceId("RESOURCEID");

                MgFeatureAggregateOptions query = new MgFeatureAggregateOptions();
                //TODO: Set query options
                /*
                if (param["FILTER"] != null)
                {
                    query.SetFilter(param["FILTER"]);
                }
                */
                //PROPERTIES should be stored in the database as comma separated string without spaces
                /*
                if (param["PROPERTIES"] != null)
                {
                    string[] props = param["PROPERTIES"].Split(',');
                    foreach (var p in props)
                    {
                        query.AddFeatureProperty(p);
                    }
                }*/

                MgDataReader reader = _featureService.SelectAggregate(resId, param["CLASSNAME"], query);
                MgByteReader byteReader = reader.ToXml();
                reader.Close();
                return TestResult.FromByteReader(byteReader);
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
            catch (Exception ex)
            {
                return TestResult.FromException(ex);
            }
        }
    }

    public class ExecuteSqlQuery : FeatureServiceOperationExecutor<ExecuteSqlQuery>
    {
        public ExecuteSqlQuery(MgFeatureService featSvc, string unitTestVm)
            : base(featSvc, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "RESOURCEID", "SQL" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgResourceIdentifier resId = param.TryGetResourceId("RESOURCEID");

                MgSqlDataReader reader = _featureService.ExecuteSqlQuery(resId, param["SQL"]);
                MgByteReader byteReader = reader.ToXml();
                reader.Close();
                return TestResult.FromByteReader(byteReader);
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
            catch (Exception ex)
            {
                return TestResult.FromException(ex);
            }
        }
    }

    public class GetSpatialContexts : FeatureServiceOperationExecutor<GetSpatialContexts>
    {
        public GetSpatialContexts(MgFeatureService featSvc, string unitTestVm)
            : base(featSvc, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "RESOURCEID", "ACTIVEONLY" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgResourceIdentifier resId = param.TryGetResourceId("RESOURCEID");

                MgSpatialContextReader reader = _featureService.GetSpatialContexts(resId, (param["ACTIVEONLY"] == "1"));
                MgByteReader byteReader = reader.ToXml();
                reader.Close();
                return TestResult.FromByteReader(byteReader);
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
            catch (Exception ex)
            {
                return TestResult.FromException(ex);
            }
        }
    }

    public class GetLongTransactions : FeatureServiceOperationExecutor<GetLongTransactions>
    {
        public GetLongTransactions(MgFeatureService featSvc, string unitTestVm)
            : base(featSvc, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "RESOURCEID", "ACTIVEONLY" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgResourceIdentifier resId = param.TryGetResourceId("RESOURCEID");

                MgLongTransactionReader reader = _featureService.GetLongTransactions(resId, (param["ACTIVEONLY"] == "1"));
                MgByteReader byteReader = reader.ToXml();
                reader.Close();
                return TestResult.FromByteReader(byteReader);
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
            catch (Exception ex)
            {
                return TestResult.FromException(ex);
            }
        }
    }

    public interface ISessionCreator
    {
        string CreateSession();
    }

    public interface IApplySession
    {
        void SetSessionId(string sessionId);
    }

    public class SetLongTransaction : FeatureServiceOperationExecutor<SetLongTransaction>
    {
        private ISessionCreator _creator;
        private IApplySession _apply;

        public SetLongTransaction(MgFeatureService featSvc, string unitTestVm, ISessionCreator creator, IApplySession apply)
            : base(featSvc, unitTestVm)
        {
            _creator = creator;
            _apply = apply;
        }

        protected override string[] ParameterNames => new string[] { "RESOURCEID", "LONGTRANSACTIONNAME", "CREATESESSION" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgResourceIdentifier resId = param.TryGetResourceId("RESOURCEID");

                if (param["CREATESESSION"] == "TRUE")
                {
                    string sessionId = _creator.CreateSession();
                    _apply.SetSessionId(sessionId);
                }

                bool bRes = _featureService.SetLongTransaction(resId, param["LONGTRANSACTIONNAME"]);

                return new TestResult(CommonUtility.BooleanToString(bRes), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
            catch (Exception ex)
            {
                return TestResult.FromException(ex);
            }
        }
    }

    public class TestConnection : FeatureServiceOperationExecutor<TestConnection>
    {
        public TestConnection(MgFeatureService featSvc, string unitTestVm)
            : base(featSvc, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "RESOURCEID", "PROVIDER", "CONNECTIONSTRING" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                bool bRes = false;
                MgResourceIdentifier resId = null;
                if (!string.IsNullOrEmpty(param["RESOURCEID"]))
                {
                    resId = new MgResourceIdentifier(param["RESOURCEID"]);
                    bRes = _featureService.TestConnection(resId);
                }
                else
                {
                    bRes = _featureService.TestConnection(param["PROVIDER"] ?? "", param["CONNECTIONSTRING"] ?? "");
                }

                return new TestResult(CommonUtility.BooleanToString(bRes), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
            catch (Exception ex)
            {
                return TestResult.FromException(ex);
            }
        }
    }

    public class GetSchemas : FeatureServiceOperationExecutor<GetSchemas>
    {
        public GetSchemas(MgFeatureService featSvc, string unitTestVm)
            : base(featSvc, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "RESOURCEID" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgResourceIdentifier resId = param.TryGetResourceId("RESOURCEID");

                MgStringCollection result = _featureService.GetSchemas(resId);
                return new TestResult(CommonUtility.MgStringCollectionToString(result), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
            catch (Exception ex)
            {
                return TestResult.FromException(ex);
            }
        }
    }

    public class GetClasses : FeatureServiceOperationExecutor<GetClasses>
    {
        public GetClasses(MgFeatureService featSvc, string unitTestVm)
            : base(featSvc, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "RESOURCEID", "SCHEMANAME" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgResourceIdentifier resId = param.TryGetResourceId("RESOURCEID");

                MgStringCollection result = _featureService.GetClasses(resId, param["SCHEMANAME"]);
                return new TestResult(CommonUtility.MgStringCollectionToString(result), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
            catch (Exception ex)
            {
                return TestResult.FromException(ex);
            }
        }
    }
}
