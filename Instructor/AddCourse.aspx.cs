using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using EduFlow.DAL;
using EduFlow.Models;

namespace EduFlow.Instructor
{
    public partial class AddCourse : Page
    {
        protected string         ErrorMsg    { get; private set; }
        protected string         SuccessMsg  { get; private set; }
        protected int            NewCourseId { get; private set; }
        protected int            LessonCount { get; private set; }
        protected string         LessonsHtml { get; private set; }
        protected List<Category> Categories  { get; private set; } = new List<Category>();

        // Form değerlerini sayfaya geri taşımak için
        protected string CourseTitle { get; private set; }
        protected string CourseDesc  { get; private set; }

        private readonly InstructorDAL _dal       = new InstructorDAL();
        private readonly CourseDAL     _courseDal = new CourseDAL();
        private static readonly HashSet<string> AllowedVideoExtensions =
            new HashSet<string>(StringComparer.OrdinalIgnoreCase) { ".mp4", ".webm", ".mov" };
        private const int MaxVideoUploadBytes = 200 * 1024 * 1024;

        protected void Page_Load(object sender, EventArgs e)
        {
            Form.Enctype = "multipart/form-data";
            try { Categories = _courseDal.GetAllCategories(); } catch { }

            if (!IsPostBack) return;

            int userId      = Convert.ToInt32(Session["UserId"]);
            string fullName = Session["FullName"]?.ToString() ?? "";
            string action   = Request.Form["action"] ?? "";

            if (action == "createCourse")
            {
                CreateCourse(userId, fullName);
            }
            else if (action == "addLesson")
            {
                AddLesson();
            }
        }

        private void CreateCourse(int userId, string instructorName)
        {
            string title    = (Request.Form["courseTitle"] ?? "").Trim();
            string desc     = (Request.Form["courseDesc"]  ?? "").Trim();
            string thumbUrl = (Request.Form["thumbUrl"]    ?? "").Trim();
            string level    = (Request.Form["courseLevel"] ?? "Başlangıç").Trim();
            string lang     = (Request.Form["courseLang"]  ?? "Türkçe").Trim();
            bool   isFree   = (Request.Form["priceType"]  ?? "free") == "free";
            decimal.TryParse(Request.Form["coursePrice"], out var price);
            int.TryParse(Request.Form["courseCat"], out var categoryId);

            CourseTitle = title;
            CourseDesc  = desc;

            if (string.IsNullOrEmpty(title) || string.IsNullOrEmpty(desc) || categoryId == 0)
            {
                ErrorMsg = "Başlık, açıklama ve kategori zorunludur.";
                return;
            }

            try
            {
                NewCourseId = _dal.AddCourse(title, desc, thumbUrl, isFree ? 0 : price, isFree,
                                             categoryId, userId, instructorName, level, lang);
                SuccessMsg  = "Kurs oluşturuldu! Şimdi derslerinizi ekleyebilirsiniz.";
                LoadLessons(NewCourseId);
            }
            catch (Exception ex)
            {
                ErrorMsg = "Kurs oluşturulurken hata: " + ex.Message;
            }
        }

        private void AddLesson()
        {
            int.TryParse(Request.Form["newCourseId"],   out var courseId);
            int.TryParse(Request.Form["lessonDuration"], out var duration);
            string title   = (Request.Form["lessonTitle"]   ?? "").Trim();
            string video   = NormalizeVideoUrl((Request.Form["lessonVideo"] ?? "").Trim());
            bool isPreview = (Request.Form["lessonPreview"] ?? "false") == "true";

            NewCourseId = courseId;

            if (string.IsNullOrEmpty(title))
            {
                ErrorMsg = "Ders başlığı zorunludur.";
                LoadLessons(courseId);
                return;
            }
            if (duration <= 0) duration = 10;

            try
            {
                var uploadedVideo = SaveUploadedVideo();
                if (!string.IsNullOrEmpty(uploadedVideo))
                    video = uploadedVideo;

                _dal.AddLesson(courseId, title, video, duration, isPreview);
                SuccessMsg = "Ders eklendi!";
            }
            catch (Exception ex)
            {
                ErrorMsg = "Ders eklenirken hata: " + ex.Message;
            }

            LoadLessons(courseId);
        }

