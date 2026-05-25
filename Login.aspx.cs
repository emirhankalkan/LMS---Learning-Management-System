using System;
using System.Web.UI;
using EduFlow.DAL;
using EduFlow.Services;

namespace EduFlow
{
    public partial class Login : Page
    {
        protected string Message { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) return;

            var email    = (Request.Form["email"]    ?? "").Trim().ToLower();
            var password = (Request.Form["password"] ?? "").Trim();

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                Message = "E-posta ve şifre alanları boş bırakılamaz.";
                return;
            }

            var dal  = new UserDAL();
            var user = dal.Login(email, password);

            if (user != null)
            {
                Session["UserId"]   = user.UserId;
                Session["FullName"] = user.FullName;
                Session["UserRole"] = user.RoleName;

                if (user.RoleName == "Admin")
                    Response.Redirect("~/Admin/Dashboard.aspx");
                else if (user.RoleName == "Instructor")
                    Response.Redirect("~/Instructor/Dashboard.aspx");
                else
                    Response.Redirect("~/Dashboard.aspx");
                return;
            }

            Message = "E-posta adresi veya şifre hatalı. Lütfen tekrar deneyin.";
        }
    }
}
