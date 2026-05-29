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
        protected string CourseTitle      { get; private set; }
        protected string CourseDesc       { get; private set; }
        protected string SelectedCatId    { get; private set; } = "0";
        protected string SelectedLevel    { get; private set; } = "Başlangıç";
        protected string SelectedLanguage { get; private set; } = "Türkçe";
        protected string PriceType        { get; private set; } = "free";
        protected string CoursePrice      { get; private set; } = "";
        protected string ThumbnailUrl     { get; private set; } = "";
        protected string DiscountCode     { get; private set; } = "";
        protected string DiscountPercent  { get; private set; } = "";

        private readonly InstructorDAL _dal       = new InstructorDAL();
        private readonly CourseDAL     _courseDal = new CourseDAL();
        private static readonly HashSet<string> AllowedVideoExtensions =
            new HashSet<string>(StringComparer.OrdinalIgnoreCase) { ".mp4", ".webm", ".mov" };
        private const int MaxVideoUploadBytes = 200 * 1024 * 1024;

        protected void Page_Load(object sender, EventArgs e)
        {
            Form.Enctype = "multipart/form-data";
            try { Categories = _courseDal.GetAllCategories(); } catch { }

            int userId = Convert.ToInt32(Session["UserId"]);

            if (!IsPostBack)
            {
                // Düzenleme modu kontrolü
                if (int.TryParse(Request.QueryString["edit"], out var editId))
                {
                    try
                    {
                        var course = _courseDal.GetCourseDetail(editId);
                        // Güvenlik doğrulaması: Kurs bu eğitmenin mi?
                        if (course != null && course.InstructorUserId == userId)
                        {
                            NewCourseId      = editId;
                            CourseTitle      = course.Title;
                            CourseDesc       = course.Description;
                            SelectedCatId    = course.CategoryId.ToString();
                            SelectedLevel    = course.Level;
                            SelectedLanguage = course.Language;
                            PriceType        = course.IsFree ? "free" : "paid";
                            CoursePrice      = course.Price > 0 ? ((int)course.Price).ToString() : "";
                            ThumbnailUrl     = course.ThumbnailUrl;
                            LoadDiscount(editId);

                            LoadLessons(editId);
                        }
                        else
                        {
                            Response.Redirect("MyCourses.aspx");
                        }
                    }
                    catch
                    {
                        Response.Redirect("MyCourses.aspx");
                    }
                }
                return;
            }

            string fullName = Session["FullName"]?.ToString() ?? "";
            
            // hfAction (hidden field) veya action (submit button) üzerinden gelen eylemi oku
            string action = Request.Form["hfAction"] ?? "";
            if (string.IsNullOrEmpty(action))
            {
                action = Request.Form["action"] ?? "";
            }
            // Çakışma veya çoklu gönderim durumunda temizle
            if (action.Contains(","))
            {
                var parts = action.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                action = parts.Length > 0 ? parts[0].Trim() : "";
            }

            // Postback durumunda form değerlerini koru
            CourseTitle      = Request.Form["courseTitle"] ?? "";
            CourseDesc       = Request.Form["courseDesc"] ?? "";
            SelectedCatId    = Request.Form["courseCat"] ?? "0";
            SelectedLevel    = Request.Form["courseLevel"] ?? "Başlangıç";
            SelectedLanguage = Request.Form["courseLang"] ?? "Türkçe";
            PriceType        = Request.Form["priceType"] ?? "free";
            CoursePrice      = Request.Form["coursePrice"] ?? "";
            ThumbnailUrl     = Request.Form["thumbUrl"] ?? "";
            DiscountCode     = (Request.Form["discountCode"] ?? "").Trim().ToUpper();
            DiscountPercent  = (Request.Form["discountPercent"] ?? "").Trim();

            if (action == "createCourse")
            {
                CreateCourse(userId, fullName);
            }
            else if (action == "updateCourse")
            {
                UpdateCourse(userId);
            }
            else if (action == "addLesson")
            {
                AddLesson();
            }
            else if (action == "deleteLesson")
            {
                DeleteLessonAction();
            }
            else if (action == "moveLesson")
            {
                MoveLessonAction();
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
            string discountCode = (Request.Form["discountCode"] ?? "").Trim().ToUpper();
            int.TryParse(Request.Form["discountPercent"], out var discountPercent);

            if (string.IsNullOrEmpty(title) || string.IsNullOrEmpty(desc) || categoryId == 0)
            {
                ErrorMsg = "Başlık, açıklama ve kategori zorunludur.";
                return;
            }

            if (!ValidatePricing(isFree, price, discountCode, discountPercent))
                return;

            try
            {
                NewCourseId = _dal.AddCourse(title, desc, thumbUrl, isFree ? 0 : price, isFree,
                                             categoryId, userId, instructorName, level, lang);
                SaveDiscountSettings(NewCourseId, isFree, discountCode, discountPercent);
                SuccessMsg  = "Kurs oluşturuldu! Şimdi derslerinizi ekleyebilirsiniz.";
                LoadLessons(NewCourseId);
            }
            catch (Exception ex)
            {
                ErrorMsg = "Kurs oluşturulurken hata: " + ex.Message;
            }
        }

        private void UpdateCourse(int userId)
        {
            int.TryParse(Request.QueryString["edit"], out var courseId);
            if (courseId == 0)
                int.TryParse(Request.Form["existingCourseId"], out courseId);
            string title    = (Request.Form["courseTitle"] ?? "").Trim();
            string desc     = (Request.Form["courseDesc"]  ?? "").Trim();
            string thumbUrl = (Request.Form["thumbUrl"]    ?? "").Trim();
            string level    = (Request.Form["courseLevel"] ?? "Başlangıç").Trim();
            string lang     = (Request.Form["courseLang"]  ?? "Türkçe").Trim();
            bool   isFree   = (Request.Form["priceType"]  ?? "free") == "free";
            decimal.TryParse(Request.Form["coursePrice"], out var price);
            int.TryParse(Request.Form["courseCat"], out var categoryId);
            string discountCode = (Request.Form["discountCode"] ?? "").Trim().ToUpper();
            int.TryParse(Request.Form["discountPercent"], out var discountPercent);

            NewCourseId = courseId;

            if (string.IsNullOrEmpty(title) || string.IsNullOrEmpty(desc) || categoryId == 0)
            {
                ErrorMsg = "Başlık, açıklama ve kategori zorunludur.";
                return;
            }

            try
            {
                // Güvenlik kontrolü
                var course = _courseDal.GetCourseDetail(courseId);
                if (!ValidatePricing(isFree, price, discountCode, discountPercent))
                    return;
                if (course == null || course.InstructorUserId != userId)
                {
                    Response.Redirect("MyCourses.aspx");
                    return;
                }

                _dal.UpdateCourse(courseId, title, desc, thumbUrl, isFree ? 0 : price, isFree,
                                  categoryId, level, lang);
                SaveDiscountSettings(courseId, isFree, discountCode, discountPercent);
                SuccessMsg  = "Kurs başarıyla güncellendi! Ders listenizi yönetmeye devam edebilirsiniz.";
                LoadLessons(courseId);
            }
            catch (Exception ex)
            {
                ErrorMsg = "Kurs güncellenirken hata: " + ex.Message;
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

        private void DeleteLessonAction()
        {
            int.TryParse(Request.Form["newCourseId"], out var courseId);
            int.TryParse(Request.Form["targetLessonId"], out var lessonId);
            NewCourseId = courseId;

            if (lessonId > 0)
            {
                try
                {
                    _dal.DeleteLesson(lessonId);
                    SuccessMsg = "Ders başarıyla silindi.";
                }
                catch (Exception ex)
                {
                    ErrorMsg = "Ders silinirken hata: " + ex.Message;
                }
            }
            LoadLessons(courseId);
        }

        private void MoveLessonAction()
        {
            int.TryParse(Request.Form["newCourseId"], out var courseId);
            int.TryParse(Request.Form["targetLessonId"], out var lessonId);
            string direction = Request.Form["moveDirection"] ?? "";
            NewCourseId = courseId;

            if (lessonId > 0 && (direction == "UP" || direction == "DOWN"))
            {
                try
                {
                    _dal.MoveLesson(lessonId, direction);
                }
                catch (Exception ex)
                {
                    ErrorMsg = "Ders sırası değiştirilirken hata: " + ex.Message;
                }
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
                for (int i = 0; i < lessons.Count; i++)
                {
                    var l = lessons[i];
                    var title = E(l.Title);
                    var videoBadge = BuildVideoBadge(l.VideoUrl);
                    string preview = l.IsPreview
                        ? "<span class=\"badge-free\" style=\"font-size:11px;\"><i class=\"bi bi-eye\"></i> Önizleme</span>"
                        : "<span class=\"text-muted\" style=\"font-size:12px;\">—</span>";

                    string upBtn = i > 0
                        ? string.Format(@"<button type=""button"" onclick=""moveLesson({0}, 'UP')"" class=""btn btn-outline-custom btn-sm"" style=""padding: 2px 6px; font-size:12px; margin-right:2px;"" title=""Yukarı Taşı""><i class=""bi bi-arrow-up""></i></button>", l.LessonId)
                        : @"<button type=""button"" class=""btn btn-outline-custom btn-sm"" style=""padding: 2px 6px; font-size:12px; margin-right:2px; opacity:0.3; cursor:default;"" disabled><i class=""bi bi-arrow-up""></i></button>";

                    string downBtn = i < lessons.Count - 1
                        ? string.Format(@"<button type=""button"" onclick=""moveLesson({0}, 'DOWN')"" class=""btn btn-outline-custom btn-sm"" style=""padding: 2px 6px; font-size:12px; margin-right:6px;"" title=""Aşağı Taşı""><i class=""bi bi-arrow-down""></i></button>", l.LessonId)
                        : @"<button type=""button"" class=""btn btn-outline-custom btn-sm"" style=""padding: 2px 6px; font-size:12px; margin-right:6px; opacity:0.3; cursor:default;"" disabled><i class=""bi bi-arrow-down""></i></button>";

                    string deleteBtn = string.Format(@"<button type=""button"" onclick=""deleteLesson({0})"" class=""btn btn-sm"" style=""background:var(--color-danger-bg);color:var(--color-danger);border:0;padding: 2px 6px; font-size:12px;"" title=""Dersi Sil""><i class=""bi bi-trash""></i></button>", l.LessonId);

                    sb.AppendFormat(@"<tr>
<td style=""padding:12px 16px;"">{0}</td>
<td>{1}<div style=""margin-top:4px;"">{4}</div></td>
<td>{2} dk</td>
<td>{3}</td>
<td style=""text-align:right;padding-right:20px;"">
  {5}{6}{7}
</td>
</tr>",
                        l.OrderIndex, title, l.Duration, preview, videoBadge, upBtn, downBtn, deleteBtn);
                }
                LessonsHtml = sb.ToString();
            }
            catch { LessonsHtml = ""; }
        }

        private static string E(string value)
            => HttpUtility.HtmlEncode(value ?? string.Empty);

        private void LoadDiscount(int courseId)
        {
            try
            {
                var discount = _courseDal.GetDiscountByCourse(courseId);
                if (discount == null) return;

                DiscountCode = discount.Code;
                DiscountPercent = discount.DiscountPercentage.ToString();
            }
            catch { }
        }

        private bool ValidatePricing(bool isFree, decimal price, string discountCode, int discountPercent)
        {
            if (!isFree && price <= 0)
            {
                ErrorMsg = "Ücretli kurs için fiyat 0'dan büyük olmalıdır.";
                return false;
            }

            if (isFree && (!string.IsNullOrEmpty(discountCode) || discountPercent > 0))
            {
                ErrorMsg = "İndirim kodu sadece ücretli kurslarda kullanılabilir.";
                return false;
            }

            bool hasDiscountCode = !string.IsNullOrWhiteSpace(discountCode);
            bool hasDiscountPercent = discountPercent > 0;
            if (hasDiscountCode != hasDiscountPercent)
            {
                ErrorMsg = "İndirim için hem kodu hem de yüzde değerini girin.";
                return false;
            }

            if (hasDiscountPercent && (discountPercent < 1 || discountPercent > 99))
            {
                ErrorMsg = "İndirim yüzdesi 1 ile 99 arasında olmalıdır.";
                return false;
            }

            return true;
        }

        private void SaveDiscountSettings(int courseId, bool isFree, string discountCode, int discountPercent)
        {
            if (isFree || string.IsNullOrWhiteSpace(discountCode))
            {
                _courseDal.ClearCourseDiscount(courseId);
                return;
            }

            _courseDal.SaveCourseDiscount(courseId, discountCode, discountPercent);
        }

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

            return "~/Uploads/Lessons/" + fileName;
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
