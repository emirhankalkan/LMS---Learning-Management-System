using System;
using System.Collections.Generic;
using System.Web.UI;
using EduFlow.DAL;
using EduFlow.Models;
using EduFlow.Services;

namespace EduFlow
{
    public partial class Register : Page
    {
        protected string ErrorMessage   { get; private set; }
        protected string SuccessMessage { get; private set; }
        protected List<Category> Categories { get; private set; } = new List<Category>();

        private readonly UserDAL    _userDal   = new UserDAL();
        private readonly CourseDAL  _courseDal = new CourseDAL();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Kategorileri her zaman yükle (eğitmen alanı için)
            try { Categories = _courseDal.GetAllCategories(); }
            catch { }

            if (!IsPostBack) return;

            string fullname  = (Request.Form["fullname"]      ?? "").Trim();
            string email     = (Request.Form["email"]         ?? "").Trim();
            string password  =  Request.Form["password"]      ?? "";
            string password2 =  Request.Form["password2"]     ?? "";
            string role      = (Request.Form["selectedRole"]  ?? "student").Trim().ToLower();

            // --- Validasyon ---
            if (string.IsNullOrEmpty(fullname) || string.IsNullOrEmpty(email))
            {
                ErrorMessage = "Ad, soyad ve e-posta alanları zorunludur.";
                return;
            }
            if (password.Length < 6)
            {
                ErrorMessage = "Şifre en az 6 karakter olmalıdır.";
                return;
            }
            if (password != password2)
            {
                ErrorMessage = "Şifreler eşleşmiyor, lütfen kontrol edin.";
                return;
            }

            string passwordHash = SecurityService.HashPassword(password);

            try
            {
                if (role == "instructor")
                {
                    // --- Eğitmen Kaydı ---
                    int.TryParse(Request.Form["categoryId"], out var categoryId);
                    string bio       = (Request.Form["bio"]       ?? "").Trim();
                    string linkedin  = (Request.Form["linkedin"]  ?? "").Trim();
                    string portfolio = (Request.Form["portfolio"] ?? "").Trim();

                    if (categoryId == 0)
                    {
                        ErrorMessage = "Lütfen uzmanlık alanınızı seçin.";
                        return;
                    }
                    if (string.IsNullOrEmpty(bio))
                    {
                        ErrorMessage = "Lütfen kısa biyografinizi girin.";
                        return;
                    }

                    int result = _userDal.RegisterInstructor(fullname, email, passwordHash,
                                                             categoryId, bio, linkedin, portfolio);
                    if (result == -1)
                    {
                        ErrorMessage = "Bu e-posta adresi zaten kullanımda.";
                        return;
                    }
                    if (result > 0)
                    {
                        Session["UserId"]   = result;
                        Session["FullName"] = fullname;
                        Session["UserRole"] = "Instructor";
                        Session["Cart"]     = new System.Collections.Generic.List<int>();
                        Response.Redirect("~/Instructor/Dashboard.aspx");
                    }
                }
                else
                {
                    // --- Öğrenci Kaydı ---
                    int result = _userDal.Register(fullname, email, passwordHash);
                    if (result == -1)
                    {
                        ErrorMessage = "Bu e-posta adresi zaten kullanımda.";
                        return;
                    }
                    if (result > 0)
                    {
                        Session["UserId"]   = result;
                        Session["FullName"] = fullname;
                        Session["UserRole"] = "Student";
                        Session["Cart"]     = new System.Collections.Generic.List<int>();
                        Response.Redirect("~/Dashboard.aspx");
                    }
                }
            }
            catch (Exception ex)
            {
                ErrorMessage = "Kayıt işlemi sırasında hata oluştu: " + ex.Message;
            }
        }
    }
}
