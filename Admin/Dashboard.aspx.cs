using System;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using EduFlow.DAL;

namespace EduFlow.Admin
{
    public partial class Dashboard : Page
    {
        protected int TotalUsers            { get; private set; }
        protected int TotalCourses          { get; private set; }
        protected int TotalOrders            { get; private set; }
        protected string TotalRevenue       { get; private set; }
        protected int PendingReviews        { get; private set; }
        protected string CoursesTableHtml   { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Güvenlik: Admin rolü kontrolü
            if (Session["UserId"] == null || Session["UserRole"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            try
            {
                // 1. İstatistikleri DB'den Çek
                using (var conn = Db.OpenConnection())
                using (var cmd = Db.StoredProcedure("sp_GetAdminStats", conn))
                using (var r = cmd.ExecuteReader())
                {
                    if (r.Read())
                    {
                        TotalUsers = Convert.ToInt32(r["TotalUsers"]);
                        TotalCourses = Convert.ToInt32(r["TotalCourses"]);
                        TotalOrders = Convert.ToInt32(r["TotalOrders"]);
                        TotalRevenue = "₺" + Convert.ToDecimal(r["TotalRevenue"]).ToString("N0");
                        PendingReviews = Convert.ToInt32(r["PendingReviews"]);
                    }
                }

                // 2. Son Kursları DB'den Çek (Önizleme)
                var courses = new CourseDAL().GetAllCourses().Take(4).ToList();
                var sb = new StringBuilder();
                foreach (var c in courses)
                {
                    sb.AppendFormat(@"
                    <tr>
                        <td><a href=""../CourseDetail.aspx?id={0}"">{1}</a></td>
                        <td><span class=""badge-level"">{2}</span></td>
                        <td>{3}</td>
                        <td>{4}</td>
                        <td>{5}</td>
                        <td>{6:N0}</td>
                        <td><span style=""color:var(--color-accent)"">★ {7:F1}</span></td>
                    </tr>",
                        c.CourseId, E(c.Title), E(c.CategoryName), E(c.InstructorName),
                        E(c.Level), c.IsFree ? "Ücretsiz" : "₺" + c.Price.ToString("N0"),
                        c.EnrollmentCount, c.AverageRating);
                }
                CoursesTableHtml = sb.ToString();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Admin Dashboard hatası: " + ex.Message);
                
                // Fallback / Default Değerler
                TotalUsers = 3;
                TotalCourses = Services.SampleData.Courses.Count;
                TotalOrders = 0;
                TotalRevenue = "₺0";
                PendingReviews = 0;
                CoursesTableHtml = "<tr><td colspan='7' class='text-center text-muted'>Veritabanı bağlantı hatası nedeniyle veriler yüklenemedi.</td></tr>";
            }
        }

        private static string E(string value)
            => HttpUtility.HtmlEncode(value ?? string.Empty);
    }
}
