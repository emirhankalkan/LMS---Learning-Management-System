using System;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using EduFlow.DAL;
using EduFlow.Services;

namespace EduFlow.Admin
{
    public partial class Courses : Page
    {
        protected string CoursesTableHtml { get; private set; }
        protected int    TotalCoursesCount { get; private set; }
        protected string SearchTerm        { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Güvenlik: Admin rolü kontrolü
            if (Session["UserId"] == null || Session["UserRole"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            SearchTerm = Request.QueryString["q"] ?? "";

            try
            {
                var dal     = new CourseDAL();
                var courses = dal.GetAllCourses();

                // Arama filtresi
                if (!string.IsNullOrEmpty(SearchTerm))
                {
                    courses = courses.FindAll(c =>
                        c.Title.IndexOf(SearchTerm, StringComparison.OrdinalIgnoreCase) >= 0 ||
                        c.InstructorName.IndexOf(SearchTerm, StringComparison.OrdinalIgnoreCase) >= 0 ||
                        c.CategoryName.IndexOf(SearchTerm, StringComparison.OrdinalIgnoreCase) >= 0
                    );
                }

                TotalCoursesCount = courses.Count;

                var sb = new StringBuilder();
                int index = 1;
                foreach (var c in courses)
                {
                    string priceText  = c.IsFree ? "<span class=\"badge-free\">Ücretsiz</span>"
                                                 : "<strong>₺" + c.Price.ToString("N0") + "</strong>";
                    string levelBadge = "<span class=\"badge-level\">" + E(c.Level) + "</span>";
                    string featBadge  = c.IsFeatured
                                        ? "<span class=\"badge-featured\" style=\"font-size:11px;\"><i class=\"bi bi-star-fill\"></i></span>"
                                        : "";

                    sb.AppendFormat(@"
                    <tr>
                        <td style=""padding:12px 16px;color:var(--color-text-muted);"">{0}</td>
                        <td>
                            <a href=""../CourseDetail.aspx?id={1}"" style=""font-weight:500;text-decoration:none;"">
                                {2}
                            </a> {3}
                        </td>
                        <td>{4}</td>
                        <td>{5}</td>
                        <td>{6}</td>
                        <td>{7}</td>
                        <td><span style=""color:var(--color-accent)"">★ {8:F1}</span></td>
                        <td><span style=""color:var(--color-text-muted);font-size:13px;"">{9:N0} öğrenci</span></td>
                    </tr>",
                        index++, c.CourseId, E(c.Title), featBadge,
                        E(c.CategoryName), E(c.InstructorName), levelBadge,
                        priceText, c.AverageRating, c.EnrollmentCount);
                }

                CoursesTableHtml = sb.ToString();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Admin Courses hatası: " + ex.Message);

                // Fallback: SampleData
                var courses = Services.SampleData.Courses;
                TotalCoursesCount = courses.Count;
                var sb = new StringBuilder();
                int i = 1;
                foreach (var c in courses)
                {
                    sb.AppendFormat("<tr><td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td><td>{4}</td><td>{5}</td><td>-</td><td>-</td></tr>",
                        i++, E(c.Title), E(c.CategoryName), E(c.InstructorName), E(c.Level),
                        c.IsFree ? "Ücretsiz" : "₺" + c.Price.ToString("N0"));
                }
                CoursesTableHtml = sb.ToString();
            }
        }

        private static string E(string value)
            => HttpUtility.HtmlEncode(value ?? string.Empty);
    }
}
