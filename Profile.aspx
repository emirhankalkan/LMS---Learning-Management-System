<%@ Page Title="Profilim" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="EduFlow.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <section class="page-header" style="padding:28px 0;">
        <div class="container">
            <h1 style="font-size:1.6rem;margin-bottom:4px;"><i class="bi bi-person-circle" style="color:var(--color-accent)"></i> Profilim</h1>
            <p>Hesap bilgilerini ve şifreni yönet</p>
        </div>
    </section>

    <section class="section" style="padding-top:28px;">
        <div class="container">
            <div class="row g-4">

                <!-- Profile Card -->
                <div class="col-lg-4">
                    <div class="plain-card text-center" style="padding:32px;">
                        <div style="width:90px;height:90px;border-radius:50%;background:var(--color-primary);color:#fff;font-size:2.5rem;font-weight:500;display:flex;align-items:center;justify-content:center;margin:0 auto 16px;">Ö</div>
                        <h2 style="font-size:1.3rem;margin-bottom:4px;">Öğrenci Kullanıcı</h2>
                        <p class="text-muted" style="font-size:14px;">ogrenci@eduflow.test</p>
                        <span class="badge-level" style="margin-bottom:16px;display:inline-block;">Öğrenci</span>
                        <div class="divider"></div>
                        <div class="row g-2 mt-2">
                            <div class="col-4">
                                <div style="font-size:1.4rem;font-weight:500;color:var(--color-primary)">2</div>
                                <div style="font-size:12px;color:var(--color-text-muted)">Kurs</div>
                            </div>
                            <div class="col-4">
                                <div style="font-size:1.4rem;font-weight:500;color:var(--color-primary)">7</div>
                                <div style="font-size:12px;color:var(--color-text-muted)">Ders</div>
                            </div>
                            <div class="col-4">
                                <div style="font-size:1.4rem;font-weight:500;color:var(--color-primary)">0</div>
                                <div style="font-size:12px;color:var(--color-text-muted)">Sertifika</div>
                            </div>
                        </div>
                    </div>

                    <!-- Navigation -->
                    <div class="plain-card mt-3" style="padding:8px 0;">
                        <a href="Dashboard.aspx" style="display:flex;align-items:center;gap:10px;padding:11px 18px;font-size:14px;color:var(--color-text-secondary);border-radius:var(--radius-sm);">
                            <i class="bi bi-grid" style="color:var(--color-primary)"></i> Panelime Dön
                        </a>
                        <a href="OrderHistory.aspx" style="display:flex;align-items:center;gap:10px;padding:11px 18px;font-size:14px;color:var(--color-text-secondary);border-radius:var(--radius-sm);">
                            <i class="bi bi-receipt" style="color:var(--color-primary)"></i> Sipariş Geçmişim
                        </a>
                        <a href="Favorites.aspx" style="display:flex;align-items:center;gap:10px;padding:11px 18px;font-size:14px;color:var(--color-text-secondary);border-radius:var(--radius-sm);">
                            <i class="bi bi-heart" style="color:var(--color-primary)"></i> Favorilerim
                        </a>
                        <div class="divider" style="margin:4px 18px;"></div>
                        <a href="Logout.aspx" style="display:flex;align-items:center;gap:10px;padding:11px 18px;font-size:14px;color:var(--color-danger);border-radius:var(--radius-sm);">
                            <i class="bi bi-box-arrow-right"></i> Çıkış Yap
                        </a>
                    </div>
                </div>

                <!-- Edit Forms -->
                <div class="col-lg-8">
                    <!-- Profile Info -->
                    <div class="plain-card mb-4">
                        <h2 style="font-size:1.1rem;margin-bottom:20px;"><i class="bi bi-person" style="color:var(--color-primary)"></i> Kişisel Bilgiler</h2>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Ad Soyad</label>
                                <input class="form-control" type="text" value="Öğrenci Kullanıcı" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">E-posta</label>
                                <input class="form-control" type="email" value="ogrenci@eduflow.test" />
                            </div>
                            <div class="col-12">
                                <label class="form-label">Hakkımda (isteğe bağlı)</label>
                                <textarea class="form-control" rows="3" placeholder="Kendinizi kısaca tanıtın..."></textarea>
                            </div>
                        </div>

                        <div class="mt-3">
                            <button class="btn btn-primary-custom btn-sm"><i class="bi bi-check2"></i> Kaydet</button>
                        </div>
                    </div>

                    <!-- Change Password -->
                    <div class="plain-card mb-4">
                        <h2 style="font-size:1.1rem;margin-bottom:20px;"><i class="bi bi-shield-lock" style="color:var(--color-primary)"></i> Şifre Değiştir</h2>
                        <div class="row g-3">
                            <div class="col-12">
                                <label class="form-label">Mevcut Şifre</label>
                                <input class="form-control" type="password" placeholder="••••••••" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Yeni Şifre</label>
                                <input class="form-control" type="password" placeholder="En az 6 karakter" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Yeni Şifre Tekrar</label>
                                <input class="form-control" type="password" placeholder="Tekrar girin" />
                            </div>
                        </div>
                        <div class="mt-3">
                            <button class="btn btn-primary-custom btn-sm"><i class="bi bi-check2"></i> Şifreyi Güncelle</button>
                        </div>
                    </div>

                    <!-- Photo Upload -->
                    <div class="plain-card">
                        <h2 style="font-size:1.1rem;margin-bottom:16px;"><i class="bi bi-camera" style="color:var(--color-primary)"></i> Profil Fotoğrafı</h2>
                        <p class="text-muted" style="font-size:14px;">JPG, PNG veya GIF formatında, maksimum 2MB</p>
                        <input type="file" class="form-control" accept="image/*" />
                        <button class="btn btn-primary-custom btn-sm mt-3"><i class="bi bi-upload"></i> Yükle</button>
                    </div>
                </div>

            </div>
        </div>
    </section>

</asp:Content>
