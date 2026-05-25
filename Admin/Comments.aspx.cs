using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.UI;
using EduFlow.DAL;

namespace EduFlow.Admin
{
    public partial class Comments : Page
    {
        protected string PendingHtml       { get; private set; }
        protected string ApprovedHtml      { get; private set; }
        protected int    PendingCount      { get; private set; }
        protected int    ApprovedCount     { get; private set; }
        protected int    RejectedCount     { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Güvenlik: Admin rolü kontrolü
            if (Session["UserId"] == null || Session["UserRole"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            // Onayla / Sil işlemleri
            if (int.TryParse(Request.QueryString["approve"], out var approveId))
            {
                TryExecute("sp_ApproveReview", cmd => cmd.Parameters.AddWithValue("@ReviewId", approveId));
                Response.Redirect("~/Admin/Comments.aspx");
                return;
            }
            if (int.TryParse(Request.QueryString["delete"], out var deleteId))
            {
                TryExecute("sp_DeleteReview", cmd => cmd.Parameters.AddWithValue("@ReviewId", deleteId));
                Response.Redirect("~/Admin/Comments.aspx");
                return;
            }

            try
            {
                LoadPendingReviews();
                LoadApprovedReviews();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Comments yükleme hatası: " + ex.Message);
                PendingHtml  = "<p class=\"text-muted text-center\">Bağlantı hatası.</p>";
                ApprovedHtml = "<tr><td colspan='6' class='text-center text-muted'>Veriler yüklenemedi.</td></tr>";
            }
        }

        private void LoadPendingReviews()
        {
            var sb = new StringBuilder();
            using (var conn = Db.OpenConnection())
            using (var cmd  = Db.StoredProcedure("sp_GetPendingReviews", conn))
            using (var r    = cmd.ExecuteReader())
            {
                while (r.Read())
                {
                    PendingCount++;
                    int    reviewId  = Convert.ToInt32(r["ReviewId"]);
                    string fullName  = r["FullName"].ToString();
                    string course    = r["CourseTitle"].ToString();
                    int    rating    = Convert.ToInt32(r["Rating"]);
                    string comment   = r["Comment"].ToString();
                    string initials  = BuildInitials(fullName);
                    string stars     = BuildStars(rating);

                    sb.Append("<div class=\"plain-card mb-3\">");
                    sb.Append("<div class=\"review-header mb-2\">");
                    sb.Append("<div class=\"reviewer-avatar\">" + E(initials) + "</div>");
                    sb.Append("<div class=\"reviewer-info\">");
                    sb.Append("<div class=\"reviewer-name\">" + E(fullName) + "</div>");
                    sb.Append("<div class=\"review-date\"><i class=\"bi bi-collection-play\"></i> " + E(course) + "</div>");
                    sb.Append("</div>");
                    sb.Append("<div class=\"ms-auto d-flex gap-2\">");
                    sb.AppendFormat("<a href=\"Comments.aspx?approve={0}\" class=\"btn btn-sm\" style=\"background:var(--color-success-bg);color:var(--color-success);border:0;padding:6px 14px;text-decoration:none;\"><i class=\"bi bi-check-lg\"></i> Onayla</a>", reviewId);
                    sb.AppendFormat("<a href=\"Comments.aspx?delete={0}\" class=\"btn btn-sm\" style=\"background:var(--color-danger-bg);color:var(--color-danger);border:0;padding:6px 14px;text-decoration:none;\" onclick=\"return confirm('Bu yorumu silmek istediğinizden emin misiniz?');\"><i class=\"bi bi-x-lg\"></i> Reddet</a>", reviewId);
                    sb.Append("</div></div>");
                    sb.Append("<div style=\"display:flex;gap:2px;margin-bottom:6px;\">" + stars + "</div>");
                    sb.Append("<p class=\"review-comment\">\"" + E(comment) + "\"</p>");
                    sb.Append("</div>");
                }
            }

            if (PendingCount == 0)
                sb.Append("<p class=\"text-muted text-center\" style=\"padding:20px;\">Bekleyen yorum yok.</p>");

            PendingHtml = sb.ToString();
        }

        private void LoadApprovedReviews()
        {
            var sb = new StringBuilder();
            using (var conn = Db.OpenConnection())
            using (var cmd  = new SqlCommand(
                @"SELECT r.ReviewId, u.FullName, c.Title AS CourseTitle,
                         r.Rating, r.Comment, r.CreatedAt
                  FROM Reviews r
                  JOIN Users u   ON u.UserId   = r.UserId
                  JOIN Courses c ON c.CourseId = r.CourseId
                  WHERE r.IsApproved = 1
                  ORDER BY r.CreatedAt DESC", conn))
            using (var r = cmd.ExecuteReader())
            {
                while (r.Read())
                {
                    ApprovedCount++;
                    int    reviewId = Convert.ToInt32(r["ReviewId"]);
                    string name     = r["FullName"].ToString();
                    string course   = r["CourseTitle"].ToString();
                    int    rating   = Convert.ToInt32(r["Rating"]);
                    string comment  = r["Comment"].ToString();
                    string date     = Convert.ToDateTime(r["CreatedAt"]).ToString("dd MMM yyyy",
                                         new System.Globalization.CultureInfo("tr-TR"));
                    string stars    = BuildStarsText(rating);

                    sb.AppendFormat(@"
<tr>
  <td style=""padding:12px 16px;"">{0}</td>
  <td>{1}</td>
  <td><span style=""color:var(--color-accent)"">{2}</span></td>
  <td style=""max-width:220px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"">{3}</td>
  <td>{4}</td>
  <td>
    <a href=""Comments.aspx?delete={5}"" class=""btn btn-sm""
       style=""background:var(--color-danger-bg);color:var(--color-danger);border:0;""
       onclick=""return confirm('Bu yorumu silmek istediğinizden emin misiniz?');"">
      <i class=""bi bi-trash""></i>
    </a>
  </td>
</tr>", E(name), E(course), stars, E(comment), date, reviewId);
                }
            }

            if (ApprovedCount == 0)
                sb.Append("<tr><td colspan='6' class='text-center text-muted' style='padding:20px;'>Onaylı yorum yok.</td></tr>");

            ApprovedHtml = sb.ToString();
        }

        private static void TryExecute(string sp, Action<SqlCommand> configure)
        {
            try
            {
                using (var conn = Db.OpenConnection())
                using (var cmd  = Db.StoredProcedure(sp, conn))
                {
                    configure(cmd);
                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(sp + " hatası: " + ex.Message);
            }
        }

        private static string BuildInitials(string name)
        {
            var parts = name.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            return parts.Length >= 2
                ? (parts[0].Substring(0, 1) + parts[1].Substring(0, 1)).ToUpper()
                : name.Substring(0, Math.Min(2, name.Length)).ToUpper();
        }

        private static string BuildStars(int rating)
        {
            var sb = new StringBuilder();
            for (int i = 0; i < rating; i++)
                sb.Append("<i class=\"bi bi-star-fill\" style=\"color:var(--color-accent)\"></i>");
            for (int i = rating; i < 5; i++)
                sb.Append("<i class=\"bi bi-star\" style=\"color:#D0D7E0\"></i>");
            return sb.ToString();
        }

        private static string BuildStarsText(int rating)
        {
            return new string('★', rating) + new string('☆', 5 - rating);
        }

        private static string E(string value)
            => HttpUtility.HtmlEncode(value ?? string.Empty);
    }
}
