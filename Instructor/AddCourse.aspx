<%@ Page Title="Yeni Kurs Ekle" Language="C#" MasterPageFile="~/Instructor/Instructor.master" AutoEventWireup="true" CodeBehind="AddCourse.aspx.cs" Inherits="EduFlow.Instructor.AddCourse" %>

<asp:Content ID="Content1" ContentPlaceHolderID="InstructorContent" runat="server">

<% if (!string.IsNullOrEmpty(ErrorMsg)) { %>
<div class="alert alert-danger mb-3"><i class="bi bi-exclamation-circle"></i> <%: ErrorMsg %></div>
<% } %>
<% if (!string.IsNullOrEmpty(SuccessMsg)) { %>
<div class="alert alert-success mb-3"><i class="bi bi-check-circle"></i> <%: SuccessMsg %></div>
<% } %>

<!-- Adım göstergesi -->
<div style="display:flex;gap:0;margin-bottom:28px;border-radius:12px;overflow:hidden;border:1px solid var(--color-border);">
  <div id="step1-indicator" onclick="goToStep1()" style="flex:1;padding:12px;text-align:center;font-size:13px;font-weight:600;background:var(--color-primary);color:#fff;cursor:pointer;">
    <i class="bi bi-1-circle-fill"></i> Kurs Bilgileri
  </div>
  <div id="step2-indicator" onclick="goToStep2View()" style="flex:1;padding:12px;text-align:center;font-size:13px;font-weight:600;background:var(--color-surface);color:var(--color-text-muted);cursor:pointer;">
    <i class="bi bi-2-circle"></i> Ders Ekle
  </div>
</div>

