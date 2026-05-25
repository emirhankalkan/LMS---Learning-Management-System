using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.UI;
using EduFlow.DAL;
using EduFlow.Models;

namespace EduFlow
{
    public partial class CourseDetail : Page
    {
        protected Course Course        { get; private set; }
        protected string LessonsHtml   { get; private set; }
        protected string ReviewsHtml   { get; private set; }
        protected string StarsHtml     { get; private set; }
        protected string WillLearnHtml { get; private set; }
        protected string PreviewVideoUrl { get; private set; }

        private readonly CourseDAL _dal = new CourseDAL();

        private static readonly string[] _willLearnItems = new[]
        {
            "Konuya hakim olarak sıfırdan başla, uzmanlık düzeyine ulaş",
            "Gerçek dünya projeleri geliştir ve portföyüne ekle",
            "Endüstri standartlarında kod yazma becerisi kazan",
            "Sorunları tespit et ve debug etmeyi öğren",
            "Takım çalışmasına uygun, okunabilir kod üret",
            "Tamamlama sertifikasıyla kariyerinde fark yarat"
        };

        protected void Page_Load(object sender, EventArgs e)
        {
            int.TryParse(Request.QueryString["id"], out var id);

            try
            {
                Course = _dal.GetCourseDetail(id);
                if (Course == null && id > 0)
                    Response.Redirect("~/Courses.aspx");
                if (Course == null)
                    Course = _dal.GetFeaturedCourses().Count > 0
                             ? _dal.GetFeaturedCourses()[0]
                             : null;

                var lessons = Course != null ? _dal.GetLessonsByCourse(Course.CourseId) : new List<Lesson>();
                var reviews = Course != null ? _dal.GetApprovedReviews(Course.CourseId) : new List<Review>();

                LessonsHtml = BuildLessons(lessons);
                ReviewsHtml = BuildReviews(reviews);
                PreviewVideoUrl = GetPreviewVideoUrl(lessons);
            }
            catch
            {
                // fallback SampleData
                Course        = Services.SampleData.FindCourse(id) ?? Services.SampleData.Courses[0];
                var fallbackLessons = Services.SampleData.LessonsFor(Course.CourseId);
                LessonsHtml   = BuildLessons(fallbackLessons);
                ReviewsHtml   = BuildReviews(Services.SampleData.ReviewsFor(Course.CourseId));
                PreviewVideoUrl = GetPreviewVideoUrl(fallbackLessons);
            }

            if (Course != null) Title = Course.Title;
            StarsHtml     = Course != null ? BuildStars(Course.AverageRating) : "";
            WillLearnHtml = BuildWillLearn();
        }

        private static string GetPreviewVideoUrl(IEnumerable<Lesson> lessons)
        {
            foreach (var lesson in lessons)
            {
                if (lesson.IsPreview && !string.IsNullOrEmpty(lesson.VideoUrl))
                    return lesson.VideoUrl;
            }

            return "https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr";
        }

        private static string BuildLessons(IEnumerable<Lesson> lessons)
        {
            var sb = new StringBuilder();
            foreach (var l in lessons)
            {
                var title = E(l.Title);
                string preview = l.IsPreview
                    ? "<span class=\"lesson-preview-tag\"><i class=\"bi bi-eye\"></i> Önizleme</span>"
                    : "";
                sb.AppendFormat(@"
<div class=""lesson-row"">
  <div class=""lesson-num"">{0}</div>
  <div class=""lesson-info"">
    <div class=""lesson-title""><i class=""bi bi-play-circle"" style=""color:var(--color-primary);margin-right:6px""></i>{1}{2}</div>
    <div class=""lesson-meta""><i class=""bi bi-clock""></i> {3} dakika</div>
  </div>
  <div class=""lesson-duration"">{3} dk</div>
</div>", l.OrderIndex, title, preview, l.Duration);
            }
            return sb.ToString();
        }

        private static string BuildReviews(IEnumerable<Review> reviews)
        {
            var sb = new StringBuilder();
            foreach (var r in reviews)
            {
                string name = r.FullName ?? "Kullanıcı";
                string safeName = E(name);
                string safeComment = E(r.Comment);
                string parts = name.Split(' ').Length >= 2
                    ? name.Split(' ')[0].Substring(0,1).ToUpper() + name.Split(' ')[1].Substring(0,1).ToUpper()
                    : name.Substring(0,1).ToUpper();

                sb.AppendFormat(@"
<div class=""review-card"">
  <div class=""review-header"">
    <div class=""reviewer-avatar"">{0}</div>
    <div class=""reviewer-info"">
      <div class=""reviewer-name"">{1}</div>
      <div class=""review-date""><i class=""bi bi-calendar3""></i> {2}</div>
    </div>
    <div class=""ms-auto"">{3}</div>
  </div>
  <p class=""review-comment"">{4}</p>
</div>",
                    E(parts), safeName,
                    r.CreatedAt.ToString("dd MMMM yyyy", new System.Globalization.CultureInfo("tr-TR")),
                    BuildStars(r.Rating), safeComment);
            }
            return sb.ToString();
        }

        private static string BuildWillLearn()
        {
            var sb = new StringBuilder();
            foreach (var item in _willLearnItems)
                sb.AppendFormat(@"
<div class=""col-md-6"">
  <div style=""display:flex;gap:10px;align-items:flex-start;font-size:14px;color:var(--color-text-secondary);"">
    <i class=""bi bi-check-circle-fill"" style=""color:var(--color-success);font-size:16px;flex-shrink:0;margin-top:3px;""></i>
    <span>{0}</span>
  </div>
</div>", E(item));
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
    }
}
