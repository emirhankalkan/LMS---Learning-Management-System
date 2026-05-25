using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.UI;
using EduFlow.DAL;
using EduFlow.Models;

namespace EduFlow
{
    public partial class Checkout : Page
    {
        protected string OrderItemsHtml { get; private set; }
        protected string SubTotalText   { get; private set; }
        protected string TotalText      { get; private set; }

        private readonly CourseDAL _courseDal = new CourseDAL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            // Instructors cannot purchase courses
            if (Session["UserRole"]?.ToString() == "Instructor")
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            var cart = Session["Cart"] as List<int> ?? new List<int>();
            if (cart.Count == 0)
            {
                Response.Redirect("~/Cart.aspx");
                return;
            }

            // Load active discount parameters
            int discountCourseId = Session["DiscountCourseId"] != null ? Convert.ToInt32(Session["DiscountCourseId"]) : 0;
            int discountPercentage = Session["DiscountPercentage"] != null ? Convert.ToInt32(Session["DiscountPercentage"]) : 0;

            // Load Courses details
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

            SubTotalText = $"₺{subtotal:N0}";
            TotalText    = $"₺{(subtotal - totalDiscount):N0}";
            OrderItemsHtml = BuildOrderItems(courses, discountCourseId, discountPercentage);
        }

        private static string BuildOrderItems(IEnumerable<Course> courses, int discountCourseId, int discountPercentage)
        {
            var sb = new StringBuilder();
            foreach (var c in courses)
            {
                var thumb = A(c.ThumbnailUrl);
                var title = E(c.Title);
                string priceText;
                if (c.IsFree)
                {
                    priceText = "Ücretsiz";
                }
                else if (c.CourseId == discountCourseId)
                {
                    decimal discountedPrice = c.Price - (c.Price * discountPercentage / 100);
                    priceText = $@"<span style=""text-decoration:line-through;color:var(--color-text-muted);font-size:11.5px;margin-right:6px;"">₺{c.Price:N0}</span><span style=""color:#1783FA;font-weight:700;"">₺{discountedPrice:N0}</span>";
                }
                else
                {
                    priceText = $"₺{c.Price:N0}";
                }

                sb.AppendFormat(@"
                <div style=""display:flex;align-items:center;justify-content:space-between;padding:8px 0;font-size:13px;border-bottom:1px solid #f0f2f5;margin-bottom:8px;"">
                    <div style=""display:flex;align-items:center;gap:10px;max-width:70%;"">
                        <img src=""{0}"" alt=""{1}"" style=""width:48px;height:32px;object-fit:cover;border-radius:4px;flex-shrink:0;"" />
                        <span style=""font-weight:600;color:#1c2b3a;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"" title=""{1}"">{1}</span>
                    </div>
                    <span style=""font-weight:700;color:#0b1a30;white-space:nowrap;"">{2}</span>
                </div>", thumb, title, priceText);
            }
            return sb.ToString();
        }

        protected void btnRealCheckout_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            var cart = Session["Cart"] as List<int> ?? new List<int>();
            if (cart.Count == 0) return;

            int userId = Convert.ToInt32(Session["UserId"]);

            int discountCourseId = Session["DiscountCourseId"] != null ? Convert.ToInt32(Session["DiscountCourseId"]) : 0;
            int discountPercentage = Session["DiscountPercentage"] != null ? Convert.ToInt32(Session["DiscountPercentage"]) : 0;

            foreach (var cid in cart)
            {
                try
                {
                    decimal price = 0;
                    var course = _courseDal.GetCourseDetail(cid);
                    if (course != null)
                    {
                        price = course.Price;
                        if (course.CourseId == discountCourseId)
                        {
                            price = course.Price - (course.Price * discountPercentage / 100);
                        }
                    }

                    // Demo akisi: gercek iyzico callback olmadigi icin siparis simule edilir.
                    int orderId = _courseDal.CreateOrder(userId, cid, price);

                    if (orderId > 0)
                    {
                        // 3D Secure simulasyonu basarili kabul edildigi icin kayit tamamlanir.
                        string paymentRef = "IYZI-" + Guid.NewGuid().ToString().Substring(0, 8).ToUpper();
                        _courseDal.CompleteOrder(orderId, paymentRef);
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("iyzico checkout sırasında DB hatası: " + ex.Message);
                }
            }

            // Clear Cart and active discounts
            Session["Cart"] = null;
            Session["AppliedDiscountCode"] = null;
            Session["DiscountCourseId"] = null;
            Session["DiscountPercentage"] = null;

            Response.Redirect("~/PaymentSuccess.aspx");
        }

        private static string E(string value)
            => HttpUtility.HtmlEncode(value ?? string.Empty);

        private static string A(string value)
            => HttpUtility.HtmlAttributeEncode(value ?? string.Empty);
    }
}