<!-- ADIM 1: Kurs Bilgileri -->
<div id="step1" class="plain-card">
  <h2 style="font-size:1.1rem;margin-bottom:20px;"><%= Request.QueryString["edit"] != null ? "<i class='bi bi-pencil-square'></i> Kurs Bilgilerini Düzenle" : "<i class='bi bi-info-circle'></i> Kurs Bilgileri" %></h2>

  <div class="row g-3">
    <div class="col-md-6 discount-field" style="<%= PriceType == "paid" ? "" : "display:none;" %>">
      <label class="form-label">Ä°ndirim Kodu <small class="text-muted">(opsiyonel)</small></label>
      <input class="form-control" id="discountCode" name="discountCode" type="text"
             maxlength="50" placeholder="Ã–rn: YAZILIM25" value="<%: DiscountCode %>"
             style="text-transform:uppercase;" />
      <small class="text-muted">Ã–ÄŸrenciler bu kodu sepette kullanabilir.</small>
    </div>

    <div class="col-md-6 discount-field" style="<%= PriceType == "paid" ? "" : "display:none;" %>">
      <label class="form-label">Ä°ndirim YÃ¼zdesi (%)</label>
      <input class="form-control" id="discountPercent" name="discountPercent" type="number" min="1" max="99" step="1"
             placeholder="Ã–rn: 25" value="<%: DiscountPercent %>" />
    </div>

    <div class="col-12">
      <label class="form-label">Kurs Başlığı <span style="color:var(--color-danger)">*</span></label>
      <input class="form-control" id="courseTitle" name="courseTitle" type="text"
             placeholder="Örn: Python ile Veri Bilimi ve Makine Öğrenmesi"
             value="<%: CourseTitle %>" required />
    </div>

    <div class="col-12">
      <label class="form-label">Kurs Açıklaması <span style="color:var(--color-danger)">*</span></label>
      <textarea class="form-control" id="courseDesc" name="courseDesc" rows="4"
                placeholder="Öğrenciler bu kursta neler öğrenecek? Ne kadar detaylı yazarsanız o kadar iyi."
                style="resize:vertical;"><%: CourseDesc %></textarea>
    </div>

    <div class="col-md-6">
      <label class="form-label">Kategori <span style="color:var(--color-danger)">*</span></label>
      <select class="form-control" id="courseCat" name="courseCat" style="appearance:auto;">
        <option value="0">-- Kategori seçin --</option>
        <% foreach (var cat in Categories) { %>
        <option value="<%: cat.CategoryId %>" <%= cat.CategoryId.ToString() == SelectedCatId ? "selected" : "" %>><%: cat.Name %></option>
        <% } %>
      </select>
    </div>

    <div class="col-md-6">
      <label class="form-label">Seviye <span style="color:var(--color-danger)">*</span></label>
      <select class="form-control" id="courseLevel" name="courseLevel" style="appearance:auto;">
        <option value="Başlangıç" <%= SelectedLevel == "Başlangıç" ? "selected" : "" %>>Başlangıç</option>
        <option value="Orta Seviye" <%= SelectedLevel == "Orta Seviye" ? "selected" : "" %>>Orta Seviye</option>
        <option value="İleri Seviye" <%= SelectedLevel == "İleri Seviye" ? "selected" : "" %>>İleri Seviye</option>
      </select>
    </div>

    <div class="col-md-6">
      <label class="form-label">Dil</label>
      <select class="form-control" id="courseLang" name="courseLang" style="appearance:auto;">
        <option value="Türkçe" <%= SelectedLanguage == "Türkçe" ? "selected" : "" %>>Türkçe</option>
        <option value="İngilizce" <%= SelectedLanguage == "İngilizce" ? "selected" : "" %>>İngilizce</option>
      </select>
    </div>

    <div class="col-md-6">
      <label class="form-label">Fiyatlama</label>
      <div style="display:flex;gap:10px;align-items:center;">
        <div style="display:flex;align-items:center;gap:8px;padding:10px 14px;border:1px solid var(--color-border);border-radius:8px;cursor:pointer;" onclick="toggleFree(true)" id="freeOpt">
          <input type="radio" name="priceType" value="free" id="radioFree" <%= PriceType == "free" ? "checked" : "" %> style="cursor:pointer;" />
          <label for="radioFree" style="cursor:pointer;margin:0;font-size:14px;color:var(--color-success)"><i class="bi bi-gift"></i> Ücretsiz</label>
        </div>
        <div style="display:flex;align-items:center;gap:8px;padding:10px 14px;border:1px solid var(--color-border);border-radius:8px;cursor:pointer;" onclick="toggleFree(false)" id="paidOpt">
          <input type="radio" name="priceType" value="paid" id="radioPaid" <%= PriceType == "paid" ? "checked" : "" %> style="cursor:pointer;" />
          <label for="radioPaid" style="cursor:pointer;margin:0;font-size:14px;"><i class="bi bi-tag"></i> Ücretli</label>
        </div>
      </div>
    </div>

    <div class="col-md-6" id="priceField" style="<%= PriceType == "paid" ? "" : "display:none;" %>">
      <label class="form-label">Fiyat (₺)</label>
      <input class="form-control" id="coursePrice" name="coursePrice" type="number" min="0" step="1"
             placeholder="Örn: 999" value="<%: CoursePrice %>" />
    </div>

    <div class="col-12">
      <label class="form-label">Kapak Görseli URL <small class="text-muted">(opsiyonel — Unsplash linki önerilir)</small></label>
      <input class="form-control" id="thumbUrl" name="thumbUrl" type="url"
             placeholder="https://images.unsplash.com/..."
             value="<%: ThumbnailUrl %>" />
    </div>
  </div>

  <div class="d-flex justify-content-between mt-4">
    <a href="MyCourses.aspx" class="btn btn-outline-custom">İptal</a>
    <button type="button" class="btn btn-primary-custom" onclick="goToStep2()">
      <%= Request.QueryString["edit"] != null ? "Güncelle ve Devam Et <i class='bi bi-arrow-right'></i>" : "Devam: Ders Ekle <i class='bi bi-arrow-right'></i>" %>
    </button>
  </div>
