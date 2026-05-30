<%@ Page Title="Hakkımızda" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="EduFlow.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <span class="hero-kicker"><i class="bi bi-mortarboard-fill"></i> Hakkımızda</span>
            <h1>Öğrenmeyi Herkes İçin Erişilebilir Kılıyoruz</h1>
            <p>EduFlow, yazılım, tasarım, veri bilimi ve iş becerilerini geliştirmek isteyen herkes için kurulmuş Türkçe bir online öğrenme platformudur.</p>
        </div>
    </div>

    <!-- Misyon -->
    <div class="section">
        <div class="container">
            <div class="row g-5 align-items-center">
                <div class="col-lg-6">
                    <span class="section-kicker">Misyonumuz</span>
                    <h2>Kaliteli Eğitimi Sınır Tanımaz Hale Getirmek</h2>
                    <p style="color:var(--color-text-secondary);font-size:16px;line-height:1.8;">
                        EduFlow olarak, kaliteli eğitimin coğrafi, ekonomik ya da sosyal engellerle kısıtlanmaması gerektiğine inanıyoruz.
                        Uzman eğitmenlerden hazırlanmış içeriklerle öğrencilerimizin kariyerlerinde gerçek bir fark yaratmalarına yardımcı oluyoruz.
                    </p>
                    <p style="color:var(--color-text-secondary);font-size:16px;line-height:1.8;">
                        Platformumuzda yazılım geliştirmeden grafik tasarıma, veri biliminden dijital pazarlamaya kadar geniş bir yelpazede kurslar bulunmaktadır.
                        Her seviyeden öğrenciye uygun içeriklerimizle kendi hızınızda ilerleyebilirsiniz.
                    </p>
                    <div style="display:flex;gap:12px;margin-top:24px;flex-wrap:wrap;">
                        <a href="Courses.aspx" class="btn-accent" style="padding:10px 22px;border-radius:6px;font-weight:500;display:inline-flex;align-items:center;gap:6px;">
                            <i class="bi bi-play-circle"></i> Kurslara Göz At
                        </a>
                        <a href="Register.aspx" class="btn-outline-custom" style="padding:10px 22px;border-radius:6px;font-weight:500;display:inline-flex;align-items:center;gap:6px;">
                            <i class="bi bi-person-plus"></i> Ücretsiz Katıl
                        </a>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;">
                        <div class="plain-card" style="text-align:center;padding:28px 20px;">
                            <div style="font-size:2.5rem;font-weight:600;color:var(--color-primary);">25+</div>
                            <div style="color:var(--color-text-muted);font-size:14px;margin-top:4px;">Kayıtlı Öğrenci</div>
                        </div>
                        <div class="plain-card" style="text-align:center;padding:28px 20px;">
                            <div style="font-size:2.5rem;font-weight:600;color:var(--color-primary);">18</div>
                            <div style="color:var(--color-text-muted);font-size:14px;margin-top:4px;">Aktif Kurs</div>
                        </div>
                        <div class="plain-card" style="text-align:center;padding:28px 20px;">
                            <div style="font-size:2.5rem;font-weight:600;color:var(--color-primary);">85+</div>
                            <div style="color:var(--color-text-muted);font-size:14px;margin-top:4px;">Video Ders</div>
                        </div>
                        <div class="plain-card" style="text-align:center;padding:28px 20px;">
                            <div style="font-size:2.5rem;font-weight:600;color:var(--color-primary);">10</div>
                            <div style="color:var(--color-text-muted);font-size:14px;margin-top:4px;">Uzman Eğitmen</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Değerlerimiz -->
    <div class="section section-surface">
        <div class="container">
            <div style="text-align:center;margin-bottom:36px;">
                <span class="section-kicker">Değerlerimiz</span>
                <h2 style="margin-top:6px;">Bizi Biz Yapan İlkeler</h2>
            </div>
            <div class="row g-4">
                <div class="col-md-6 col-lg-3">
                    <div class="feature-tile">
                        <i class="bi bi-lightbulb"></i>
                        <strong>Yenilikçilik</strong>
                        <span>Eğitim teknolojilerini yakından takip ederek platformumuzu sürekli geliştiriyor, en güncel içerikleri sunuyoruz.</span>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="feature-tile">
                        <i class="bi bi-people"></i>
                        <strong>Topluluk</strong>
                        <span>Öğrenciler ve eğitmenlerden oluşan güçlü bir öğrenme topluluğu kurarak birlikte büyümeyi hedefliyoruz.</span>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="feature-tile">
                        <i class="bi bi-shield-check"></i>
                        <strong>Güvenilirlik</strong>
                        <span>Kurs içeriklerinin kalitesini titizlikle denetliyor, öğrencilerimize yalnızca doğrulanmış bilgi sunuyoruz.</span>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="feature-tile">
                        <i class="bi bi-universal-access"></i>
                        <strong>Erişilebilirlik</strong>
                        <span>Ücretsiz kurslardan uygun fiyatlı sertifika programlarına kadar herkese hitap eden seçenekler sunuyoruz.</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Eğitmen Ekibi -->
    <div class="section">
        <div class="container">
            <div style="text-align:center;margin-bottom:36px;">
                <span class="section-kicker">Ekibimiz</span>
                <h2 style="margin-top:6px;">Uzman Eğitmenlerimiz</h2>
                <p style="color:var(--color-text-secondary);max-width:560px;margin:10px auto 0;">
                    Alanında uzman eğitmenlerimiz, gerçek dünya deneyimlerini kurslarına yansıtarak sizi kariyerinizde bir adım öne taşır.
                </p>
            </div>
            <div class="row g-4">
                <div class="col-md-6 col-lg-4">
                    <div class="plain-card" style="text-align:center;padding:28px;">
                        <div class="instructor-avatar" style="margin:0 auto 16px;font-size:22px;">MK</div>
                        <div style="font-weight:500;font-size:16px;">Mert Kaya</div>
                        <div style="color:var(--color-text-muted);font-size:13px;margin:4px 0 12px;">ASP.NET & SQL Server Uzmanı</div>
                        <div style="font-size:13px;color:var(--color-text-secondary);line-height:1.6;">
                            10+ yıl kurumsal yazılım geliştirme deneyimi. Microsoft sertifikalı yazılım mimarı.
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4">
                    <div class="plain-card" style="text-align:center;padding:28px;">
                        <div class="instructor-avatar" style="margin:0 auto 16px;font-size:22px;background:var(--color-accent);color:var(--color-accent-dark);">AY</div>
                        <div style="font-weight:500;font-size:16px;">Ayşe Yılmaz</div>
                        <div style="color:var(--color-text-muted);font-size:13px;margin:4px 0 12px;">Python & Veri Bilimi Uzmanı</div>
                        <div style="font-size:13px;color:var(--color-text-secondary);line-height:1.6;">
                            Makine öğrenmesi ve yapay zeka alanında 7 yıl araştırma ve eğitim deneyimi.
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4">
                    <div class="plain-card" style="text-align:center;padding:28px;">
                        <div class="instructor-avatar" style="margin:0 auto 16px;font-size:22px;background:var(--color-success-bg);color:var(--color-success);">CÖ</div>
                        <div style="font-weight:500;font-size:16px;">Can Öztürk</div>
                        <div style="color:var(--color-text-muted);font-size:13px;margin:4px 0 12px;">UI/UX & Grafik Tasarım Uzmanı</div>
                        <div style="font-size:13px;color:var(--color-text-secondary);line-height:1.6;">
                            100+ kurumsal proje deneyimi, tasarım düşüncesi ve kullanıcı deneyimi alanında uzman.
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- CTA Band -->
    <div class="cta-band">
        <div class="container">
            <h2>Öğrenmeye Bugün Başla</h2>
            <p>Binlerce öğrenciye katıl ve kariyerini bir üst seviyeye taşı.</p>
            <a href="Register.aspx" class="btn-accent" style="padding:12px 32px;border-radius:6px;font-size:16px;font-weight:500;display:inline-flex;align-items:center;gap:8px;text-decoration:none;">
                <i class="bi bi-rocket-takeoff"></i> Ücretsiz Kaydol
            </a>
        </div>
    </div>

</asp:Content>
