using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.UI;
using EduFlow.DAL;
using EduFlow.Models;

namespace EduFlow
{
    public partial class Courses : Page
    {
        protected string CoursesHtml       { get; private set; }
        protected string CategoryOptionsHtml{ get; private set; }
        protected string SearchTerm        { get; private set; }
        protected string SelectedLevel     { get; private set; }
        protected int    TotalCount        { get; private set; }

        private readonly CourseDAL _dal = new CourseDAL();

        protected void Page_Load(object sender, EventArgs e)
        {
            Form.Method = "get";
            SearchTerm    = Request.QueryString["q"] ?? string.Empty;
            SelectedLevel = Request.QueryString["level"] ?? string.Empty;
            int.TryParse(Request.QueryString["category"], out var selectedCategory);

            List<Course> courses;
            List<Category> categories;

            try
            {
                courses    = _dal.SearchCourses(SearchTerm, selectedCategory, SelectedLevel);
                categories = _dal.GetAllCategories();
            }
            catch
            {
                // fallback
                courses    = Services.SampleData.SearchCourses(SearchTerm, selectedCategory);
                categories = Services.SampleData.Categories;
            }

            TotalCount          = courses.Count;
            CategoryOptionsHtml = BuildCategoryOptions(categories, selectedCategory);
            CoursesHtml         = BuildCourseCards(courses);
        }

        private static string BuildCategoryOptions(List<Category> cats, int selected)
        {
            var sb = new StringBuilder("<option value=\"\">Tüm kategoriler</option>");
            foreach (var c in cats)
                sb.AppendFormat("<option value=\"{0}\" {1}>{2}</option>",
                    c.CategoryId, c.CategoryId == selected ? "selected" : "", E(c.Name));
            return sb.ToString();
        }

        private static string BuildCourseCards(List<Course> courses)
        {
            if (courses.Count == 0)
                return @"<div class=""col-12"">
                    <div class=""plain-card p-5 text-center"">
                        <i class=""bi bi-search"" style=""font-size:3rem;color:var(--color-text-muted)""></i>
                        <h3 class=""mt-3"" style=""color:var(--color-text-secondary)"">Sonuç bulunamadı</h3>
                        <p class=""text-muted"">Farklı anahtar kelimeler deneyin veya filtreleri temizleyin.</p>
                        <a class=""btn btn-primary-custom"" href=""Courses.aspx"">Tüm kursları gör</a>
                    </div>
                </div>";

            var sb = new StringBuilder();
            foreach (var c in courses)
            {
                var thumb = A(c.ThumbnailUrl);
                var title = E(c.Title);
                var level = E(c.Level);
                var category = E(c.CategoryName);
                var instructor = E(c.InstructorName);
                string stars      = BuildStars(c.AverageRating);
                string priceBadge = c.IsFree ? "<span class=\"badge-free\">Ücretsiz</span>"
                                  : (c.IsFeatured ? "<span class=\"badge-featured\">Öne Çıkan</span>" : "");
                string price      = c.IsFree ? "<span class=\"course-price free\">Ücretsiz</span>"
                                  : $"<span class=\"course-price\">₺{c.Price:N0}</span>";

                sb.AppendFormat(@"
<div class=""col-md-6 col-lg-4"">
  <article class=""course-card"">
    <div class=""card-thumb"">
      <img src=""{0}"" alt=""{1}"" loading=""lazy"" />
      <div class=""card-badges"">{2}<span class=""badge-level"">{3}</span></div>
    </div>
    <div class=""card-body"">
      <p class=""course-meta mb-1"">{4} &bull; {5} &bull; {6} ders &bull; {7}s</p>
      <h3 class=""course-title"">{1}</h3>
      <div class=""course-rating"">
        {8}
        <span style=""color:var(--color-accent);font-weight:500;font-size:13px;margin-left:4px"">{9:F1}</span>
        <span class=""rating-count"">({10:N0})</span>
      </div>
      <div class=""course-card-footer"">
        {11}
        <a class=""btn btn-primary-custom btn-sm"" href=""CourseDetail.aspx?id={12}"">İncele</a>
      </div>
    </div>
  </article>
</div>",
                    thumb, title, priceBadge, level,
                    category, instructor, c.LessonCount, c.TotalHours,
                    stars, c.AverageRating, c.EnrollmentCount, price, c.CourseId);
            }
            return sb.ToString();
        }

        private static string BuildStars(double rating)
        {
            var sb   = new StringBuilder();
            int full = (int)Math.Floor(rating);
            bool half = (rating - full) >= 0.5;
            for (int i = 0; i < full; i++) sb.Append("<i class=\"bi bi-star-fill\" style=\"color:var(--color-accent)\"></i>");
            if (half) sb.Append("<i class=\"bi bi-star-half\" style=\"color:var(--color-accent)\"></i>");
            int empty = 5 - full - (half ? 1 : 0);
            for (int i = 0; i < empty; i++) sb.Append("<i class=\"bi bi-star\" style=\"color:#D0D7E0\"></i>");
            return sb.ToString();
        }

        private static string E(string value)
            => HttpUtility.HtmlEncode(value ?? string.Empty);

        private static string A(string value)
            => HttpUtility.HtmlAttributeEncode(value ?? string.Empty);
    }
}