</div>

<!-- ADIM 2: Ders Ekleme -->
<div id="step2" style="display:none;">

  <% if (NewCourseId > 0) { %>
  <!-- Kurs oluşturuldu, ders ekle -->
  <div class="plain-card mb-3" style="border-left:4px solid #5DF0C1;">
    <strong style="color:#5DF0C1;"><i class="bi bi-check-circle-fill"></i> Kurs oluşturuldu!</strong>
    <p class="text-muted mb-0" style="font-size:13px;">Şimdi dersleri ekleyebilirsiniz. İstediğiniz zaman <a href="MyCourses.aspx">kurs listesine</a> dönebilirsiniz.</p>
  </div>

  <div class="plain-card mb-3">
    <h3 style="font-size:1rem;margin-bottom:16px;"><i class="bi bi-plus-circle"></i> Yeni Ders Ekle</h3>
    <div class="row g-3">
      <div class="col-md-6">
        <label class="form-label">Ders Başlığı <span style="color:var(--color-danger)">*</span></label>
        <input class="form-control" id="lessonTitle" name="lessonTitle" type="text" placeholder="Örn: Giriş ve Kurulum" />
      </div>
      <div class="col-md-3">
        <label class="form-label">Süre (dakika)</label>
        <input class="form-control" id="lessonDuration" name="lessonDuration" type="number" min="1" placeholder="30" />
      </div>
      <div class="col-md-3">
        <label class="form-label">Önizleme?</label>
        <select class="form-control" id="lessonPreview" name="lessonPreview" style="appearance:auto;">
          <option value="false">Hayır</option>
          <option value="true">Evet (ücretsiz)</option>
        </select>
      </div>
      <div class="col-12">
        <label class="form-label">Video Kaynağı</label>
        <div style="display:grid;gap:10px;">
          <input class="form-control" id="lessonVideo" name="lessonVideo" type="url"
                 placeholder="YouTube/Vimeo linki: https://www.youtube.com/watch?v=..." />
          <div style="display:flex;align-items:center;gap:10px;color:var(--color-text-muted);font-size:12px;">
            <span style="height:1px;background:var(--color-border);flex:1;"></span>
            <span>veya</span>
            <span style="height:1px;background:var(--color-border);flex:1;"></span>
          </div>
          <input class="form-control" id="lessonVideoFile" name="lessonVideoFile" type="file" accept="video/mp4,video/webm,video/quicktime" />
          <small class="text-muted">MP4, WebM veya MOV yükleyebilirsiniz. Link girerseniz dosya yüklemeniz gerekmez.</small>
        </div>
      </div>
    </div>
    <input type="hidden" name="newCourseId" value="<%= NewCourseId %>" />
    <button type="submit" name="action" value="addLesson" class="btn btn-primary-custom mt-3">
      <i class="bi bi-plus-lg"></i> Ders Ekle
    </button>
  </div>

  <!-- Eklenen Dersler -->
  <div class="plain-card" style="padding:0;overflow:hidden;">
    <div style="padding:16px 20px;border-bottom:1px solid var(--color-border);">
      <strong><i class="bi bi-list-ol"></i> Dersler (<%= LessonCount %>)</strong>
    </div>
    <% if (LessonCount == 0) { %>
    <p class="text-muted text-center" style="padding:20px;">Henüz ders eklenmedi.</p>
    <% } else { %>
    <div class="table-responsive">
      <table class="table table-hover" style="margin:0;">
        <thead><tr><th style="padding:12px 16px;">#</th><th>Başlık</th><th>Süre</th><th>Önizleme</th><th style="text-align:right;padding-right:20px;width:160px;">İşlemler</th></tr></thead>
        <tbody><%= LessonsHtml %></tbody>
      </table>
    </div>
    <% } %>
  </div>

  <div class="d-flex justify-content-end mt-4 gap-2">
    <a href="MyCourses.aspx" class="btn btn-primary-custom"><i class="bi bi-check2"></i> Tamamlandı</a>
  </div>
  <% } else { %>
  <!-- Kurs henüz oluşturulmamış → ilk adımdan gelsin -->
  <div class="plain-card text-center" style="padding:40px;">
    <p class="text-muted">Lütfen önce kurs bilgilerini doldurun.</p>
    <button type="button" class="btn btn-outline-custom mt-2" onclick="goToStep1()">← Geri Dön</button>
  </div>
  <% } %>