        private void LoadLessons(int courseId)
        {
            try
            {
                var lessons = _dal.GetLessons(courseId);
                LessonCount = lessons.Count;
                var sb = new StringBuilder();
                foreach (var l in lessons)
                {
                    var title = E(l.Title);
                    var videoBadge = BuildVideoBadge(l.VideoUrl);
                    string preview = l.IsPreview
                        ? "<span class=\"badge-free\" style=\"font-size:11px;\"><i class=\"bi bi-eye\"></i> Önizleme</span>"
                        : "<span class=\"text-muted\" style=\"font-size:12px;\">—</span>";

                    sb.AppendFormat("<tr><td style=\"padding:10px 16px;\">{0}</td><td>{1}<div style=\"margin-top:4px;\">{4}</div></td><td>{2} dk</td><td>{3}</td></tr>",
                        l.OrderIndex, title, l.Duration, preview, videoBadge);
                }
                LessonsHtml = sb.ToString();
            }
            catch { LessonsHtml = ""; }
        }

        private static string E(string value)
            => HttpUtility.HtmlEncode(value ?? string.Empty);

        private string SaveUploadedVideo()
        {
            var file = Request.Files["lessonVideoFile"];
            if (file == null || file.ContentLength == 0)
                return null;

            if (file.ContentLength > MaxVideoUploadBytes)
                throw new InvalidOperationException("Video dosyası en fazla 200 MB olabilir.");

            var extension = Path.GetExtension(file.FileName);
            if (string.IsNullOrEmpty(extension) || !AllowedVideoExtensions.Contains(extension))
                throw new InvalidOperationException("Sadece MP4, WebM veya MOV video dosyası yükleyebilirsiniz.");

            var uploadDirectory = Server.MapPath("~/Uploads/Lessons");
            Directory.CreateDirectory(uploadDirectory);

            var fileName = DateTime.UtcNow.ToString("yyyyMMddHHmmss") + "-" + Guid.NewGuid().ToString("N").Substring(0, 8) + extension.ToLowerInvariant();
            file.SaveAs(Path.Combine(uploadDirectory, fileName));

            return "/Uploads/Lessons/" + fileName;
        }

        private static string NormalizeVideoUrl(string url)
        {
            if (string.IsNullOrWhiteSpace(url))
                return "";

            if (url.IndexOf("youtube.com/watch", StringComparison.OrdinalIgnoreCase) >= 0)
            {
                var uri = new Uri(url);
                var query = HttpUtility.ParseQueryString(uri.Query);
                var videoId = query["v"];
                var listId = query["list"];
                if (!string.IsNullOrEmpty(videoId))
                {
                    var embed = "https://www.youtube.com/embed/" + HttpUtility.UrlEncode(videoId);
                    if (!string.IsNullOrEmpty(listId))
                        embed += "?list=" + HttpUtility.UrlEncode(listId);
                    return embed;
                }
            }

            if (url.IndexOf("youtu.be/", StringComparison.OrdinalIgnoreCase) >= 0)
            {
                var uri = new Uri(url);
                var videoId = uri.AbsolutePath.Trim('/');
                if (!string.IsNullOrEmpty(videoId))
                    return "https://www.youtube.com/embed/" + HttpUtility.UrlEncode(videoId);
            }

            return url;
        }

        private static string BuildVideoBadge(string videoUrl)
        {
            if (string.IsNullOrEmpty(videoUrl))
                return "<span class=\"text-muted\" style=\"font-size:12px;\">Video eklenmedi</span>";

            if (videoUrl.StartsWith("/Uploads/", StringComparison.OrdinalIgnoreCase))
                return "<span class=\"badge-level\" style=\"font-size:11px;\"><i class=\"bi bi-upload\"></i> Yüklü video</span>";

            return "<span class=\"badge-level\" style=\"font-size:11px;\"><i class=\"bi bi-youtube\"></i> Harici video</span>";
        }
    }
}
