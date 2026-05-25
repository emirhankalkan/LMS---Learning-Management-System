<%@ Page Title="Ana Sayfa" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="EduFlow._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- ===== HERO ===== -->
    <section class="hero home-hero">
        <div class="container">
            <div class="row align-items-center g-5">
                <div class="col-lg-7">
                    <span class="hero-kicker"><i class="bi bi-lightning-charge-fill"></i> Türkiye'nin büyüyen öğrenme platformu</span>
                    <h1>Hedefine uygun kursu bul,<br />kariyerini bir üst seviyeye taşı.</h1>
                    <p class="mb-4">Yazılım, tasarım, veri bilimi ve iş becerilerinde uzman eğitmenlerden Türkçe kurslar. Kendi hızında, istediğin yerden öğren.</p>
                    <div class="hero-search mb-3">
                        <i class="bi bi-search"></i>
                        <input type="search" id="heroSearchInput" aria-label="Kurs ara" placeholder="Ne öğrenmek istiyorsun? (örn: Python, React, SQL...)" />
                        <a class="btn btn-accent" href="Courses.aspx" id="heroSearchBtn">Ara</a>
                    </div>
                    <p style="color:var(--color-on-primary-muted); font-size:13px;">
                        <strong style="color:var(--color-accent)">Popüler:</strong>
                        <a href="Courses.aspx?category=1" style="color:var(--color-on-primary-muted);text-decoration:underline;margin:0 6px;">Yazılım</a>
                        <a href="Courses.aspx?category=3" style="color:var(--color-on-primary-muted);text-decoration:underline;margin:0 6px;">Veri Bilimi</a>
                        <a href="Courses.aspx?category=2" style="color:var(--color-on-primary-muted);text-decoration:underline;margin:0 6px;">Figma</a>
                        <a href="Courses.aspx?category=6" style="color:var(--color-on-primary-muted);text-decoration:underline;margin:0 6px;">Pazarlama</a>
                    </p>
                </div>
                <div class="col-lg-5">
                    <div class="hero-panel">
                        <div class="hero-panel-header">
                            <span>Devam ettiğin kurs</span>
                            <strong>Python ile Veri Bilimi</strong>
                        </div>
                        <div class="hero-progress">
                            <div class="d-flex justify-content-between">
                                <span>4/8 ders tamamlandı</span>
                                <strong>50%</strong>
                            </div>
                            <div class="progress"><div class="progress-bar" style="width:50%"></div></div>
                        </div>
                        <div class="hero-panel-row">
                            <i class="bi bi-play-circle"></i>
                            <div>
                                <strong>Sonraki ders</strong>
                                <span>Scikit-Learn ile Lineer Regresyon</span>
                            </div>
                        </div>
                        <div class="hero-panel-row">
                            <i class="bi bi-trophy"></i>
                            <div>
                                <strong>Sertifikaya yakın</strong>
                                <span>4 ders daha tamamla, sertifikanı kazan</span>
                            </div>
                        </div>
                        <div class="hero-panel-row">
                            <i class="bi bi-people"></i>
                            <div>
                                <strong>7.412 öğrenci birlikte öğreniyor</strong>
                                <span>4.9 ★ puan — en çok tercih edilen kurs</span>
                            </div>
                        </div>
                        <a class="btn btn-primary-custom w-100 mt-4" href="CourseDetail.aspx?id=5">
                            <i class="bi bi-play-circle"></i> Devam Et
                        </a>
                    </div>
                </div>
            </div>
            <div class="hero-stats">
                <div><strong>12.000+</strong><span>Aktif Öğrenci</span></div>
                <div><strong>48</strong><span>Uzman Kurs</span></div>
                <div><strong>4.7/5</strong><span>Ortalama Puan</span></div>
                <div><strong>%94</strong><span>Memnuniyet Oranı</span></div>
            </div>
        </div>
    </section>

    <!-- ===== TRUST BAR ===== -->
    <div class="trust-bar">
        <div class="container">
            <div class="trust-bar-inner">
                <div class="trust-item"><i class="bi bi-shield-check"></i> <span><strong>Güvenli ödeme</strong> — İyzico altyapısı</span></div>
                <div class="trust-item"><i class="bi bi-award"></i> <span><strong>Tamamlama sertifikası</strong> her kursta</span></div>
                <div class="trust-item"><i class="bi bi-phone"></i> <span><strong>Her cihazda</strong> erişim</span></div>
                <div class="trust-item"><i class="bi bi-arrow-counterclockwise"></i> <span><strong>30 gün</strong> iade garantisi</span></div>
                <div class="trust-item"><i class="bi bi-translate"></i> <span><strong>%100 Türkçe</strong> içerik</span></div>
            </div>
        </div>
    </div>

    <!-- ===== KATEGORİLER ===== -->
    <section class="section section-surface">
        <div class="container">
            <div class="section-heading">
                <div>
                    <span class="section-kicker">Kategoriler</span>
                    <h2>Bugün ne öğrenmek istersin?</h2>
                </div>
                <a href="Courses.aspx">Tüm kurslar <i class="bi bi-arrow-right"></i></a>
            </div>
            <div class="row g-3"><%= CategoryCardsHtml %></div>
        </div>
    </section>

    <!-- ===== ÖNE ÇIKAN KURSLAR ===== -->
    <section class="section">
        <div class="container">
            <div class="section-heading">
                <div>
                    <span class="section-kicker">Popüler seçimler</span>
                    <h2>Öne çıkan kurslar</h2>
                </div>
                <a href="Courses.aspx">Kurs kataloğu <i class="bi bi-arrow-right"></i></a>
            </div>
            <div class="row g-4"><%= FeaturedCoursesHtml %></div>
        </div>
    </section>

    <!-- ===== NASIL ÇALIŞIR ===== -->
    <section class="section section-surface">
        <div class="container">
            <div class="text-center mb-5">
                <span class="section-kicker">EduFlow Deneyimi</span>
                <h2>Satın almadan izlemeye, net ve basit bir akış</h2>
            </div>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="feature-tile">
                        <i class="bi bi-search"></i>
                        <strong>1 — Keşfet</strong>
                        <span>Kategorilere göre filtrele, arama yap, kurs detaylarını ve ders önizlemelerini incele. Ücretsiz dersleri hemen izle.</span>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-tile">
                        <i class="bi bi-credit-card"></i>
                        <strong>2 — Kaydol</strong>
                        <span>Sepete ekle, güvenli İyzico altyapısıyla ödeme yap. Birden fazla kurs için sepette indirim fırsatını yakala.</span>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-tile">
                        <i class="bi bi-graph-up-arrow"></i>
                        <strong>3 — Öğren & İlerle</strong>
                        <span>Dersleri tamamla, ilerleme yüzdenizi takip et, yorum bırak. Tüm kurs bittğinde sertifikanı indir.</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ===== ÜCRETSİZ KURSLAR ===== -->
    <section class="section">
        <div class="container">
            <div class="section-heading">
                <div>
                    <span class="section-kicker">Hemen başla</span>
                    <h2>Ücretsiz kurslar</h2>
                </div>
                <a href="Courses.aspx">Tümünü gör <i class="bi bi-arrow-right"></i></a>
            </div>
            <div class="row g-4"><%= FreeCoursesHtml %></div>
        </div>
    </section>

    <!-- ===== TESTİMONYALLAR ===== -->
    <section class="section section-surface">
        <div class="container">
            <div class="text-center mb-5">
                <span class="section-kicker">Öğrenci Yorumları</span>
                <h2>12.000 öğrenci ne diyor?</h2>
            </div>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="testimonial-card">
                        <div class="star-rating mb-2">
                            <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                        </div>
                        <p class="quote">ASP.NET Web Forms kursunu bitirdikten sonra şirketimde projeme başladım. Konu anlatımı son derece net, her adım pratikle pekiştiriliyor. Bu kaliteyi beklemiyordum!</p>
                        <div class="testimonial-author">
                            <div class="av">AY</div>
                            <div>
                                <div class="name">Ayşe Yılmaz</div>
                                <div class="title">Junior .NET Developer</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="testimonial-card">
                        <div class="star-rating mb-2">
                            <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                        </div>
                        <p class="quote">Python Veri Bilimi kursunda Kaggle'da ilk madalyamı aldım! Ahmet Hoca gerçek projeler üzerinden anlatıyor, teori ile pratik arasındaki boşluğu mükemmel kapatıyor.</p>
                        <div class="testimonial-author">
                            <div class="av">MU</div>
                            <div>
                                <div class="name">Mert Ulusoy</div>
                                <div class="title">Veri Analisti, Garanti BBVA</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="testimonial-card">
                        <div class="star-rating mb-2">
                            <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-half"></i>
                        </div>
                        <p class="quote">Bootstrap kursunu ücretsiz başladım, bu kaliteye para ödememeye üzüldüm! Responsive tasarımı artık korkmadan uyguluyorum. EduFlow'u arkadaşlarıma da önerdim.</p>
                        <div class="testimonial-author">
                            <div class="av">KŞ</div>
                            <div>
                                <div class="name">Kemal Şahin</div>
                                <div class="title">Frontend Developer</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ===== CTA BAND ===== -->
    <section class="cta-band">
        <div class="container">
            <h2>Öğrenmeye bugün başla</h2>
            <p>12.000+ öğrenciye katıl. İlk kursun ücretsiz, sertifika dahil.</p>
            <div class="d-flex justify-content-center gap-3 flex-wrap">
                <a class="btn btn-accent" href="Courses.aspx"><i class="bi bi-collection-play"></i> Kursları İncele</a>
                <a class="btn btn-outline-light" href="Register.aspx"><i class="bi bi-person-plus"></i> Ücretsiz Kayıt Ol</a>
            </div>
        </div>
    </section>

</asp:Content>
