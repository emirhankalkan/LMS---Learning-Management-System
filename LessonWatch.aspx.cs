using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using EduFlow.DAL;
using EduFlow.Models;

namespace EduFlow
{
    public partial class LessonWatch : Page
    {
        protected Course       Course           { get; private set; }
        protected Lesson       CurrentLesson    { get; private set; }
        protected List<Lesson> Lessons          { get; private set; } = new List<Lesson>();
        protected HashSet<int> CompletedLessonIds { get; private set; } = new HashSet<int>();
        protected int          CompletedCount   { get; private set; }
        protected int          ProgressPercent  { get; private set; }
        protected bool         IsLoggedIn       { get; private set; }
        protected bool         IsEnrolled       { get; private set; }
        protected bool         IsCompleted      { get; private set; }
        protected int          PrevLessonId     { get; private set; }
        protected int          NextLessonId     { get; private set; }

        private readonly CourseDAL _dal = new CourseDAL();

        protected void Page_Load(object sender, EventArgs e)
        {
            int.TryParse(Request.QueryString["courseId"],  out var courseId);
            int.TryParse(Request.QueryString["lessonId"],  out var lessonId);
            IsLoggedIn = Session["UserId"] != null;
            int userId = IsLoggedIn ? Convert.ToInt32(Session["UserId"]) : 0;

            // Kursu yükle
            try
            {
                Course = _dal.GetCourseDetail(courseId);
            }
            catch
            {
                Course = null;
            }

            if (Course == null)
            {
                Response.Redirect("~/Courses.aspx");
                return;
            }

            // Dersleri yükle
            try { Lessons = _dal.GetLessonsByCourse(courseId); }
            catch { Lessons = new List<Lesson>(); }

            // Kayıt kontrolü
            if (IsLoggedIn)
            {
                try { IsEnrolled = _dal.IsEnrolled(userId, courseId); }
                catch { IsEnrolled = false; }
            }

            // Eğer ders seçilmemişse video içeren ilk derse, yoksa ilk derse git
            if (lessonId == 0 && Lessons.Count > 0)
            {
                var firstPlayableLesson = Lessons.FirstOrDefault(l => !string.IsNullOrWhiteSpace(l.VideoUrl));
                lessonId = (firstPlayableLesson ?? Lessons[0]).LessonId;
                Response.Redirect($"~/LessonWatch.aspx?courseId={courseId}&lessonId={lessonId}");
                return;
            }

            // Seçili ders
            CurrentLesson = Lessons.FirstOrDefault(l => l.LessonId == lessonId);

            // Kayıtlı değilse sadece preview dersleri izleyebilir
            if (!IsEnrolled && CurrentLesson != null && !CurrentLesson.IsPreview)
            {
                // Preview'a yönlendir
                var firstPreview = Lessons.FirstOrDefault(l => l.IsPreview);
                if (firstPreview != null)
                    Response.Redirect($"~/LessonWatch.aspx?courseId={courseId}&lessonId={firstPreview.LessonId}");
                else
                    Response.Redirect($"~/CourseDetail.aspx?id={courseId}");
                return;
            }

            // "Tamamlandı işaretle" aksiyonu
            if (IsLoggedIn && IsEnrolled && Request.QueryString["complete"] == "1" && CurrentLesson != null)
            {
                try { _dal.CompleteLesson(userId, CurrentLesson.LessonId); }
                catch { }
                Response.Redirect($"~/LessonWatch.aspx?courseId={courseId}&lessonId={lessonId}");
                return;
            }

            if (IsLoggedIn && IsEnrolled && CurrentLesson != null)
            {
                try { _dal.MarkLessonWatched(userId, CurrentLesson.LessonId); }
                catch { }
            }

            // Tamamlanan dersleri çek
            if (IsLoggedIn && IsEnrolled)
            {
                try { CompletedLessonIds = GetCompletedLessons(userId, courseId); }
                catch { CompletedLessonIds = new HashSet<int>(); }
            }

            IsCompleted     = CurrentLesson != null && CompletedLessonIds.Contains(CurrentLesson.LessonId);
            CompletedCount  = CompletedLessonIds.Count;
            ProgressPercent = Lessons.Count > 0 ? (CompletedCount * 100) / Lessons.Count : 0;

            // Önceki / Sonraki ders
            if (CurrentLesson != null)
            {
                int idx = Lessons.FindIndex(l => l.LessonId == CurrentLesson.LessonId);
                PrevLessonId = idx > 0 ? Lessons[idx - 1].LessonId : 0;
                NextLessonId = idx < Lessons.Count - 1 ? Lessons[idx + 1].LessonId : 0;
            }

            Title = CurrentLesson != null ? CurrentLesson.Title + " — " + Course.Title : Course.Title;
        }

        private HashSet<int> GetCompletedLessons(int userId, int courseId)
        {
            var result = new HashSet<int>();
            using (var conn = DAL.Db.OpenConnection())
            using (var cmd = new System.Data.SqlClient.SqlCommand(
                @"SELECT lp.LessonId FROM LessonProgress lp
                  JOIN Lessons l ON l.LessonId = lp.LessonId
                  WHERE lp.UserId = @UserId AND l.CourseId = @CourseId AND lp.IsCompleted = 1", conn))
            {
                cmd.Parameters.AddWithValue("@UserId",   userId);
                cmd.Parameters.AddWithValue("@CourseId", courseId);
                using (var reader = cmd.ExecuteReader())
                    while (reader.Read())
                        result.Add(Convert.ToInt32(reader["LessonId"]));
            }
            return result;
        }

        protected bool IsLocalVideo(string url)
        {
            if (string.IsNullOrEmpty(url)) return false;
            return url.StartsWith("~/Uploads/", StringComparison.OrdinalIgnoreCase)
                || url.StartsWith("/Uploads/", StringComparison.OrdinalIgnoreCase)
                || url.StartsWith("Uploads/", StringComparison.OrdinalIgnoreCase);
        }

        protected string ResolveVideoUrl(string url)
        {
            if (string.IsNullOrEmpty(url)) return "";
            if (url.StartsWith("~/")) return ResolveUrl(url);
            if (url.StartsWith("/Uploads/", StringComparison.OrdinalIgnoreCase)) return ResolveUrl("~" + url);
            if (url.StartsWith("Uploads/", StringComparison.OrdinalIgnoreCase)) return ResolveUrl("~/" + url);
            return url;
        }

        protected string GetVideoMimeType(string url)
        {
            if (string.IsNullOrEmpty(url)) return "video/mp4";
            var ext = System.IO.Path.GetExtension(url).ToLower();
            if (ext == ".webm") return "video/webm";
            if (ext == ".ogg") return "video/ogg";
            if (ext == ".mov" || ext == ".qt") return "video/quicktime";
            return "video/mp4";
        }
    }
}
