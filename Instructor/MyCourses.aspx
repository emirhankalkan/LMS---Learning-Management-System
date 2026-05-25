<%@ Page Title="Kurslarım" Language="C#" MasterPageFile="~/Instructor/Instructor.master" AutoEventWireup="true" CodeBehind="MyCourses.aspx.cs" Inherits="EduFlow.Instructor.MyCourses" %>

<asp:Content ID="Content1" ContentPlaceHolderID="InstructorContent" runat="server">

  <div class="d-flex justify-content-between align-items-center mb-4">
    <span style="font-size:14px;color:var(--color-text-muted);">
      Toplam <strong style="color:var(--color-primary)"><%= TotalCount %></strong> kurs
    </span>
    <a href="AddCourse.aspx" class="btn btn-primary-custom btn-sm">
      <i class="bi bi-plus-lg"></i> Yeni Kurs Ekle
    </a>
  </div>

  <% if (!string.IsNullOrEmpty(Message)) { %>
  <div class="alert alert-success mb-3"><i class="bi bi-check-circle"></i> <%: Message %></div>
  <% } %>

  <div class="row g-3">
    <%= CourseCardsHtml %>
  </div>

  <% if (TotalCount == 0) { %>
  <div class="plain-card text-center" style="padding:60px 20px;">
    <i class="bi bi-collection-play" style="font-size:56px;color:var(--color-border);"></i>
    <h3 style="margin-top:16px;font-size:1.1rem;">Henüz kurs eklemediniz</h3>
    <p class="text-muted">İlk kursunuzu oluşturmak için aşağıdaki butona tıklayın.</p>
    <a href="AddCourse.aspx" class="btn btn-primary-custom mt-2">
      <i class="bi bi-plus-lg"></i> İlk Kursumu Ekle
    </a>
  </div>
  <% } %>

  <!-- İndirim Kodu Yönetim Modali -->
  <div id="discountModal" class="modal-custom-backdrop" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(28, 43, 58, 0.6); backdrop-filter:blur(4px); align-items:center; justify-content:center; z-index:1050;">
    <div class="modal-custom-card" style="background:var(--color-bg); border:1px solid var(--color-border); border-radius:var(--radius-lg); box-shadow:0 10px 30px rgba(0, 0, 0, 0.15); max-width:440px; width:90%; padding:24px;">
      <div class="modal-custom-header" style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid var(--color-border); padding-bottom:12px; margin-bottom:16px;">
        <h5 class="modal-custom-title" style="margin:0; font-size:1.15rem; font-weight:600; color:var(--color-primary); display:flex; align-items:center; gap:8px;">
          <i class="bi bi-tag-fill" style="color:var(--color-accent);"></i> İndirim Kodu Tanımla
        </h5>
        <button type="button" class="modal-custom-close" onclick="closeDiscountModal()" style="background:none; border:0; font-size:1.5rem; color:var(--color-text-muted); cursor:pointer;">&times;</button>
      </div>
      <div class="modal-custom-body" style="text-align:left;">
        <p class="text-muted" style="font-size:13.5px; line-height:1.5; margin-bottom:16px;">
          Kursunuza özel bir indirim kodu belirleyin. Öğrenciler bu kodu sepetlerinde kullanarak indirimden yararlanabilirler.
        </p>
        <div class="mb-3">
          <label class="form-label" style="font-weight:600; font-size:13px; color:var(--color-text-secondary);">Kurs Adı</label>
          <div id="lblCourseTitle" style="font-weight:700; color:var(--color-primary); font-size:14px; padding:10px; background:var(--color-surface); border-radius:var(--radius-sm);">Kurs</div>
        </div>
        <div class="mb-3">
          <label class="form-label" style="font-weight:600; font-size:13px; color:var(--color-text-secondary);">İndirim Kodu</label>
          <asp:TextBox ID="txtDiscountCode" runat="server" CssClass="form-control W-100" placeholder="Örn: BAHAR25" ClientIDMode="Static" style="text-transform:uppercase; font-weight:700; letter-spacing:1px; width: 100%;" />
        </div>
        <div class="mb-3">
          <label class="form-label" style="font-weight:600; font-size:13px; color:var(--color-text-secondary);">İndirim Oranı (%)</label>
          <asp:TextBox ID="txtDiscountPercentage" runat="server" type="number" min="1" max="99" CssClass="form-control W-100" placeholder="Örn: 25" ClientIDMode="Static" style="width: 100%;" />
        </div>
      </div>
      <div class="modal-custom-footer" style="display:flex; justify-content:flex-end; gap:8px; border-top:1px solid var(--color-border); padding-top:16px; margin-top:16px;">
        <button type="button" class="btn btn-outline-custom btn-sm" onclick="closeDiscountModal()">İptal</button>
        <asp:Button ID="btnSaveDiscount" runat="server" Text="İndirim Kodunu Kaydet" OnClick="btnSaveDiscount_Click" CssClass="btn btn-primary-custom btn-sm" ClientIDMode="Static" />
      </div>
    </div>
  </div>

  <asp:HiddenField ID="hdnSelectedCourseId" runat="server" ClientIDMode="Static" />

  <script type="text/javascript">
    function openDiscountModal(courseId, courseTitle, currentCode, currentPct) {
        document.getElementById('hdnSelectedCourseId').value = courseId;
        document.getElementById('lblCourseTitle').innerText = courseTitle;
        document.getElementById('txtDiscountCode').value = currentCode;
        document.getElementById('txtDiscountPercentage').value = currentPct > 0 ? currentPct : '';
        
        document.getElementById('discountModal').style.display = 'flex';
    }

    function closeDiscountModal() {
        document.getElementById('discountModal').style.display = 'none';
    }
  </script>

</asp:Content>
