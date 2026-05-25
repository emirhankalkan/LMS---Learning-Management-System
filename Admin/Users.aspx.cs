using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.UI;
using EduFlow.DAL;

namespace EduFlow.Admin
{
    public partial class Users : Page
    {
        protected string UsersTableHtml { get; private set; }
        protected int TotalUsersCount   { get; private set; }
        protected string SearchTerm     { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Güvenlik: Admin rolü kontrolü
            if (Session["UserId"] == null || Session["UserRole"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            int currentAdminId = Convert.ToInt32(Session["UserId"]);
            SearchTerm = Request.QueryString["q"] ?? "";

            // Kullanıcı Durumu Değiştirme (Aktif / Pasif)
            if (int.TryParse(Request.QueryString["toggle"], out var toggleId) &&
                int.TryParse(Request.QueryString["status"], out var statusValue))
            {
                // Güvenlik: Admin kendisini pasif yapamaz
                if (toggleId != currentAdminId)
                {
                    try
                    {
                        using (var conn = Db.OpenConnection())
                        using (var cmd = Db.StoredProcedure("sp_SetUserActive", conn))
                        {
                            cmd.Parameters.AddWithValue("@UserId", toggleId);
                            cmd.Parameters.AddWithValue("@IsActive", statusValue == 1);
                            cmd.ExecuteNonQuery();
                        }
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Kullanıcı aktif/pasif değiştirme hatası: " + ex.Message);
                    }
                }
                Response.Redirect("~/Admin/Users.aspx?q=" + Server.UrlEncode(SearchTerm));
                return;
            }

            // Tüm Kullanıcıları DB'den Çek
            var usersList = new List<UserModel>();
            try
            {
                using (var conn = Db.OpenConnection())
                using (var cmd = Db.StoredProcedure("sp_GetAllUsers", conn))
                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        usersList.Add(new UserModel
                        {
                            UserId = Convert.ToInt32(r["UserId"]),
                            FullName = r["FullName"].ToString(),
                            Email = r["Email"].ToString(),
                            RoleName = r["RoleName"].ToString(),
                            IsActive = Convert.ToBoolean(r["IsActive"]),
                            CreatedAt = Convert.ToDateTime(r["CreatedAt"])
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Kullanıcı listesi yükleme hatası: " + ex.Message);
            }

            // Arama filtresi uygula
            if (!string.IsNullOrEmpty(SearchTerm))
            {
                usersList = usersList.FindAll(u =>
                    u.FullName.IndexOf(SearchTerm, StringComparison.OrdinalIgnoreCase) >= 0 ||
                    u.Email.IndexOf(SearchTerm, StringComparison.OrdinalIgnoreCase) >= 0
                );
            }

            TotalUsersCount = usersList.Count;

            var sb = new StringBuilder();
            int index = 1;
            foreach (var u in usersList)
            {
                string initial = !string.IsNullOrEmpty(u.FullName) ? u.FullName.Substring(0, 1).ToUpper() : "?";
                string roleBadge = u.RoleName == "Admin" ? "<span class=\"badge-featured\">Admin</span>" : "<span class=\"badge-level\">Öğrenci</span>";
                string statusBadge = u.IsActive ? "<span class=\"badge-free\">Aktif</span>" : "<span class=\"badge-discount\">Pasif</span>";
                
                // İşlemler Butonu
                string actionButton = "";
                if (u.UserId != currentAdminId)
                {
                    if (u.IsActive)
                    {
                        actionButton = string.Format(@"<a href=""Users.aspx?toggle={0}&status=0&q={1}"" class=""btn btn-sm me-1"" style=""background:var(--color-warning-bg);color:var(--color-accent-dark);border:0;text-decoration:none;display:inline-block;"" title=""Pasif yap""><i class=""bi bi-toggle-on""></i></a>", u.UserId, Server.UrlEncode(SearchTerm));
                    }
                    else
                    {
                        actionButton = string.Format(@"<a href=""Users.aspx?toggle={0}&status=1&q={1}"" class=""btn btn-sm me-1"" style=""background:var(--color-success-bg);color:var(--color-success);border:0;text-decoration:none;display:inline-block;"" title=""Aktif yap""><i class=""bi bi-toggle-off""></i></a>", u.UserId, Server.UrlEncode(SearchTerm));
                    }
                }
                else
                {
                    actionButton = "<span class=\"text-muted\" style=\"font-size:12px;\">-</span>";
                }

                sb.AppendFormat(@"
                <tr>
                    <td style=""padding:14px 16px;color:var(--color-text-muted);"">{0}</td>
                    <td>
                        <div style=""display:flex;align-items:center;gap:10px;"">
                            <div style=""width:36px;height:36px;border-radius:50%;background:var(--color-primary-light);color:var(--color-primary);display:flex;align-items:center;justify-content:center;font-weight:500;"">{1}</div>
                            {2}
                        </div>
                    </td>
                    <td>{3}</td>
                    <td>{4}</td>
                    <td>{5:dd MMM yyyy}</td>
                    <td>{6}</td>
                    <td>{7}</td>
                </tr>",
                    index++, E(initial), E(u.FullName), E(u.Email), roleBadge, u.CreatedAt, statusBadge, actionButton);
            }

            UsersTableHtml = sb.ToString();
        }

        private class UserModel
        {
            public int UserId { get; set; }
            public string FullName { get; set; }
            public string Email { get; set; }
            public string RoleName { get; set; }
            public bool IsActive { get; set; }
            public DateTime CreatedAt { get; set; }
        }

        private static string E(string value)
            => HttpUtility.HtmlEncode(value ?? string.Empty);
    }
}
