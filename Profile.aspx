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

            <% if (!string.IsNullOrEmpty(ErrorMsg)) { %>
            <div class="alert alert-danger mb-4"><i class="bi bi-exclamation-circle"></i> <%: ErrorMsg %></div>
            <% } %>
            <% if (!string.IsNullOrEmpty(SuccessMsg)) { %>
            <div class="alert alert-success mb-4"><i class="bi bi-check-circle"></i> <%: SuccessMsg %></div>
            <% } %>

            <div class="row g-4">

                <!-- Profil Kartı -->
                <div class="col-lg-4">
                    <div class="plain-card text-center" style="padding:32px;">
                        <% if (CurrentUser != null && !string.IsNullOrEmpty(CurrentUser.PhotoUrl)) { %>
                        <img src="<%: CurrentUser.PhotoUrl %>" alt="Profil fotoğrafı"
                             style="width:90px;height:90px;border-radius:50%;object-fit:cover;margin:0 auto 16px;display:block;border:3px solid var(--color-primary-light);" />
                        <% } else { %>
                        <div style="width:90px;height:90px;border-radius:50%;background:var(--color-primary);color:#fff;font-size:2.5rem;font-weight:500;display:flex;align-items:center;justify-content:center;margin:0 auto 16px;">
                            <%: (CurrentUser?.FullName ?? Session["FullName"]?.ToString() ?? "?").Substring(0, 1).ToUpper() %>
                        </div>
                        <% } %>
                        <h2 style="font-size:1.3rem;margin-bottom:4px;"><%: CurrentUser?.FullName ?? Session["FullName"]?.ToString() ?? "—" %></h2>
                        <p class="text-muted" style="font-size:14px;"><%: CurrentUser?.Email ?? "—" %></p>
                        <span class="badge-level" style="margin-bottom:16px;display:inline-block;">
                            <%: CurrentUser?.RoleName == "Instructor" ? "Eğitmen" : CurrentUser?.RoleName == "Admin" ? "Yönetici" : "Öğrenci" %>
                        </span>
                        <div class="divider"></div>
                        <div class="row g-2 mt-2">
                            <div class="col-4">
                                <div style="font-size:1.4rem;font-weight:500;color:var(--color-primary)"><%: CurrentUser?.EnrolledCourses ?? 0 %></div>
                                <div style="font-size:12px;color:var(--color-text-muted)">Kurs</div>
                            </div>
                            <div class="col-4">
                                <div style="font-size:1.4rem;font-weight:500;color:var(--color-primary)"><%: CurrentUser?.CompletedLessonsTotal ?? 0 %></div>
                                <div style="font-size:12px;color:var(--color-text-muted)">Ders</div>
                            </div>
                            <div class="col-4">
                                <div style="font-size:1.4rem;font-weight:500;color:var(--color-primary)">0</div>
                                <div style="font-size:12px;color:var(--color-text-muted)">Sertifika</div>
                            </div>
                        </div>
                    </div>

                    <!-- Navigasyon -->
                    <div class="plain-card mt-3" style="padding:8px 0;">
                        <a href="Dashboard.aspx" style="display:flex;align-items:center;gap:10px;padding:11px 18px;font-size:14px;color:var(--color-text-secondary);">
                            <i class="bi bi-grid" style="color:var(--color-primary)"></i> Panelime Dön
                        </a>
                        <a href="OrderHistory.aspx" style="display:flex;align-items:center;gap:10px;padding:11px 18px;font-size:14px;color:var(--color-text-secondary);">
                            <i class="bi bi-receipt" style="color:var(--color-primary)"></i> Sipariş Geçmişim
                        </a>
                        <a href="Favorites.aspx" style="display:flex;align-items:center;gap:10px;padding:11px 18px;font-size:14px;color:var(--color-text-secondary);">
                            <i class="bi bi-heart" style="color:var(--color-primary)"></i> Favorilerim
                        </a>
                        <div class="divider" style="margin:4px 18px;"></div>
                        <a href="Logout.aspx" style="display:flex;align-items:center;gap:10px;padding:11px 18px;font-size:14px;color:var(--color-danger);">
                            <i class="bi bi-box-arrow-right"></i> Çıkış Yap
                        </a>
                    </div>
                </div>

                <!-- Formlar -->
                <div class="col-lg-8">

                    <!-- Kişisel Bilgiler -->
                    <div class="plain-card mb-4">
                        <h2 style="font-size:1.1rem;margin-bottom:20px;"><i class="bi bi-person" style="color:var(--color-primary)"></i> Kişisel Bilgiler</h2>
                        <input type="hidden" name="profileAction" id="profileActionField" value="" />
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Ad Soyad</label>
                                <input class="form-control" type="text" name="fullName" id="fullName"
                                       value="<%: CurrentUser?.FullName ?? Session["FullName"]?.ToString() ?? "" %>" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">E-posta</label>
                                <input class="form-control" type="email" value="<%: CurrentUser?.Email ?? "" %>" disabled
                                       style="background:var(--color-surface);color:var(--color-text-muted);" />
                            </div>
                        </div>
                        <div class="mt-3">
                            <button type="submit" class="btn btn-primary-custom btn-sm"
                                    onclick="document.getElementById('profileActionField').value='updateProfile';">
                                <i class="bi bi-check2"></i> Kaydet
                            </button>
                        </div>
                    </div>

                    <!-- Şifre Değiştir -->
                    <div class="plain-card mb-4">
                        <h2 style="font-size:1.1rem;margin-bottom:20px;"><i class="bi bi-shield-lock" style="color:var(--color-primary)"></i> Şifre Değiştir</h2>
                        <div class="row g-3">
                            <div class="col-12">
                                <label class="form-label">Mevcut Şifre</label>
                                <input class="form-control" type="password" name="oldPassword" placeholder="••••••••" autocomplete="current-password" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Yeni Şifre</label>
                                <input class="form-control" type="password" name="newPassword" placeholder="En az 6 karakter" autocomplete="new-password" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Yeni Şifre Tekrar</label>
                                <input class="form-control" type="password" name="newPassword2" placeholder="Tekrar girin" autocomplete="new-password" />
                            </div>
                        </div>
                        <div class="mt-3">
                            <button type="submit" class="btn btn-primary-custom btn-sm"
                                    onclick="document.getElementById('profileActionField').value='changePassword';">
                                <i class="bi bi-check2"></i> Şifreyi Güncelle
                            </button>
                        </div>
                    </div>

                    <!-- Profil Fotoğrafı -->
                    <div class="plain-card">
                        <h2 style="font-size:1.1rem;margin-bottom:16px;"><i class="bi bi-camera" style="color:var(--color-primary)"></i> Profil Fotoğrafı</h2>
                        <p class="text-muted" style="font-size:14px;">JPG, PNG veya GIF formatında, maksimum 2MB</p>
                        <input type="file" class="form-control" name="profilePhoto" id="profilePhoto"
                               accept=".jpg,.jpeg,.png,.gif" />
                        <button type="submit" class="btn btn-primary-custom btn-sm mt-3"
                                onclick="document.getElementById('profileActionField').value='uploadPhoto';">
                            <i class="bi bi-upload"></i> Yükle
                        </button>
                    </div>

                </div>

            </div>
        </div>
    </section>

</asp:Content>
