using System;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.UI;
using EduFlow.DAL;

namespace EduFlow.Instructor
{
    public partial class MyCourses : Page
    {
        protected string CourseCardsHtml { get; private set; }
        protected int    TotalCount      { get; private set; }
        protected string Message         { get; private set; }

        protected global::System.Web.UI.WebControls.HiddenField hdnSelectedCourseId;
        protected global::System.Web.UI.WebControls.TextBox txtDiscountCode;
        protected global::System.Web.UI.WebControls.TextBox txtDiscountPercentage;

        private readonly InstructorDAL _dal = new InstructorDAL();

        protected void Page_Load(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            Message    = Request.QueryString["msg"] == "deleted" ? "Kurs başarıyla kaldırıldı." : null;

            // Kurs sil
            if (int.TryParse(Request.QueryString["delete"], out var deleteId))
            {
                try { _dal.DeleteCourse(deleteId, userId); }
                catch (Exception ex) { System.Diagnostics.Debug.WriteLine("Kurs silme hatası: " + ex.Message); }
                Response.Redirect("~/Instructor/MyCourses.aspx?msg=deleted");
                return;
            }

            try
            {
                var courses = _dal.GetMyCourses(userId);
                TotalCount  = courses.Count;

                var courseDal = new CourseDAL();
                var sb = new StringBuilder();
                foreach (var c in courses)
                {
                    string thumb    = !string.IsNullOrEmpty(c.ThumbnailUrl)
                                      ? A(c.ThumbnailUrl)
                                      : "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=400&q=60";
                    string price    = c.IsFree ? "<span class=\"badge-free\">Ücretsiz</span>" : "₺" + c.Price.ToString("N0");
                    string stars    = c.AverageRating > 0 ? "<span style=\"color:var(--color-accent)\">★</span> " + c.AverageRating.ToString("F1") : "—";

                    // İndirim Kodu Bilgisi
                    var discount = courseDal.GetDiscountByCourse(c.CourseId);
                    string discountCode = discount != null ? discount.Code : "";
                    int discountPct = discount != null ? discount.DiscountPercentage : 0;
                    
                    string discountLabel = discountPct > 0 
                        ? string.Format(@"<div style=""margin-top:4px;""><span class=""badge"" style=""background-color:rgba(232,175,42,.12);color:var(--color-warning);border:1px solid rgba(232,175,42,.2);font-size:11.5px;padding:4px 8px;font-weight:600;""><i class=""bi bi-tag-fill""></i> %{0} İndirim: {1}</span></div>", discountPct, E(discountCode))
                        : "";

                    sb.AppendFormat(@"
<div class=""col-md-6 col-xl-4"">
  <div class=""plain-card"" style=""padding:0;overflow:hidden;display:flex;flex-direction:column;"">
    <div style=""position:relative;"">
      <img src=""{0}"" alt=""{1}"" style=""width:100%;height:160px;object-fit:cover;"" onerror=""this.src='https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=400&q=60';"" />
      <div style=""position:absolute;top:10px;right:10px;"">
        {2}
      </div>
    </div>
    <div style=""padding:16px;flex:1;display:flex;flex-direction:column;"">
      <span class=""badge-level"" style=""font-size:11px;margin-bottom:8px;"">{3} · {4}</span>
      <div style=""font-weight:700;font-size:15px;margin-bottom:4px;line-height:1.3;"">{1}</div>
      {10}
      <div style=""display:flex;gap:16px;font-size:13px;color:var(--color-text-muted);margin-bottom:12px;margin-top:10px;"">
        <span><i class=""bi bi-people""></i> {5} öğrenci</span>
        <span><i class=""bi bi-collection-play""></i> {6} ders</span>
        <span>{7}</span>
      </div>
      <div style=""display:flex;align-items:center;justify-content:space-between;margin-top:auto;"">
        <strong style=""color:var(--color-primary);"">₺{8:N0} gelir</strong>
        <div class=""d-flex gap-2"">
          <a href=""../CourseDetail.aspx?id={9}"" target=""_blank"" class=""btn btn-sm"" style=""background:var(--color-surface-hover);color:var(--color-text);border:1px solid var(--color-border);text-decoration:none;"" title=""Görüntüle"">
            <i class=""bi bi-eye""></i>
          </a>
          <a href=""javascript:void(0);"" onclick=""openDiscountModal({9}, '{12}', '{13}', {14})"" class=""btn btn-sm"" style=""background:rgba(232,175,42,.12);color:var(--color-warning);border:0;text-decoration:none;"" title=""İndirim Kodu"">
            <i class=""bi bi-percent""></i>
          </a>
          <a href=""AddCourse.aspx?edit={9}"" class=""btn btn-sm"" style=""background:rgba(99,102,241,.1);color:#6366f1;border:0;text-decoration:none;"" title=""Düzenle"">
            <i class=""bi bi-pencil""></i>
          </a>
          <a href=""MyCourses.aspx?delete={9}"" class=""btn btn-sm"" style=""background:var(--color-danger-bg);color:var(--color-danger);border:0;text-decoration:none;""
             onclick=""return confirm('Bu kursu kaldırmak istediğinizden emin misiniz?');"" title=""Kaldır"">
            <i class=""bi bi-trash""></i>
          </a>
        </div>
      </div>
    </div>
  </div>
</div>",
                        thumb, E(c.Title), price, E(c.CategoryName), E(c.Level),
                        c.EnrollmentCount, c.LessonCount, stars,
                        c.CourseRevenue, c.CourseId, discountLabel,
                        null, J(c.Title), J(discountCode), discountPct);
                }
                CourseCardsHtml = sb.ToString();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("MyCourses hatası: " + ex.Message);
                CourseCardsHtml = "<div class='col-12'><p class='text-muted text-center'>Kurslar yüklenemedi.</p></div>";
            }
        }

        protected void btnSaveDiscount_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] == null) return;

            int.TryParse(hdnSelectedCourseId.Value, out var courseId);
            string code = txtDiscountCode.Text.Trim().ToUpper();
            int.TryParse(txtDiscountPercentage.Text, out var pct);

            if (courseId > 0)
            {
                try
                {
                    var courseDal = new CourseDAL();
                    if (string.IsNullOrEmpty(code) || pct <= 0)
                    {
                        using (var conn = Db.OpenConnection())
                        using (var cmd = new SqlCommand("DELETE FROM CourseDiscounts WHERE CourseId = @CourseId", conn))
                        {
                            cmd.Parameters.AddWithValue("@CourseId", courseId);
                            cmd.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        courseDal.SaveCourseDiscount(courseId, code, pct);
                    }
                    Response.Redirect("~/Instructor/MyCourses.aspx");
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("İndirim kaydetme hatası: " + ex.Message);
                }
            }
        }

        private static string E(string value)
            => HttpUtility.HtmlEncode(value ?? string.Empty);

        private static string A(string value)
            => HttpUtility.HtmlAttributeEncode(value ?? string.Empty);

        private static string J(string value)
            => HttpUtility.JavaScriptStringEncode(value ?? string.Empty);
    }
}
