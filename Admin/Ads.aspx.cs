using System;
using System.Collections.Generic;
using System.Web.UI;
using EduFlow.DAL;

namespace EduFlow.Admin
{
    public partial class Ads : Page
    {
        protected List<Ad> AdList    { get; private set; } = new List<Ad>();
        protected string   Message   { get; private set; }
        protected string   MessageType { get; private set; } = "info";

        private readonly AdDAL _dal = new AdDAL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserRole"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            // Aktif/Pasif toggle
            if (int.TryParse(Request.QueryString["toggleAd"], out var toggleId))
            {
                bool.TryParse(Request.QueryString["active"], out var isActive);
                // active=1 veya active=0 olarak gelir
                isActive = Request.QueryString["active"] == "1";
                try
                {
                    _dal.SetActive(toggleId, isActive);
                    Message     = isActive ? "Reklam aktife alındı." : "Reklam pasife alındı.";
                    MessageType = "success";
                }
                catch (Exception ex)
                {
                    Message     = "İşlem sırasında hata: " + ex.Message;
                    MessageType = "danger";
                }
            }

            // Sil
            if (int.TryParse(Request.QueryString["deleteAd"], out var deleteId))
            {
                try
                {
                    _dal.Delete(deleteId);
                    Message     = "Reklam silindi.";
                    MessageType = "success";
                }
                catch (Exception ex)
                {
                    Message     = "Silme sırasında hata: " + ex.Message;
                    MessageType = "danger";
                }
                Response.Redirect("~/Admin/Ads.aspx?msg=deleted");
                return;
            }

            if (Request.QueryString["msg"] == "deleted")
            {
                Message     = "Reklam başarıyla silindi.";
                MessageType = "success";
            }

            // Yeni reklam ekle (POST)
            if (IsPostBack)
            {
                string action = Request.Form["adAction"] ?? "";
                if (action == "insertAd")
                    HandleInsert();
            }

            // Listeyi yükle
            LoadAdList();
        }

        private void HandleInsert()
        {
            string title       = (Request.Form["adTitle"]       ?? "").Trim();
            string imageUrl    = (Request.Form["adImageUrl"]    ?? "").Trim();
            string redirectUrl = (Request.Form["adRedirectUrl"] ?? "").Trim();
            string position    = (Request.Form["adPosition"]    ?? "Sidebar").Trim();

            DateTime? startDate = null;
            DateTime? endDate   = null;
            if (DateTime.TryParse(Request.Form["adStartDate"], out var sd)) startDate = sd;
            if (DateTime.TryParse(Request.Form["adEndDate"],   out var ed)) endDate   = ed;

            if (string.IsNullOrEmpty(title))
            {
                Message     = "Reklam başlığı zorunludur.";
                MessageType = "danger";
                return;
            }

            try
            {
                _dal.Insert(title, imageUrl, redirectUrl, position, startDate, endDate);
                Message     = "Reklam başarıyla eklendi.";
                MessageType = "success";
            }
            catch (Exception ex)
            {
                Message     = "Reklam eklenirken hata: " + ex.Message;
                MessageType = "danger";
            }
        }

        private void LoadAdList()
        {
            try   { AdList = _dal.GetAll(); }
            catch { AdList = new List<Ad>(); }
        }
    }
}
