using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.UI;
using EduFlow.DAL;
using EduFlow.Models;

namespace EduFlow
{
    public partial class _Default : Page
    {
        protected string FeaturedCoursesHtml { get; private set; }
        protected string FreeCoursesHtml     { get; private set; }
        protected string CategoryCardsHtml   { get; private set; }
        protected string ContinuePanelHtml   { get; private set; }

        private readonly CourseDAL _dal = new CourseDAL();

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                FeaturedCoursesHtml = BuildCourseCards(_dal.GetFeaturedCourses());
                FreeCoursesHtml     = BuildCourseCards(_dal.GetFreeCourses());
                CategoryCardsHtml   = BuildCategoryCards(_dal.GetAllCategories());
                ContinuePanelHtml   = BuildContinuePanel();
            }
            catch (Exception ex)
            {
                // DB bağlantısı yoksa SampleData ile fallback
                FeaturedCoursesHtml = BuildCourseCards(Services.SampleData.GetFeaturedCourses());
                FreeCoursesHtml     = BuildCourseCards(Services.SampleData.Courses.FindAll(c => c.IsFree));
                CategoryCardsHtml   = BuildCategoryCardsFallback();
                ContinuePanelHtml   = BuildEmptyContinuePanel();
                System.Diagnostics.Debug.WriteLine("DB hatası, SampleData kullanılıyor: " + ex.Message);
            }
        }

        private string BuildContinuePanel()
        {
            if (Session["UserId"] == null)
                return "";

            Lesson lesson = null;
            try { lesson = _dal.GetLastWatchedLesson(Convert.ToInt32(Session["UserId"])); }
            catch { }

            if (lesson == null)
                return BuildEmptyContinuePanel();

            var progress = Math.Max(0, Math.Min(100, lesson.CourseProgressPercent));
            return string.Format(@"
<div class=""hero-panel"">
    <div class=""hero-panel-header"">
        <span>Kaldığın yer</span>
        <strong>{0}</strong>
    </div>
    <div class=""hero-progress"">
        <div class=""d-flex justify-content-between"">
            <span>{1}/{2} ders tamamlandı</span>
            <strong>{3}%</strong>
        </div>
        <div class=""progress""><div class=""progress-bar"" style=""width:{3}%""></div></div>
    </div>
    <div class=""hero-panel-row"">
        <i class=""bi bi-play-circle""></i>
        <div>
            <strong>Son izlenen ders</strong>
            <span>{4}</span>
        </div>
    </div>
    <div class=""hero-panel-row"">
        <i class=""bi bi-clock-history""></i>
        <div>
            <strong>Hemen devam et</strong>
            <span>{5}. dersten kaldığın yerden açılır</span>
        </div>
    </div>
    <a class=""btn btn-primary-custom w-100 mt-4"" href=""LessonWatch.aspx?courseId={6}&lessonId={7}"">
        <i class=""bi bi-play-circle""></i> Kaldığın Yerden Devam Et
    </a>
</div>",
                E(lesson.CourseTitle),
                lesson.CompletedLessons,
                lesson.TotalLessons,
                progress,
                E(lesson.Title),
                lesson.OrderIndex,
                lesson.CourseId,
                lesson.LessonId);
        }

        private static string BuildEmptyContinuePanel()
        {
            return @"
<div class=""hero-panel"">
    <div class=""hero-panel-header"">
        <span>Öğrenmeye hazır</span>
        <strong>Kursa başlayınca burada devam butonun görünür</strong>
    </div>
    <div class=""hero-panel-row"">
        <i class=""bi bi-collection-play""></i>
        <div>
            <strong>Kayıtlı kurslarını aç</strong>
            <span>İzlediğin son ders otomatik hatırlanır</span>
        </div>
    </div>
    <div class=""hero-panel-row"">
        <i class=""bi bi-graph-up-arrow""></i>
        <div>
            <strong>İlerlemeni takip et</strong>
            <span>Dersleri tamamladıkça panel güncellenir</span>
        </div>
    </div>
    <a class=""btn btn-primary-custom w-100 mt-4"" href=""Dashboard.aspx"">
        <i class=""bi bi-grid""></i> Kurslarıma Git
    </a>
</div>";
        }

        private static string BuildCourseCards(List<Course> courses)
        {
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

        private static string BuildCategoryCards(List<Category> categories)
        {
            var sb = new StringBuilder();
            foreach (var cat in categories)
                sb.AppendFormat(@"
<div class=""col-6 col-lg-4"">
  <a class=""category-card"" href=""Courses.aspx?category={0}"">
    <span class=""category-icon""><i class=""bi {1}""></i></span>
    <div class=""cat-info"">
      <span class=""cat-name"">{2}</span>
      <span class=""cat-count"">{3} kurs</span>
    </div>
  </a>
</div>", cat.CategoryId, A(cat.IconClass), E(cat.Name), cat.CourseCount);
            return sb.ToString();
        }

        private static string BuildCategoryCardsFallback()
        {
            var sb = new StringBuilder();
            foreach (var cat in Services.SampleData.Categories)
            {
                int count = Services.SampleData.Courses.FindAll(c => c.CategoryId == cat.CategoryId).Count;
                sb.AppendFormat(@"
<div class=""col-6 col-lg-4"">
  <a class=""category-card"" href=""Courses.aspx?category={0}"">
    <span class=""category-icon""><i class=""bi {1}""></i></span>
    <div class=""cat-info"">
      <span class=""cat-name"">{2}</span>
      <span class=""cat-count"">{3} kurs</span>
    </div>
  </a>
</div>", cat.CategoryId, A(cat.IconClass), E(cat.Name), count);
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
