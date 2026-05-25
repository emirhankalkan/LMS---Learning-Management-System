<%@ Page Title="Kayıt Ol" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="EduFlow.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<section class="auth-wrap" style="padding:60px 0;">
  <div class="auth-card" style="max-width:520px;">

    <div class="auth-logo">
      <i class="bi bi-mortarboard-fill"></i>
      <strong>EduFlow</strong>
    </div>
    <h1 style="font-size:1.5rem;text-align:center;margin-bottom:6px;">Ücretsiz hesap oluştur</h1>
    <p class="text-muted text-center mb-4" style="font-size:14px;">Öğrenci ya da eğitmen olarak katıl</p>

    <% if (!string.IsNullOrEmpty(ErrorMessage)) { %>
    <div class="alert alert-danger mb-3"><i class="bi bi-exclamation-circle"></i> <%: ErrorMessage %></div>
    <% } %>
    <% if (!string.IsNullOrEmpty(SuccessMessage)) { %>
    <div class="alert alert-success mb-3"><i class="bi bi-check-circle"></i> <%: SuccessMessage %></div>
    <% } %>

    <!-- Rol Seçici -->
    <div class="role-tabs mb-4" style="display:flex;border:1px solid var(--color-border);border-radius:10px;overflow:hidden;">
      <button type="button" id="tab-student" onclick="selectRole('student')"
              style="flex:1;padding:12px;background:var(--color-primary);color:#fff;border:0;font-size:14px;font-weight:600;cursor:pointer;transition:all .2s;">
        <i class="bi bi-person-fill"></i> Öğrenci
      </button>
      <button type="button" id="tab-instructor" onclick="selectRole('instructor')"
              style="flex:1;padding:12px;background:var(--color-surface);color:var(--color-text-secondary);border:0;font-size:14px;font-weight:600;cursor:pointer;transition:all .2s;">
        <i class="bi bi-person-video3"></i> Eğitmen
      </button>
    </div>

    <input type="hidden" id="selectedRole" name="selectedRole" value="student" />

    <!-- Ortak Alanlar -->
    <div class="mb-3">
      <label class="form-label" for="fullname">Ad Soyad</label>
      <input class="form-control" id="fullname" name="fullname" type="text" placeholder="Adın ve soyadın" required value="<%: Request.Form["fullname"] %>" />
    </div>
    <div class="mb-3">
      <label class="form-label" for="email">E-posta adresi</label>
      <input class="form-control" id="email" name="email" type="email" placeholder="ornek@mail.com" required autocomplete="email" value="<%: Request.Form["email"] %>" />
    </div>
    <div class="mb-3">
      <label class="form-label" for="password">Şifre</label>
      <input class="form-control" id="password" name="password" type="password" placeholder="En az 6 karakter" required minlength="6" autocomplete="new-password" />
    </div>
    <div class="mb-4">
      <label class="form-label" for="password2">Şifre Tekrar</label>
      <input class="form-control" id="password2" name="password2" type="password" placeholder="Şifrenizi tekrar girin" required autocomplete="new-password" />
    </div>

    <!-- Eğitmen Ek Alanları -->
    <div id="instructor-fields" style="display:none;">
      <hr style="border-color:var(--color-border);margin:8px 0 20px;" />
      <p style="font-size:13px;color:var(--color-text-muted);margin-bottom:16px;">
        <i class="bi bi-info-circle" style="color:var(--color-primary);"></i>
        Eğitmen profilinizi oluşturmak için aşağıdaki bilgileri doldurun.
      </p>

      <div class="mb-3">
        <label class="form-label" for="categoryId">Uzmanlık Alanı <span style="color:var(--color-danger)">*</span></label>
        <select class="form-control" id="categoryId" name="categoryId" style="appearance:auto;">
          <option value="0">-- Alanınızı seçin --</option>
          <% foreach (var cat in Categories) { %>
          <option value="<%: cat.CategoryId %>"><%: cat.Name %></option>
          <% } %>
        </select>
      </div>

      <div class="mb-3">
        <label class="form-label" for="bio">Kısa Biyografi <span style="color:var(--color-danger)">*</span></label>
        <textarea class="form-control" id="bio" name="bio" rows="3"
                  placeholder="Kendinizi ve uzmanlığınızı kısaca tanıtın..."
                  style="resize:vertical;"><%: Request.Form["bio"] %></textarea>
      </div>

      <div class="mb-3">
        <label class="form-label" for="linkedin">LinkedIn URL <small class="text-muted">(opsiyonel)</small></label>
        <div style="display:flex;align-items:center;gap:8px;">
          <i class="bi bi-linkedin" style="color:#0A66C2;font-size:18px;"></i>
          <input class="form-control" id="linkedin" name="linkedin" type="url"
                 placeholder="https://linkedin.com/in/adınız" value="<%: Request.Form["linkedin"] %>" />
        </div>
      </div>

      <div class="mb-4">
        <label class="form-label" for="portfolio">Portfolio / Web Sitesi <small class="text-muted">(opsiyonel)</small></label>
        <div style="display:flex;align-items:center;gap:8px;">
          <i class="bi bi-globe" style="color:var(--color-primary);font-size:18px;"></i>
          <input class="form-control" id="portfolio" name="portfolio" type="url"
                 placeholder="https://sitenizkere.com" value="<%: Request.Form["portfolio"] %>" />
        </div>
      </div>
    </div>

    <button class="btn btn-accent w-100 mb-3" type="submit" id="submit-btn" style="padding:12px;font-size:16px;">
      <i class="bi bi-person-plus"></i> <span id="submit-text">Öğrenci Olarak Kayıt Ol</span>
    </button>

    <p class="text-muted text-center mb-3" style="font-size:12px;">
      Kayıt olarak <a href="#">Kullanım Koşullarını</a> ve <a href="#">Gizlilik Politikasını</a> kabul etmiş olursun.
    </p>

    <div style="text-align:center;position:relative;margin:16px 0;">
      <hr style="border-color:var(--color-border);" />
      <span style="position:absolute;top:-10px;left:50%;transform:translateX(-50%);background:var(--color-bg);padding:0 12px;color:var(--color-text-muted);font-size:13px;">zaten hesabın var mı?</span>
    </div>
    <p class="text-center mb-0" style="font-size:14px;">
      <a href="Login.aspx"><strong>Giriş yap</strong></a>
    </p>
  </div>
</section>

<script>
  // Sayfa yüklenince mevcut rol seçimini uygula
  (function () {
    var saved = document.getElementById('selectedRole').value;
    if (saved === 'instructor') selectRole('instructor');
  })();

  function selectRole(role) {
    document.getElementById('selectedRole').value = role;
    var isInstructor = role === 'instructor';

    var tabS = document.getElementById('tab-student');
    var tabI = document.getElementById('tab-instructor');
    var fields = document.getElementById('instructor-fields');
    var submitText = document.getElementById('submit-text');

    if (isInstructor) {
      tabI.style.background = 'var(--color-primary)';
      tabI.style.color = '#fff';
      tabS.style.background = 'var(--color-surface)';
      tabS.style.color = 'var(--color-text-secondary)';
      fields.style.display = 'block';
      submitText.textContent = 'Eğitmen Olarak Kayıt Ol';
    } else {
      tabS.style.background = 'var(--color-primary)';
      tabS.style.color = '#fff';
      tabI.style.background = 'var(--color-surface)';
      tabI.style.color = 'var(--color-text-secondary)';
      fields.style.display = 'none';
      submitText.textContent = 'Öğrenci Olarak Kayıt Ol';
    }
  }
</script>
</asp:Content>