</div>

<input type="hidden" name="hfAction" id="formAction" value="" />
<input type="hidden" name="existingCourseId" id="existingCourseId" value="<%= NewCourseId %>" />
<input type="hidden" name="targetLessonId" id="targetLessonId" value="" />
<input type="hidden" name="moveDirection" id="moveDirection" value="" />

<script>
  function goToStep2() {
    // Validasyon
    var title = document.getElementById('courseTitle').value.trim();
    var desc  = document.getElementById('courseDesc').value.trim();
    var cat   = document.getElementById('courseCat').value;
    if (!title) { alert('Kurs başlığı zorunludur.'); return; }
    if (!desc)  { alert('Kurs açıklaması zorunludur.'); return; }
    if (cat === '0') { alert('Lütfen bir kategori seçin.'); return; }

    // Formu submit et
    var isEdit = '<%= Request.QueryString["edit"] != null ? "1" : "0" %>' === '1'
      || document.getElementById('existingCourseId').value !== '0';
    document.getElementById('formAction').value = isEdit ? 'updateCourse' : 'createCourse';
    document.querySelector('form').submit();
  }

  function goToStep1() {
    document.getElementById('step1').style.display = 'block';
    document.getElementById('step2').style.display = 'none';
    setStepIndicator(1);
  }

  function goToStep2View() {
    var hasCourse = document.getElementById('existingCourseId').value !== '0';
    if (!hasCourse) return;
    document.getElementById('step1').style.display = 'none';
    document.getElementById('step2').style.display = 'block';
    setStepIndicator(2);
  }

  function setStepIndicator(activeStep) {
    var step1 = document.getElementById('step1-indicator');
    var step2 = document.getElementById('step2-indicator');
    step1.style.background = activeStep === 1 ? 'var(--color-primary)' : 'var(--color-surface)';
    step1.style.color = activeStep === 1 ? '#fff' : 'var(--color-text-muted)';
    step2.style.background = activeStep === 2 ? 'var(--color-primary)' : 'var(--color-surface)';
    step2.style.color = activeStep === 2 ? '#fff' : 'var(--color-text-muted)';
  }

  function deleteLesson(lessonId) {
    if (confirm('Bu dersi ve ekli videosunu kaldırmak istediğinizden emin misiniz?')) {
      document.getElementById('formAction').value = 'deleteLesson';
      document.getElementById('targetLessonId').value = lessonId;
      document.querySelector('form').submit();
    }
  }

  function moveLesson(lessonId, direction) {
    document.getElementById('formAction').value = 'moveLesson';
    document.getElementById('targetLessonId').value = lessonId;
    document.getElementById('moveDirection').value = direction;
    document.querySelector('form').submit();
  }

  function toggleFree(isFree) {
    document.getElementById('radioFree').checked = isFree;
    document.getElementById('radioPaid').checked = !isFree;
    document.getElementById('priceField').style.display = isFree ? 'none' : '';
    document.querySelectorAll('.discount-field').forEach(function(field) {
      field.style.display = isFree ? 'none' : '';
    });
  }

  // Sayfa yüklenince adım durumuna göre göster
  (function(){
    var hasCourse = '<%= NewCourseId > 0 ? "1" : "0" %>' === '1';
    if (hasCourse) {
      goToStep2View();
    }
  })();
</script>

</asp:Content>
