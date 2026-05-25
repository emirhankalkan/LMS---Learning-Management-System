<%@ Page Title="Öğrencilerim" Language="C#" MasterPageFile="~/Instructor/Instructor.master" AutoEventWireup="true" CodeBehind="Students.aspx.cs" Inherits="EduFlow.Instructor.Students" %>

<asp:Content ID="Content1" ContentPlaceHolderID="InstructorContent" runat="server">

  <div class="d-flex justify-content-between align-items-center mb-4">
    <span style="font-size:14px;color:var(--color-text-muted);">
      Toplam <strong style="color:var(--color-primary)"><%= TotalStudents %></strong> öğrenci
    </span>
    <div class="d-flex gap-2">
      <input type="search" class="form-control" id="studentSearch" placeholder="Öğrenci veya kurs ara..."
             style="width:220px;" oninput="filterTable()" />
    </div>
  </div>

  <div class="plain-card" style="padding:0;overflow:hidden;">
    <div class="table-responsive">
      <table class="table table-hover" id="studentsTable" style="margin:0;">
        <thead>
          <tr>
            <th style="padding:14px 16px;">#</th>
            <th>Öğrenci</th>
            <th>E-posta</th>
            <th>Kurs</th>
            <th>Kayıt Tarihi</th>
          </tr>
        </thead>
        <tbody>
          <%= StudentsHtml %>
        </tbody>
      </table>
    </div>
  </div>

  <% if (TotalStudents == 0) { %>
  <div class="plain-card text-center" style="padding:60px 20px;margin-top:16px;">
    <i class="bi bi-people" style="font-size:56px;color:var(--color-border);"></i>
    <h3 style="margin-top:16px;font-size:1.1rem;">Henüz öğrenciniz yok</h3>
    <p class="text-muted">Kurslarınıza öğrenciler kayıt olduğunda burada görünecek.</p>
  </div>
  <% } %>

<script>
  function filterTable() {
    var q = document.getElementById('studentSearch').value.toLowerCase();
    var rows = document.querySelectorAll('#studentsTable tbody tr');
    rows.forEach(function(row) {
      row.style.display = row.textContent.toLowerCase().includes(q) ? '' : 'none';
    });
  }
</script>

</asp:Content>
