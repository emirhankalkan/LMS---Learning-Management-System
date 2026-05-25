using System;
using System.Collections.Generic;
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

        protected void Page_Load(object sender, EventArgs e)
        {
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
            string video   = (Request.Form["lessonVideo"]   ?? "").Trim();
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
                    string preview = l.IsPreview
                        ? "<span class=\"badge-free\" style=\"font-size:11px;\"><i class=\"bi bi-eye\"></i> Önizleme</span>"
                        : "<span class=\"text-muted\" style=\"font-size:12px;\">—</span>";

                    sb.AppendFormat("<tr><td style=\"padding:10px 16px;\">{0}</td><td>{1}</td><td>{2} dk</td><td>{3}</td></tr>",
                        l.OrderIndex, title, l.Duration, preview);
                }
                LessonsHtml = sb.ToString();
            }
            catch { LessonsHtml = ""; }
        }

        private static string E(string value)
            => HttpUtility.HtmlEncode(value ?? string.Empty);
    }
}
