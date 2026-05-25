<%@ Page Title="Eğitmen Dashboard" Language="C#" MasterPageFile="~/Instructor/Instructor.master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="EduFlow.Instructor.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="InstructorContent" runat="server">

  <!-- Hoşgeldin Bandı -->
  <div style="background:linear-gradient(135deg,#0f2027,#2c5364);border-radius:16px;padding:28px 32px;margin-bottom:28px;display:flex;align-items:center;gap:20px;">
    <div style="width:60px;height:60px;border-radius:50%;background:rgba(93,240,193,.2);display:flex;align-items:center;justify-content:center;font-size:26px;color:#5DF0C1;flex-shrink:0;">
      <i class="bi bi-person-video3"></i>
    </div>
    <div>
      <div style="font-size:20px;font-weight:700;color:#fff;">Hoş geldin, <%: FullName %>! 👋</div>
      <div style="font-size:14px;color:rgba(255,255,255,.6);margin-top:4px;">İşte kurs performansına genel bir bakış.</div>
    </div>
    <a href="AddCourse.aspx" class="btn ms-auto" style="background:#5DF0C1;color:#0f2027;font-weight:700;padding:10px 22px;border-radius:10px;text-decoration:none;">
      <i class="bi bi-plus-lg"></i> Yeni Kurs
    </a>
  </div>

  <!-- Stat Kartları -->
  <div class="row g-3 mb-4">
    <div class="col-sm-6 col-xl-3">
      <div class="stat-card-ins">
        <div class="d-flex align-items-center gap-3 mb-2">
          <div class="stat-icon-ins" style="background:rgba(99,102,241,.12);color:#6366f1;"><i class="bi bi-collection-play-fill"></i></div>
          <span style="font-size:13px;color:var(--color-text-muted);">Toplam Kurs</span>
        </div>
        <div style="font-size:2rem;font-weight:800;"><%= Stats.TotalCourses %></div>
      </div>
    </div>
    <div class="col-sm-6 col-xl-3">
      <div class="stat-card-ins">
        <div class="d-flex align-items-center gap-3 mb-2">
          <div class="stat-icon-ins" style="background:rgba(59,130,246,.12);color:#3b82f6;"><i class="bi bi-people-fill"></i></div>
          <span style="font-size:13px;color:var(--color-text-muted);">Toplam Öğrenci</span>
        </div>
        <div style="font-size:2rem;font-weight:800;"><%= Stats.TotalStudents %></div>
      </div>
    </div>
    <div class="col-sm-6 col-xl-3">
      <div class="stat-card-ins">
        <div class="d-flex align-items-center gap-3 mb-2">
          <div class="stat-icon-ins" style="background:rgba(16,185,129,.12);color:#10b981;"><i class="bi bi-currency-dollar"></i></div>
          <span style="font-size:13px;color:var(--color-text-muted);">Toplam Gelir</span>
        </div>
        <div style="font-size:2rem;font-weight:800;">₺<%= Stats.TotalRevenue.ToString("N0") %></div>
      </div>
    </div>
    <div class="col-sm-6 col-xl-3">
      <div class="stat-card-ins">
        <div class="d-flex align-items-center gap-3 mb-2">
          <div class="stat-icon-ins" style="background:rgba(245,158,11,.12);color:#f59e0b;"><i class="bi bi-star-fill"></i></div>
          <span style="font-size:13px;color:var(--color-text-muted);">Ortalama Puan</span>
        </div>
        <div style="font-size:2rem;font-weight:800;"><%= Stats.AvgRating.ToString("F1") %></div>
        <div style="font-size:12px;color:var(--color-text-muted);">(<%= Stats.TotalReviews %> değerlendirme)</div>
      </div>
    </div>
  </div>

  <div class="row g-3">
    <!-- Son Kurslarım -->
    <div class="col-lg-7">
      <div class="plain-card" style="padding:0;overflow:hidden;">
        <div style="padding:18px 20px;border-bottom:1px solid var(--color-border);display:flex;justify-content:space-between;align-items:center;">
          <strong><i class="bi bi-collection-play"></i> Kurslarım</strong>
          <a href="MyCourses.aspx" style="font-size:13px;color:var(--color-primary);">Tümünü gör →</a>
        </div>
        <div class="table-responsive">
          <table class="table table-hover" style="margin:0;">
            <thead>
              <tr>
                <th style="padding:12px 16px;">Kurs</th>
                <th>Öğrenci</th>
                <th>Puan</th>
                <th>Gelir</th>
              </tr>
            </thead>
            <tbody>
              <%= CoursesPreviewHtml %>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- Son Aktivite -->
    <div class="col-lg-5">
      <div class="plain-card">
        <strong class="d-block mb-3"><i class="bi bi-activity"></i> Son Kayıtlar</strong>
        <%= RecentActivityHtml %>
      </div>
    </div>
  </div>

</asp:Content>
