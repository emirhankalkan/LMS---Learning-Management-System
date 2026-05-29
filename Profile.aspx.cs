using System;
using System.IO;
using System.Web.UI;
using EduFlow.DAL;
using EduFlow.Models;

namespace EduFlow
{
    public partial class Profile : Page
    {
        protected User CurrentUser  { get; private set; }
        protected string ErrorMsg   { get; private set; }
        protected string SuccessMsg { get; private set; }

        private readonly UserDAL _userDal = new UserDAL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            int userId = Convert.ToInt32(Session["UserId"]);

            // Her yüklemede kullanıcıyı DB'den çek
            try { CurrentUser = _userDal.GetUserById(userId); }
            catch { CurrentUser = null; }

            if (!IsPostBack) return;

            string action = Request.Form["profileAction"] ?? "";

            if (action == "updateProfile")
                HandleUpdateProfile(userId);
            else if (action == "changePassword")
                HandleChangePassword(userId);
            else if (action == "uploadPhoto")
                HandlePhotoUpload(userId);
        }

        private void HandleUpdateProfile(int userId)
        {
            string fullName = (Request.Form["fullName"] ?? "").Trim();
            if (string.IsNullOrEmpty(fullName))
            {
                ErrorMsg = "Ad soyad boş bırakılamaz.";
                return;
            }

            try
            {
                _userDal.UpdateProfile(userId, fullName);
                Session["FullName"] = fullName;
                if (CurrentUser != null) CurrentUser.FullName = fullName;
                SuccessMsg = "Profil bilgileri güncellendi.";
            }
            catch (Exception ex)
            {
                ErrorMsg = "Güncelleme sırasında hata: " + ex.Message;
            }
        }

        private void HandleChangePassword(int userId)
        {
            string oldPwd  = Request.Form["oldPassword"]  ?? "";
            string newPwd  = Request.Form["newPassword"]  ?? "";
            string newPwd2 = Request.Form["newPassword2"] ?? "";

            if (newPwd.Length < 6)
            {
                ErrorMsg = "Yeni şifre en az 6 karakter olmalıdır.";
                return;
            }
            if (newPwd != newPwd2)
            {
                ErrorMsg = "Yeni şifreler eşleşmiyor.";
                return;
            }

            try
            {
                bool ok = _userDal.ChangePassword(userId, oldPwd, newPwd);
                if (ok)
                    SuccessMsg = "Şifreniz başarıyla güncellendi.";
                else
                    ErrorMsg = "Mevcut şifreniz yanlış.";
            }
            catch (Exception ex)
            {
                ErrorMsg = "Şifre değiştirme sırasında hata: " + ex.Message;
            }
        }

        private void HandlePhotoUpload(int userId)
        {
            var file = Request.Files["profilePhoto"];
            if (file == null || file.ContentLength == 0)
            {
                ErrorMsg = "Lütfen bir fotoğraf seçin.";
                return;
            }
            if (file.ContentLength > 2 * 1024 * 1024)
            {
                ErrorMsg = "Fotoğraf boyutu en fazla 2 MB olabilir.";
                return;
            }

            string ext = Path.GetExtension(file.FileName).ToLowerInvariant();
            if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".gif")
            {
                ErrorMsg = "Sadece JPG, PNG veya GIF yükleyebilirsiniz.";
                return;
            }

            try
            {
                string uploadDir = Server.MapPath("~/Uploads/Profiles");
                Directory.CreateDirectory(uploadDir);
                string fileName = userId + "_" + DateTime.UtcNow.ToString("yyyyMMddHHmmss") + ext;
                file.SaveAs(Path.Combine(uploadDir, fileName));
                string photoUrl = "/Uploads/Profiles/" + fileName;
                _userDal.UpdateProfile(userId, CurrentUser?.FullName ?? Session["FullName"]?.ToString() ?? "", photoUrl);
                SuccessMsg = "Profil fotoğrafı güncellendi.";
                // Kullanıcıyı tekrar yükle
                try { CurrentUser = _userDal.GetUserById(userId); } catch { }
            }
            catch (Exception ex)
            {
                ErrorMsg = "Fotoğraf yükleme sırasında hata: " + ex.Message;
            }
        }
    }
}
