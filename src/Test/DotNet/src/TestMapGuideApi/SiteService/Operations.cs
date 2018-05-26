using OSGeo.MapGuide.Test.Common;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OSGeo.MapGuide.Test.Operations
{
    public interface IMapGuideSession
    {
        string SessionID { get; set; }
    }

    public class CreateSession : SiteServiceOperationExecutor<CreateSession>
    {
        private IMapGuideSession _session;

        public CreateSession(MgSite site, string unitTestVm, IMapGuideSession session)
            : base(site, unitTestVm)
        {
            _session = session;
        }

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                var user = new MgUserInformation();
                user.SetMgUsernamePassword("Administrator", "admin");
                user.SetLocale("en");

                var site = new MgSite();
                site.Open(user);

                string session = site.CreateSession();
                _session.SessionID = session;
                site.Close();

                return new TestResult(session, "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class DestroySession : SiteServiceOperationExecutor<DestroySession>
    {
        public DestroySession(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                //This is what PHP one is giving us
                return new TestResult("Not Implemented Yet", "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class GetUserForSession : SiteServiceOperationExecutor<GetUserForSession>
    {
        private IMapGuideSession _session;

        public GetUserForSession(MgSite site, string unitTestVm, IMapGuideSession session)
            : base(site, unitTestVm)
        {
            _session = session;
        }

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                var site = new MgSite();
                var user = new MgUserInformation();
                user.SetMgSessionId(_session.SessionID ?? "");
                site.Open(user);
                var userId = site.GetUserForSession();
                site.Close();
                return new TestResult(userId, "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    /*
    public class GetSiteServerAddress : SiteServiceOperationExecutor<GetSiteServerAddress>
    {
        public GetSiteServerAddress(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                var result = _site.GetCurrentSiteAddress();
                return new TestResult();
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }
     */

    public class EnumerateUsers : SiteServiceOperationExecutor<EnumerateUsers>
    {
        public EnumerateUsers(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "GROUP", "ROLE", "INCLUDEGROUPS" };
        
        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgByteReader reader = null;
                if (param["ROLE"] != null)
                {
                    reader = _site.EnumerateUsers(param["GROUP"] ?? "", param["ROLE"] ?? "", (param["INCLUDEGROUPS"] == "1"));
                }
                else
                {
                    reader = _site.EnumerateUsers(param["GROUP"] ?? "");
                }
                return TestResult.FromByteReader(reader);
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class AddUser : SiteServiceOperationExecutor<AddUser>
    {
        public AddUser(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "USERID", "USERNAME", "PASSWORD", "DESCRIPTION" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                _site.AddUser(param["USERID"], param["USERNAME"], param["PASSWORD"], param["DESCRIPTION"]);
                return new TestResult();
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class UpdateUser : SiteServiceOperationExecutor<UpdateUser>
    {
        public UpdateUser(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "USERID", "NEWUSERID", "NEWUSERNAME", "NEWPASSWORD", "NEWDESCRIPTION" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                _site.UpdateUser(param["USERID"], param["NEWUSERID"], param["NEWUSERNAME"], param["NEWPASSWORD"], param["NEWDESCRIPTION"]);
                return new TestResult();
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class DeleteUsers : SiteServiceOperationExecutor<DeleteUsers>
    {
        public DeleteUsers(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "USERS" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgStringCollection users = CommonUtility.StringToMgStringCollection(param["USERS"]);

                _site.DeleteUsers(users);
                return new TestResult();
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class GrantRoleMembershipsToUsers : SiteServiceOperationExecutor<GrantRoleMembershipsToUsers>
    {
        public GrantRoleMembershipsToUsers(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "ROLES", "USERS" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgStringCollection roles = CommonUtility.StringToMgStringCollection(param["ROLES"]);
                MgStringCollection users = CommonUtility.StringToMgStringCollection(param["USERS"]);

                _site.GrantRoleMembershipsToUsers(roles, users);

                return new TestResult();
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class RevokeRoleMembershipsFromUsers : SiteServiceOperationExecutor<RevokeRoleMembershipsFromUsers>
    {
        public RevokeRoleMembershipsFromUsers(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "ROLES", "USERS" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgStringCollection roles = CommonUtility.StringToMgStringCollection(param["ROLES"]);
                MgStringCollection users = CommonUtility.StringToMgStringCollection(param["USERS"]);

                _site.RevokeRoleMembershipsFromUsers(roles, users);

                return new TestResult();
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class GrantGroupMembershipsToUsers : SiteServiceOperationExecutor<GrantGroupMembershipsToUsers>
    {
        public GrantGroupMembershipsToUsers(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "GROUPS", "USERS" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgStringCollection groups = CommonUtility.StringToMgStringCollection(param["GROUPS"]);
                MgStringCollection users = CommonUtility.StringToMgStringCollection(param["USERS"]);

                _site.GrantGroupMembershipsToUsers(groups, users);

                return new TestResult();
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class RevokeGroupMembershipsFromUsers : SiteServiceOperationExecutor<RevokeGroupMembershipsFromUsers>
    {
        public RevokeGroupMembershipsFromUsers(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "GROUPS", "USERS" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgStringCollection groups = CommonUtility.StringToMgStringCollection(param["GROUPS"]);
                MgStringCollection users = CommonUtility.StringToMgStringCollection(param["USERS"]);

                _site.RevokeGroupMembershipsFromUsers(groups, users);

                return new TestResult();
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class EnumerateGroups : SiteServiceOperationExecutor<EnumerateGroups>
    {
        public EnumerateGroups(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "USER", "ROLE" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgByteReader reader = _site.EnumerateGroups(param["USER"] ?? "", param["ROLE"] ?? "");
                return TestResult.FromByteReader(reader);
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class EnumerateGroups2 : SiteServiceOperationExecutor<EnumerateGroups2>
    {
        public EnumerateGroups2(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "USER", "LOGIN", "PASSWORD" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                var userInfo = new MgUserInformation();
                userInfo.SetMgUsernamePassword(param["LOGIN"], param["PASSWORD"]);
                userInfo.SetLocale("en");

                var site = new MgSite();
                site.Open(userInfo);

                MgByteReader reader = site.EnumerateGroups(param["USER"]);
                site.Close();

                return TestResult.FromByteReader(reader);
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class EnumerateRoles2 : SiteServiceOperationExecutor<EnumerateRoles2>
    {
        public EnumerateRoles2(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "USER", "LOGIN", "PASSWORD" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                var userInfo = new MgUserInformation();
                userInfo.SetMgUsernamePassword(param["LOGIN"], param["PASSWORD"]);
                userInfo.SetLocale("en");

                var site = new MgSite();
                site.Open(userInfo);

                MgStringCollection roles = site.EnumerateRoles(param["USER"]);
                site.Close();

                return new TestResult(CommonUtility.MgStringCollectionToString(roles), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class AddGroup : SiteServiceOperationExecutor<AddGroup>
    {
        public AddGroup(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "GROUP", "DESCRIPTION" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                _site.AddGroup(param["GROUP"] ?? "", param["DESCRIPTION"] ?? "");
                return new TestResult();
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class UpdateGroup : SiteServiceOperationExecutor<UpdateGroup>
    {
        public UpdateGroup(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "GROUP", "NEWGROUP", "NEWDESCRIPTION" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                _site.UpdateGroup(param["GROUP"] ?? "", param["NEWGROUP"] ?? "", param["NEWDESCRIPTION"] ?? "");
                return new TestResult();
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class DeleteGroups : SiteServiceOperationExecutor<DeleteGroups>
    {
        public DeleteGroups(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "GROUPS" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgStringCollection groups = CommonUtility.StringToMgStringCollection(param["GROUPS"]);
                _site.DeleteGroups(groups);

                return new TestResult();
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class GrantRoleMembershipsToGroups : SiteServiceOperationExecutor<GrantRoleMembershipsToGroups>
    {
        public GrantRoleMembershipsToGroups(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "ROLES", "GROUPS" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgStringCollection roles = CommonUtility.StringToMgStringCollection(param["ROLES"]);
                MgStringCollection groups = CommonUtility.StringToMgStringCollection(param["GROUPS"]);

                _site.GrantRoleMembershipsToGroups(roles, groups);

                return new TestResult();
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class RevokeRoleMembershipsFromGroups : SiteServiceOperationExecutor<RevokeRoleMembershipsFromGroups>
    {
        public RevokeRoleMembershipsFromGroups(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "ROLES", "GROUPS" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgStringCollection roles = CommonUtility.StringToMgStringCollection(param["ROLES"]);
                MgStringCollection groups = CommonUtility.StringToMgStringCollection(param["GROUPS"]);

                _site.RevokeRoleMembershipsFromGroups(roles, groups);

                return new TestResult();
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class EnumerateRoles : SiteServiceOperationExecutor<EnumerateRoles>
    {
        public EnumerateRoles(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "USER", "GROUP" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgStringCollection roles = _site.EnumerateRoles(param["USER"], param["GROUP"]);

                return new TestResult(CommonUtility.MgStringCollectionToString(roles), "text/plain");
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class EnumerateServers : SiteServiceOperationExecutor<EnumerateServers>
    {
        public EnumerateServers(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                MgByteReader reader = _site.EnumerateServers();
                return TestResult.FromByteReader(reader);
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class AddServer : SiteServiceOperationExecutor<AddServer>
    {
        public AddServer(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "NAME", "DESCRIPTION", "ADDRESS" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                _site.AddServer(param["NAME"], param["DESCRIPTION"], param["ADDRESS"]);
                return new TestResult();
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class UpdateServer : SiteServiceOperationExecutor<UpdateServer>
    {
        public UpdateServer(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "OLDNAME", "NEWNAME", "NEWDESCRIPTION", "NEWADDRESS" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                _site.UpdateServer(param["OLDNAME"], param["NEWNAME"], param["NEWDESCRIPTION"], param["NEWADDRESS"]);
                return new TestResult();
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class RemoveServer : SiteServiceOperationExecutor<RemoveServer>
    {
        public RemoveServer(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override string[] ParameterNames => new string[] { "NAME" };

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                _site.RemoveServer(param["NAME"]);
                return new TestResult();
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    /*
    public class EnumerateServicesOnServer : SiteServiceOperationExecutor<EnumerateServicesOnServer>
    {
        public EnumerateServicesOnServer(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                return new TestResult();
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }

    public class AddServicesToServer : SiteServiceOperationExecutor<AddServicesToServer>
    {
        public AddServicesToServer(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                return new TestResult();
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }
    
    public class RemoveServicesFromServer : SiteServiceOperationExecutor<RemoveServicesFromServer>
    {
        public RemoveServicesFromServer(MgSite site, string unitTestVm)
            : base(site, unitTestVm)
        {

        }

        protected override TestResult ExecuteInternal(NameValueCollection param)
        {
            try
            {
                return new TestResult();
            }
            catch (MgException ex)
            {
                return TestResult.FromMgException(ex, param);
            }
        }
    }
     */
}
