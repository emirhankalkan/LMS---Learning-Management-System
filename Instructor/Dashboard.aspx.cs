using System;
using System.Text;
using System.Web;
using System.Web.UI;
using EduFlow.DAL;

namespace EduFlow.Instructor
{
    public partial class Dashboard : Page
    {
        protected string          FullName            { get; private set; }
        protected InstructorStats Stats               { get; private set; } = new InstructorStats();
        protected string          CoursesPreviewHtml  { get; private set; }
        protected string          RecentActivityHtml  { get; private set; }

        private readonly InstructorDAL _dal = new InstructorDAL();

        protected void Page_Load(object sender, EventArgs e)
        {
            int userId  = Convert.ToInt32(Session["UserId"]);
            FullName    = Session["FullName"]?.ToString() ?? "Eğitmen";

            try
            {
                Stats = _dal.GetDashboard(userId);

                // Kurs önizleme tablosu (max 5)
                var courses = _dal.GetMyCourses(userId);
                var sb = new StringBuilder();
                int count = 0;
                foreach (var c in courses)
                {
                    if (count++ >= 5) break;
                    sb.AppendFormat(@"<tr>
                        <td style=""padding:12px 16px;"">
                            <a href=""MyCourses.aspx"" style=""font-weight:500;text-decoration:none;"">{0}</a>
                            <div style=""font-size:12px;color:var(--color-text-muted);""><span class=""badge-level"">{1}</span></div>
                        </td>
                        <td>{2}</td>
                        <td><span style=""color:var(--color-accent)"">★ {3:F1}</span></td>
                        <td>₺{4:N0}</td>
                    </tr>",
                        E(c.Title), E(c.Level), c.EnrollmentCount, c.AverageRating, c.CourseRevenue);
                }
                if (count == 0)
                    sb.Append("<tr><td colspan='4' class='text-center text-muted' style='padding:20px;'>Henüz kurs eklemediniz. <a href='AddCourse.aspx'>İlk kursunuzu ekleyin →</a></td></tr>");
                CoursesPreviewHtml = sb.ToString();

                // Son aktivite
                var activity = _dal.GetRecentActivity(userId);
                var sb2 = new StringBuilder();
                if (activity.Count == 0)
                {
                    sb2.Append("<p class=\"text-muted\" style=\"font-size:14px;\">Henüz kayıt yok.</p>");
                }
                foreach (var a in activity)
                {
                    string initials = a.FullName.Length >= 2 ? a.FullName.Substring(0, 2).ToUpper() : a.FullName.ToUpper();
                    sb2.AppendFormat(@"
                    <div style=""display:flex;align-items:center;gap:12px;padding:10px 0;border-bottom:1px solid var(--color-border);"">
                        <div style=""width:36px;height:36px;border-radius:50%;background:rgba(93,240,193,.15);color:#5DF0C1;display:flex;align-items:center;justify-content:center;font-weight:600;font-size:12px;flex-shrink:0;"">{0}</div>
                        <div>
                            <div style=""font-size:13px;font-weight:500;"">{1}</div>
                            <div style=""font-size:12px;color:var(--color-text-muted);""><i class=""bi bi-collection-play""></i> {2}</div>
                        </div>
                        <div style=""margin-left:auto;font-size:11px;color:var(--color-text-muted);white-space:nowrap;"">{3:dd MMM}</div>
                    </div>",
                        E(initials), E(a.FullName), E(a.CourseTitle), a.EnrolledAt);
                }
                RecentActivityHtml = sb2.ToString();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Instructor Dashboard hatası: " + ex.Message);
                CoursesPreviewHtml = "<tr><td colspan='4' class='text-center text-muted'>Veriler yüklenemedi.</td></tr>";
                RecentActivityHtml = "<p class='text-muted'>Bağlantı hatası.</p>";
            }
        }

        private static string E(string value)
            => HttpUtility.HtmlEncode(value ?? string.Empty);
    }
}
