<%@ Page Title="Kurs Detayı" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CourseDetail.aspx.cs" Inherits="EduFlow.CourseDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Page Header (koyu arka plan - Udemy tarzı) -->
    <section class="page-header" style="padding:32px 0 28px;">
        <div class="container">
            <p class="mb-1" style="font-size:13px; color:var(--color-on-primary-muted);">
                <a href="Courses.aspx" style="color:var(--color-on-primary-muted);">Kurslar</a>
                <i class="bi bi-chevron-right" style="font-size:11px;margin:0 6px;"></i>
                <a href="Courses.aspx?category=<%= Course.CategoryId %>" style="color:var(--color-on-primary-muted);"><%: Course.CategoryName %></a>
            </p>
            <h1 style="font-size:1.7rem;margin-bottom:10px;"><%: Course.Title %></h1>
            <p style="color:var(--color-on-primary-muted);max-width:720px;margin-bottom:14px;"><%: Course.Description %></p>
            <div class="d-flex align-items-center flex-wrap gap-3" style="font-size:14px;">
                <div style="display:flex;align-items:center;gap:6px;">
                    <span style="color:var(--color-accent);font-weight:500;"><%= Course.AverageRating.ToString("F1") %></span>
                    <%= StarsHtml %>
                    <span style="color:var(--color-on-primary-muted);">(<%: Course.EnrollmentCount.ToString("N0") %> değerlendirme)</span>
                </div>
                <span style="color:var(--color-on-primary-muted);">|</span>
                <span style="color:var(--color-on-primary-muted);"><i class="bi bi-people"></i> <%: Course.EnrollmentCount.ToString("N0") %> öğrenci</span>
                <span style="color:var(--color-on-primary-muted);">|</span>
                <span style="color:var(--color-on-primary-muted);"><i class="bi bi-translate"></i> <%: Course.Language %></span>
                <span style="color:var(--color-on-primary-muted);">|</span>
                <span style="color:var(--color-on-primary-muted);"><i class="bi bi-bar-chart-steps"></i> <%: Course.Level %></span>
            </div>
        </div>
    </section>

    <!-- Main Content + Sidebar -->
    <section class="section" style="padding-top:32px;">
        <div class="container">
            <div class="row g-4">

                <!-- LEFT COLUMN -->
                <div class="col-lg-8">

                    <!-- Tabs -->
                    <div class="edu-tabs" id="courseTabs">
                        <button class="edu-tab active" onclick="showTab('tabOverview', this)">Genel Bakış</button>
                        <button class="edu-tab" onclick="showTab('tabCurriculum', this)">Müfredat <span class="badge-level ms-1"><%= Course.LessonCount %> ders</span></button>
                        <button class="edu-tab" onclick="showTab('tabReviews', this)">Yorumlar</button>
                        <button class="edu-tab" onclick="showTab('tabInstructor', this)">Eğitmen</button>
                    </div>

                    <!-- Tab: Genel Bakış -->
                    <div class="tab-panel active" id="tabOverview">
                        <h2 style="font-size:1.2rem;">Bu kurstan ne öğreneceksin?</h2>
                        <div class="row g-2 mb-4">
                            <%= WillLearnHtml %>
                        </div>

                        <h2 style="font-size:1.2rem;">Kimler için uygun?</h2>
                        <ul style="color:var(--color-text-secondary);padding-left:20px;line-height:2;">
                            <li>Kariyerinde yeni bir yön arayanlara</li>
                            <li>Teorik bilgisini pratiğe dökmek isteyenlere</li>
                            <li>Portföy projesi oluşturmak isteyenlere</li>
                            <li>Kendi hızında öğrenmek isteyenlere</li>
                        </ul>

                        <h2 style="font-size:1.2rem;">Gereksinimler</h2>
                        <ul style="color:var(--color-text-secondary);padding-left:20px;line-height:2;">
                            <li>Bilgisayar ve internet bağlantısı</li>
                            <li>Temel bilgisayar kullanım becerisi</li>
                            <li>Öğrenme azmi ve pratik yapma isteği</li>
                        </ul>
                    </div>

                    <!-- Tab: Müfredat -->
                    <div class="tab-panel" id="tabCurriculum">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h2 style="font-size:1.2rem;margin-bottom:0;">Kurs İçeriği</h2>
                            <span class="text-muted" style="font-size:13px;"><%= Course.LessonCount %> ders &bull; <%: Course.TotalHours %> saatlik içerik</span>
                        </div>
                        <%= LessonsHtml %>
                    </div>

                    <!-- Tab: Yorumlar -->
                    <div class="tab-panel" id="tabReviews">
                        <!-- Rating Summary -->
                        <div class="rating-summary">
                            <div class="rating-big">
                                <div class="number"><%: Course.AverageRating.ToString("F1") %></div>
                                <div class="stars"><%= StarsHtml %></div>
                                <div style="font-size:12px;color:var(--color-text-muted);margin-top:4px;">Kurs puanı</div>
                            </div>
                            <div class="rating-bars">
                                <div class="rating-bar-row"><span class="label">5 ★</span><div class="bar"><div class="bar-fill" style="width:72%"></div></div><span class="pct">72%</span></div>
                                <div class="rating-bar-row"><span class="label">4 ★</span><div class="bar"><div class="bar-fill" style="width:19%"></div></div><span class="pct">19%</span></div>
                                <div class="rating-bar-row"><span class="label">3 ★</span><div class="bar"><div class="bar-fill" style="width:6%"></div></div><span class="pct">6%</span></div>
                                <div class="rating-bar-row"><span class="label">2 ★</span><div class="bar"><div class="bar-fill" style="width:2%"></div></div><span class="pct">2%</span></div>
                                <div class="rating-bar-row"><span class="label">1 ★</span><div class="bar"><div class="bar-fill" style="width:1%"></div></div><span class="pct">1%</span></div>
                            </div>
                        </div>
                        <%= ReviewsHtml %>
                    </div>

                    <!-- Tab: Eğitmen -->
                    <div class="tab-panel" id="tabInstructor">
                        <div class="instructor-card">
                            <div class="instructor-avatar"><%: Course.InstructorName.Substring(0,1) %></div>
                            <div class="instructor-info">
                                <h3><%: Course.InstructorName %></h3>
                                <p style="color:var(--color-text-secondary);font-size:14px;margin-bottom:8px;">Uzman Eğitmen &bull; <%: Course.CategoryName %></p>
                                <p style="color:var(--color-text-secondary);font-size:14px;line-height:1.7;">
                                    <%: Course.InstructorName %> yıllardan bu yana sektörde aktif olarak çalışmakta ve bu deneyimini EduFlow öğrencileriyle paylaşmaktadır. Gerçek dünya projelerine dayalı müfredatıyla öğrencileri hem teorik hem de pratik açıdan donatmaktadır.
                                </p>
                                <div class="instructor-stats">
                                    <span><i class="bi bi-star-fill" style="color:var(--color-accent)"></i> <%: Course.AverageRating.ToString("F1") %> puan</span>
                                    <span><i class="bi bi-people"></i> <%: Course.EnrollmentCount.ToString("N0") %> öğrenci</span>
                                    <span><i class="bi bi-collection-play"></i> 1 kurs</span>
                                    <span><i class="bi bi-chat-square-text"></i> 96% olumlu yorum</span>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- RIGHT COLUMN - Buy Box -->
                <div class="col-lg-4">
                    <div class="buy-box">
                        <!-- Video Preview -->
                        <div class="ratio ratio-16x9 mb-3" style="border-radius:var(--radius-md);overflow:hidden;">
                            <iframe src="<%: PreviewVideoUrl %>" title="Kurs önizleme" allowfullscreen></iframe>
                        </div>
                        <p class="text-muted mb-3" style="font-size:13px;text-align:center;"><i class="bi bi-eye"></i> Ücretsiz önizleme</p>

                        <div class="buy-price <%= Course.IsFree ? "free" : "" %>">
                            <%= Course.IsFree ? "Ücretsiz" : $"₺{Course.Price:N0}" %>
                        </div>

                        <% if (Session["UserRole"]?.ToString() == "Instructor") { %>
                            <% if (Course.InstructorUserId != null && Session["UserId"] != null && Convert.ToInt32(Session["UserId"]) == Course.InstructorUserId) { %>
                                <div class="alert alert-warning text-center" style="font-size:13px; padding:10px; margin-bottom:12px; border-radius:var(--radius-sm); border:1px solid var(--color-border); background-color:var(--color-warning-bg); color:var(--color-accent-dark);">
                                    <i class="bi bi-person-video3"></i> Bu sizin kendi kursunuzdur. Kurs içeriğini ve dersleri <strong>Eğitmen Panelinden</strong> yönetebilirsiniz.
                                </div>
                                <a class="btn btn-primary-custom w-100 mb-2" href="Instructor/Dashboard.aspx" style="font-size:15px;padding:10px;display:block;width:100%;text-align:center;">
                                    <i class="bi bi-grid-fill"></i> Eğitmen Paneline Git
                                </a>
                            <% } else { %>
                                <div class="alert alert-info text-center" style="font-size:13px; padding:10px; margin-bottom:12px; border-radius:var(--radius-sm); border:1px solid var(--color-border); background-color:var(--color-primary-light); color:var(--color-primary);">
                                    <i class="bi bi-exclamation-circle-fill"></i> Eğitmen hesapları platformdaki diğer eğitimleri satın alamaz veya sepetine ekleyemez.
                                </div>
                            <% } %>
                        <% } else { %>
                            <a class="btn btn-accent w-100 mb-2" href="Cart.aspx?add=<%= Course.CourseId %>" style="font-size:16px;padding:12px;display:block;width:100%;text-align:center;">
                                <i class="bi bi-cart-plus"></i> <%= Course.IsFree ? "Ücretsiz Kaydol" : "Sepete Ekle" %>
                            </a>
                            <a class="btn btn-outline-custom w-100 mb-3" href="Favorites.aspx?add=<%= Course.CourseId %>" style="display:block;width:100%;text-align:center;">
                                <i class="bi bi-heart"></i> Favorilere Ekle
                            </a>
                        <% } %>
                        <p class="text-muted text-center mb-3" style="font-size:12.5px;">30 gün iade garantisi</p>

                        <hr class="buy-box-divider" />

                        <div class="buy-box-meta">
                            <div class="buy-box-meta-row"><i class="bi bi-collection-play"></i> <%= Course.LessonCount %> ders içeriği</div>
                            <div class="buy-box-meta-row"><i class="bi bi-clock"></i> <%: Course.TotalHours %> saatlik video</div>
                            <div class="buy-box-meta-row"><i class="bi bi-infinity"></i> Ömür boyu erişim</div>
                            <div class="buy-box-meta-row"><i class="bi bi-phone"></i> Mobil ve masaüstü erişim</div>
                            <div class="buy-box-meta-row"><i class="bi bi-translate"></i> Dil: <%: Course.Language %></div>
                            <div class="buy-box-meta-row"><i class="bi bi-award"></i> Tamamlama sertifikası</div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <script>
        function showTab(tabId, btn) {
            document.querySelectorAll('.tab-panel').forEach(function(p){ p.classList.remove('active'); });
            document.querySelectorAll('.edu-tab').forEach(function(b){ b.classList.remove('active'); });
            document.getElementById(tabId).classList.add('active');
            btn.classList.add('active');
        }
    </script>

</asp:Content>
