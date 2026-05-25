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
    public partial class Cart : Page
    {
        protected string CartHtml     { get; private set; }
        protected string CountText    { get; private set; }
        protected string SubTotalHtml { get; private set; }
        protected string DiscountHtml { get; private set; }
        protected string TotalHtml    { get; private set; }

        protected global::System.Web.UI.WebControls.TextBox txtCouponCode;
        protected global::System.Web.UI.WebControls.Button btnApplyCoupon;
        protected global::System.Web.UI.WebControls.Label lblCouponMessage;

        private readonly CourseDAL _courseDal = new CourseDAL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (Session["UserRole"]?.ToString() == "Instructor")
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            var cart = Session["Cart"] as List<int> ?? new List<int>();

            // Ekleme İşlemi
            if (int.TryParse(Request.QueryString["add"], out var addId))
            {
                if (!cart.Contains(addId))
                {
                    cart.Add(addId);
                    Session["Cart"] = cart;
                }
                Response.Redirect("~/Cart.aspx");
                return;
            }

            // Çıkarma İşlemi
            if (int.TryParse(Request.QueryString["remove"], out var removeId))
            {
                if (cart.Contains(removeId))
                {
                    cart.Remove(removeId);
                    Session["Cart"] = cart;

                    // Clear coupon if the discounted course is removed
                    if (Session["DiscountCourseId"] != null && Convert.ToInt32(Session["DiscountCourseId"]) == removeId)
                    {
                        Session["AppliedDiscountCode"] = null;
                        Session["DiscountCourseId"] = null;
                        Session["DiscountPercentage"] = null;
                    }
                }
                Response.Redirect("~/Cart.aspx");
                return;
            }

            // İndirim Bilgilerini Oku
            int discountCourseId = Session["DiscountCourseId"] != null ? Convert.ToInt32(Session["DiscountCourseId"]) : 0;
            int discountPercentage = Session["DiscountPercentage"] != null ? Convert.ToInt32(Session["DiscountPercentage"]) : 0;

            // Eğer indirimli kurs artık sepette değilse indirimi temizle
            if (discountCourseId > 0 && !cart.Contains(discountCourseId))
            {
                Session["AppliedDiscountCode"] = null;
                Session["DiscountCourseId"] = null;
                Session["DiscountPercentage"] = null;
                discountCourseId = 0;
                discountPercentage = 0;
            }

            // Kursları DB'den Yükle
            var courses = new List<Course>();
            decimal subtotal = 0;
            decimal totalDiscount = 0;

            foreach (var cid in cart)
            {
                try
                {
                    var course = _courseDal.GetCourseDetail(cid);
                    if (course != null)
                    {
                        courses.Add(course);
                        subtotal += course.Price;
                        if (course.CourseId == discountCourseId)
                        {
                            totalDiscount += course.Price * discountPercentage / 100;
                        }
                    }
                }
                catch
                {
                    // Fallback to sample data if database error
                    var course = Services.SampleData.FindCourse(cid);
                    if (course != null)
                    {
                        courses.Add(course);
                        subtotal += course.Price;
                        if (course.CourseId == discountCourseId)
                        {
                            totalDiscount += course.Price * discountPercentage / 100;
                        }
                    }
                }
            }

            CountText = $"{courses.Count} kurs";
            SubTotalHtml = $"₺{subtotal:N0}";
            DiscountHtml = totalDiscount > 0 ? $"-₺{totalDiscount:N0}" : "-₺0";
            TotalHtml = $"₺{(subtotal - totalDiscount):N0}";

            // Pre-fill coupon input and message if coupon is active
            if (!IsPostBack && Session["AppliedDiscountCode"] != null)
            {
                txtCouponCode.Text = Session["AppliedDiscountCode"].ToString();
                lblCouponMessage.Text = $"Tebrikler! '{Session["AppliedDiscountCode"]}' kodu ile %{Session["DiscountPercentage"]} indirim uygulandı.";
                lblCouponMessage.CssClass = "text-success d-block mt-2";
                lblCouponMessage.Visible = true;
            }

            if (courses.Count == 0)
            {
                CartHtml = @"
                <div class=""text-center py-5"">
                    <i class=""bi bi-cart-x"" style=""font-size:4rem;color:var(--color-text-muted)""></i>
                    <h3 style=""color:var(--color-text-secondary);margin-top:16px;"">Sepetiniz boş</h3>
                    <p class=""text-muted"">İlginizi çeken kursları keşfedip sepetinize ekleyin.</p>
                    <a href=""Courses.aspx"" class=""btn btn-primary-custom mt-3"">Kurslara Göz At</a>
                </div>";
            }
            else
            {
                var sb = new StringBuilder();
                foreach (var c in courses)
                {
                    var thumb = A(c.ThumbnailUrl);
                    var title = E(c.Title);
                    var instructor = E(c.InstructorName);
                    string stars = BuildStars(c.AverageRating);
                    string priceText;
                    if (c.IsFree)
                    {
                        priceText = "Ücretsiz";
                    }
                    else if (c.CourseId == discountCourseId)
                    {
                        decimal discountedPrice = c.Price - (c.Price * discountPercentage / 100);
                        priceText = $@"<span style=""text-decoration:line-through;color:var(--color-text-muted);font-size:13.5px;margin-right:8px;"">₺{c.Price:N0}</span><span style=""color:var(--color-success);font-weight:700;"">₺{discountedPrice:N0}</span>";
                    }
                    else
                    {
                        priceText = $"₺{c.Price:N0}";
                    }

                    sb.AppendFormat(@"
                    <div class=""cart-item"" style=""display:flex;align-items:center;justify-content:space-between;padding:16px 0;border-bottom:1px solid var(--color-border);"">
                        <img src=""{0}"" alt=""{1}"" style=""width:120px;height:70px;object-fit:cover;border-radius:var(--radius-sm);margin-right:16px;"" />
                        <div class=""cart-item-info"" style=""flex-grow:1;"">
                            <div class=""cart-item-title"" style=""font-weight:600;font-size:15px;""><a href=""CourseDetail.aspx?id={5}"" style=""color:var(--color-text);text-decoration:none;"">{1}</a></div>
                            <div class=""cart-item-meta"" style=""font-size:12.5px;color:var(--color-text-muted);margin-top:4px;"">{2} &bull; {3} ders &bull; {4} saat</div>
                            <div style=""display:flex;gap:2px;margin-top:4px;align-items:center;"">
                                {6}
                                <span style=""font-size:12px;color:var(--color-text-muted);margin-left:4px;"">{7:F1}</span>
                            </div>
                        </div>
                        <div style=""text-align:right;min-width:100px;"">
                            <div class=""cart-item-price"" style=""font-weight:700;font-size:16px;color:var(--color-text);"">{8}</div>
                            <a href=""Cart.aspx?remove={5}"" style=""font-size:13px;color:var(--color-danger);display:block;text-align:right;margin-top:6px;text-decoration:none;"">
                                <i class=""bi bi-trash""></i> Kaldır
                            </a>
                        </div>
                    </div>",
                        thumb, title, instructor, c.LessonCount, c.TotalHours,
                        c.CourseId, stars, c.AverageRating, priceText);
                }
                CartHtml = sb.ToString();
            }
        }

        protected void btnApplyCoupon_Click(object sender, EventArgs e)
        {
            string code = txtCouponCode.Text.Trim().ToUpper();
            if (string.IsNullOrEmpty(code))
            {
                lblCouponMessage.Text = "Lütfen bir indirim kodu girin.";
                lblCouponMessage.CssClass = "text-danger d-block mt-2";
                lblCouponMessage.Visible = true;
                return;
            }

            try
            {
                var discount = _courseDal.GetDiscountByCode(code);
                if (discount != null && discount.IsActive)
                {
                    var cart = Session["Cart"] as List<int> ?? new List<int>();
                    if (cart.Contains(discount.CourseId))
                    {
                        Session["AppliedDiscountCode"] = discount.Code;
                        Session["DiscountCourseId"] = discount.CourseId;
                        Session["DiscountPercentage"] = discount.DiscountPercentage;

                        lblCouponMessage.Text = $"Tebrikler! '{discount.Code}' kodu ile %{discount.DiscountPercentage} indirim uygulandı.";
                        lblCouponMessage.CssClass = "text-success d-block mt-2";
                        lblCouponMessage.Visible = true;

                        Response.Redirect("~/Cart.aspx");
                    }
                    else
                    {
                        lblCouponMessage.Text = "Bu indirim kodu sepetinizdeki kurslar için geçerli değildir.";
                        lblCouponMessage.CssClass = "text-danger d-block mt-2";
                        lblCouponMessage.Visible = true;
                    }
                }
                else
                {
                    lblCouponMessage.Text = "Geçersiz veya süresi dolmuş indirim kodu.";
                    lblCouponMessage.CssClass = "text-danger d-block mt-2";
                    lblCouponMessage.Visible = true;
                }
            }
            catch (Exception ex)
            {
                lblCouponMessage.Text = "İndirim kodu doğrulanırken bir hata oluştu: " + ex.Message;
                lblCouponMessage.CssClass = "text-danger d-block mt-2";
                lblCouponMessage.Visible = true;
            }
        }

        protected void lnkCheckout_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            var cart = Session["Cart"] as List<int> ?? new List<int>();
            if (cart.Count == 0) return;

            Response.Redirect("~/Checkout.aspx");
        }

        private static string BuildStars(double rating)
        {
            var sb = new StringBuilder();
            int full = (int)Math.Floor(rating);
            bool half = (rating - full) >= 0.5;
            for (int i = 0; i < full; i++) sb.Append("<i class=\"bi bi-star-fill\" style=\"color:var(--color-accent);font-size:12px\"></i>");
            if (half) sb.Append("<i class=\"bi bi-star-half\" style=\"color:var(--color-accent);font-size:12px\"></i>");
            int empty = 5 - full - (half ? 1 : 0);
            for (int i = 0; i < empty; i++) sb.Append("<i class=\"bi bi-star\" style=\"color:#D0D7E0;font-size:12px\"></i>");
            return sb.ToString();
        }

        private static string E(string value)
            => HttpUtility.HtmlEncode(value ?? string.Empty);

        private static string A(string value)
            => HttpUtility.HtmlAttributeEncode(value ?? string.Empty);
    }
}
