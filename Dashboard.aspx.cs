using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using EduFlow.DAL;
using EduFlow.Models;

namespace EduFlow
{
    public partial class Dashboard : Page
    {
        protected string EnrolledCoursesHtml { get; private set; }
        protected string SuggestedHtml        { get; private set; }
        protected string UserName            { get; private set; }

        protected int EnrolledCount          { get; private set; }
        protected int CompletedCount         { get; private set; }
        protected string DurationText        { get; private set; }
        protected int CertificateCount       { get; private set; }

        private readonly CourseDAL _courseDal = new CourseDAL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            int userId = Convert.ToInt32(Session["UserId"]);
            UserName = Session["FullName"]?.ToString()?.Split(' ')[0] ?? "Öğrenci";

            List<Course> enrolledCourses;
            try
            {
                enrolledCourses = _courseDal.GetUserDashboard(userId);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Dashboard DB hatası: " + ex.Message);
                enrolledCourses = new List<Course>(); // fallback to empty
            }

            EnrolledCount = enrolledCourses.Count;
            CompletedCount = enrolledCourses.Sum(c => c.CompletedLessons);
            DurationText = (CompletedCount * 0.5).ToString("F1") + "s"; // her ders ortalama 30 dk varsayıldı
            CertificateCount = enrolledCourses.Count(c => c.LessonCount > 0 && c.CompletedLessons >= c.LessonCount);

            EnrolledCoursesHtml = BuildEnrolledCourses(enrolledCourses);
            SuggestedHtml = BuildSuggested(enrolledCourses.Select(c => c.CourseId).ToList());
        }

        private static string BuildEnrolledCourses(List<Course> courses)
        {
            if (courses.Count == 0)
            {
                return @"
                <div class=""col-12"">
                    <div class=""plain-card p-5 text-center"">
                        <i class=""bi bi-journal-bookmark-fill"" style=""font-size:3rem;color:var(--color-text-muted)""></i>
                        <h3 class=""mt-3"" style=""color:var(--color-text-secondary)"">Henüz hiçbir kursa kayıtlı değilsiniz</h3>
                        <p class=""text-muted"">Udemy kalitesindeki harika kurslarımızı keşfedip hemen öğrenmeye başlayın.</p>
                        <a href=""Courses.aspx"" class=""btn btn-primary-custom mt-2"">Kursları Keşfet</a>
                    </div>
                </div>";
            }

            var builder = new StringBuilder();
            foreach (var course in courses)
            {
                var thumb = A(course.ThumbnailUrl);
                var title = E(course.Title);
                var category = E(course.CategoryName);
                var instructor = E(course.InstructorName);
                int total = course.LessonCount > 0 ? course.LessonCount : 10;
                int completed = course.CompletedLessons;
                int progress = (completed * 100) / total;
                if (progress > 100) progress = 100;

                string buttonHtml = progress == 100
                    ? @"<a class=""btn btn-success btn-sm flex-grow-1"" href=""#"" onclick=""alert('Sertifikanız başarıyla oluşturuldu!'); return false;""><i class=""bi bi-award""></i> Sertifikayı Al</a>"
                    : string.Format(@"<a class=""btn btn-primary-custom btn-sm flex-grow-1"" href=""LessonWatch.aspx?courseId={0}""><i class=""bi bi-play-circle""></i> Derse Devam Et</a>", course.CourseId);

                builder.AppendFormat(@"
                <div class=""col-md-6"">
                  <div class=""enrolled-card"" style=""display:flex;background:var(--color-surface);border:1px solid var(--color-border);border-radius:var(--radius-md);overflow:hidden;margin-bottom:16px;box-shadow:var(--shadow-sm);"">
                    <img src=""{0}"" alt=""{1}"" style=""width:160px;height:120px;object-fit:cover;"" />
                    <div class=""enrolled-card-body"" style=""padding:14px;flex-grow:1;display:flex;flex-direction:column;justify-content:space-between;"">
                      <div>
                        <p class=""enrolled-card-meta"" style=""font-size:12px;color:var(--color-text-muted);margin:0 0 4px;"">{2} &bull; {3}</p>
                        <h3 class=""enrolled-card-title"" style=""font-size:15px;font-weight:600;margin:0 0 8px;line-height:1.4;"">{1}</h3>
                      </div>
                      <div>
                        <div class=""progress-label"" style=""display:flex;justify-content:space-between;font-size:12px;color:var(--color-text-secondary);margin-bottom:4px;"">
                          <span>{4}/{5} ders tamamlandı</span>
                          <strong>{6}%</strong>
                        </div>
                        <div class=""progress mb-2"" style=""height:6px;background:var(--color-border);border-radius:3px;overflow:hidden;"">
                            <div class=""progress-bar"" style=""width:{6}%;height:100%;background:var(--color-primary);transition:width 0.4s ease;""></div>
                        </div>
                        <div class=""d-flex gap-2"" style=""gap:8px;"">
                          {7}
                          <a class=""btn btn-outline-custom btn-sm"" href=""CourseDetail.aspx?id={8}"" title=""Kurs Detayları"" style=""padding:4px 8px;"">
                            <i class=""bi bi-info-circle""></i>
                          </a>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>",
                    thumb, title, category, instructor,
                    completed, total, progress, buttonHtml, course.CourseId);
            }
            return builder.ToString();
        }

        private string BuildSuggested(List<int> enrolledIds)
        {
            var builder = new StringBuilder();
            List<Course> suggested = new List<Course>();

            try
            {
                suggested = _courseDal.GetAllCourses()
                    .Where(c => !enrolledIds.Contains(c.CourseId))
                    .OrderByDescending(c => c.AverageRating)
                    .Take(3)
                    .ToList();
            }
            catch
            {
                // Fallback
                suggested = Services.SampleData.Courses
                    .Where(c => !enrolledIds.Contains(c.CourseId))
                    .OrderByDescending(c => c.AverageRating)
                    .Take(3)
                    .ToList();
            }

            foreach (var course in suggested)
            {
                var thumb = A(course.ThumbnailUrl);
                var title = E(course.Title);
                var level = E(course.Level);
                var category = E(course.CategoryName);
                var instructor = E(course.InstructorName);
                string price = course.IsFree
                    ? "<span class=\"course-price free\">Ücretsiz</span>"
                    : $"<span class=\"course-price\">₺{course.Price:N0}</span>";

                builder.AppendFormat(@"
                <div class=""col-md-4"">
                  <article class=""course-card"">
                    <div class=""card-thumb"">
                      <img src=""{0}"" alt=""{1}"" loading=""lazy"" />
                      <div class=""card-badges""><span class=""badge-level"">{2}</span></div>
                    </div>
                    <div class=""card-body"">
                      <p class=""course-meta mb-1"">{3} &bull; {4}</p>
                      <h3 class=""course-title"">{1}</h3>
                      <div class=""course-card-footer"">
                        {5}
                        <a class=""btn btn-primary-custom btn-sm"" href=""CourseDetail.aspx?id={6}"">İncele</a>
                      </div>
                    </div>
                  </article>
                </div>",
                    thumb, title, level,
                    category, instructor,
                    price, course.CourseId);
            }
            return builder.ToString();
        }

        private static string E(string value)
            => HttpUtility.HtmlEncode(value ?? string.Empty);

        private static string A(string value)
            => HttpUtility.HtmlAttributeEncode(value ?? string.Empty);
    }
}
