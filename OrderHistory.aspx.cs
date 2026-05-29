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
    public partial class OrderHistory : Page
    {
        protected List<Order> Orders     { get; private set; } = new List<Order>();
        protected string OrderRowsHtml   { get; private set; }
        protected string Message         { get; private set; }
        protected int    CompletedCount  { get; private set; }
        protected int    PendingCount    { get; private set; }
        protected decimal TotalSpent     { get; private set; }

        private readonly CourseDAL _dal = new CourseDAL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            int userId = Convert.ToInt32(Session["UserId"]);

            try
            {
                Orders = _dal.GetUserOrders(userId);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("OrderHistory DB hatası: " + ex.Message);
                Orders = new List<Order>();
                Message = "Siparişler yüklenirken bir hata oluştu.";
            }

            CompletedCount = Orders.Count(o => o.Status == "Completed");
            PendingCount   = Orders.Count(o => o.Status == "Pending");
            TotalSpent     = Orders.Where(o => o.Status == "Completed").Sum(o => o.Amount);
            OrderRowsHtml  = BuildOrderRows(Orders);
        }

        private static string BuildOrderRows(List<Order> orders)
        {
            var sb = new StringBuilder();
            foreach (var o in orders)
            {
                string thumb = !string.IsNullOrEmpty(o.ThumbnailUrl)
                    ? HttpUtility.HtmlAttributeEncode(o.ThumbnailUrl)
                    : "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=120&q=60";

                string statusBadge;
                switch (o.Status)
                {
                    case "Completed":
                        statusBadge = "<span class=\"badge-free\"><i class=\"bi bi-check-circle-fill\"></i> Tamamlandı</span>";
                        break;
                    case "Pending":
                        statusBadge = "<span style=\"background:var(--color-warning-bg);color:var(--color-warning);font-size:12px;padding:4px 10px;border-radius:999px;font-weight:500;\"><i class=\"bi bi-clock\"></i> Bekliyor</span>";
                        break;
                    default:
                        statusBadge = "<span class=\"badge-discount\"><i class=\"bi bi-x-circle-fill\"></i> Başarısız</span>";
                        break;
                }

                string courseTitle = HttpUtility.HtmlEncode(o.CourseTitle ?? "—");
                string dateStr     = o.CreatedAt.ToString("dd MMM yyyy", new System.Globalization.CultureInfo("tr-TR"));
                string payRef      = !string.IsNullOrEmpty(o.PaymentRef)
                    ? $"<span style=\"font-size:11px;color:var(--color-text-muted);font-family:monospace;\">{HttpUtility.HtmlEncode(o.PaymentRef.Length > 20 ? o.PaymentRef.Substring(0, 20) + "…" : o.PaymentRef)}</span>"
                    : "<span style=\"font-size:11px;color:var(--color-text-muted)\">—</span>";

                sb.AppendFormat(@"
<div style=""display:flex;align-items:center;gap:16px;padding:16px 20px;border-bottom:1px solid var(--color-border);"">
  <img src=""{0}"" alt=""{1}"" style=""width:72px;height:52px;object-fit:cover;border-radius:8px;flex-shrink:0;"" 
       onerror=""this.src='https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=120&q=60';"" />
  <div style=""flex:1;min-width:0;"">
    <div style=""font-size:14px;font-weight:500;color:var(--color-text-primary);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;"">{1}</div>
    <div style=""font-size:12px;color:var(--color-text-muted);margin-top:2px;""><i class=""bi bi-calendar3""></i> {2} &nbsp;·&nbsp; <i class=""bi bi-hash""></i> {3} {4}</div>
  </div>
  <div style=""text-align:right;flex-shrink:0;"">
    <div style=""font-size:16px;font-weight:500;color:var(--color-primary);margin-bottom:6px;"">₺{5:N0}</div>
    {6}
  </div>
</div>",
                    thumb, courseTitle, dateStr,
                    "Sipariş #" + o.OrderId, payRef,
                    o.Amount, statusBadge);
            }
            return sb.ToString();
        }
    }
}
