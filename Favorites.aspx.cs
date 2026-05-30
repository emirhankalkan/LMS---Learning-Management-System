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
    public partial class Favorites : Page
    {
        protected string FavoritesHtml        { get; private set; }
        protected string FavoriteCountText    { get; private set; }

        private readonly CourseDAL _courseDal = new CourseDAL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            int userId = Convert.ToInt32(Session["UserId"]);

            // Favori listesini al
            List<Course> favorites;
            try
            {
                favorites = _courseDal.GetUserFavorites(userId);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Favorites DB hatası: " + ex.Message);
                favorites = new List<Course>(); // fallback
            }

            // Ekleme Parametresi
            if (int.TryParse(Request.QueryString["add"], out var addId))
            {
                if (!favorites.Any(c => c.CourseId == addId))
                {
                    try
                    {
                        _courseDal.ToggleFavorite(userId, addId);
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Favori ekleme hatası: " + ex.Message);
                    }
                }
                Response.Redirect("~/Favorites.aspx");
                return;
            }

            // Silme Parametresi
            if (int.TryParse(Request.QueryString["remove"], out var removeId))
            {
                if (favorites.Any(c => c.CourseId == removeId))
                {
                    try
                    {
                        _courseDal.ToggleFavorite(userId, removeId);
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Favori silme hatası: " + ex.Message);
                    }
                }
                Response.Redirect("~/Favorites.aspx");
                return;
            }

            FavoriteCountText = $"{favorites.Count} favori kurs";

            if (favorites.Count == 0)
            {
                FavoritesHtml = @"
                <div class=""col-12"">
                    <div class=""plain-card p-5 text-center"">
                        <i class=""bi bi-heart-broken"" style=""font-size:3rem;color:var(--color-text-muted)""></i>
                        <h3 class=""mt-3"" style=""color:var(--color-text-secondary)"">Favorileriniz boş</h3>
                        <p class=""text-muted"">Beğendiğiniz veya daha sonra almayı düşündüğünüz kursları favorilerinize ekleyin.</p>
                        <a href=""Courses.aspx"" class=""btn btn-primary-custom mt-2"">Kursları İncele</a>
                    </div>
                </div>";
            }
            else
            {
                var sb = new StringBuilder();
                foreach (var c in favorites)
                {
                    var thumb = Thumb(c.ThumbnailUrl);
                    var title = E(c.Title);
                    var level = E(c.Level);
                    var category = E(c.CategoryName);
                    var instructor = E(c.InstructorName);
                    string stars = BuildStars(c.AverageRating);
                    string priceText = c.IsFree ? "Ücretsiz" : $"₺{c.Price:N0}";
                    string badge = c.IsFeatured ? "<span class=\"badge-featured\">Öne Çıkan</span>" : "";

                    sb.AppendFormat(@"
                    <div class=""col-md-6 col-lg-4"">
                        <article class=""course-card"">
                            <div class=""card-thumb"">
                                <img src=""{0}"" alt=""{1}"" loading=""lazy"" onerror=""this.onerror=null;this.src='https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=900&q=60';"" />
                                <div class=""card-badges"">{5}<span class=""badge-level"">{2}</span></div>
                            </div>
                            <div class=""card-body"">
                                <p class=""course-meta mb-1"">{3} &bull; {4} &bull; {6} ders</p>
                                <h3 class=""course-title"">{1}</h3>
                                <div class=""course-rating"">
                                    {7}
                                    <span style=""color:var(--color-accent);font-weight:500;font-size:13px;margin-left:4px;"">{8:F1}</span>
                                    <span class=""rating-count"">({9:N0})</span>
                                </div>
                                <div class=""course-card-footer"">
                                    <span class=""course-price"">{10}</span>
                                    <div class=""d-flex gap-1"">
                                        <a href=""Cart.aspx?add={11}"" class=""btn btn-accent btn-sm""><i class=""bi bi-cart-plus""></i> Ekle</a>
                                        <a href=""Favorites.aspx?remove={11}"" class=""btn btn-sm"" style=""background:var(--color-danger-bg);color:var(--color-danger);border:0;"" title=""Favoriden çıkar""><i class=""bi bi-heart-fill""></i></a>
                                    </div>
                                </div>
                            </div>
                        </article>
                    </div>",
                        thumb, title, level,
                        category, instructor, badge, c.LessonCount,
                        stars, c.AverageRating, c.EnrollmentCount, priceText, c.CourseId);
                }
                FavoritesHtml = sb.ToString();
            }
        }

        private static string BuildStars(double rating)
        {
            var sb = new StringBuilder();
            int full = (int)Math.Floor(rating);
            bool half = (rating - full) >= 0.5;
            for (int i = 0; i < full; i++) sb.Append("<i class=\"bi bi-star-fill\" style=\"color:var(--color-accent)\"></i>");
            if (half) sb.Append("<i class=\"bi bi-star-half\" style=\"color:var(--color-accent)\"></i>");
            int empty = 5 - full - (half ? 1 : 0);
            for (int i = 0; i < empty; i++) sb.Append("<i class=\"bi bi-star\" style=\"color:#D0D7E0\"></i>");
            return sb.ToString();
        }

        private static string E(string value)
            => HttpUtility.HtmlEncode(value ?? string.Empty);

        private static string A(string value)
            => HttpUtility.HtmlAttributeEncode(value ?? string.Empty);

        private static string Thumb(string url)
        {
            const string fallback = "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=900&q=60";
            if (string.IsNullOrWhiteSpace(url)) return fallback;
            if (url.StartsWith("~/")) return HttpUtility.HtmlAttributeEncode(url.Substring(1));
            return HttpUtility.HtmlAttributeEncode(url);
        }
    }
}
