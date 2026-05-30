<%@ Page Title="Eğitmen Dashboard" Language="C#" MasterPageFile="~/Instructor/Instructor.master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="EduFlow.Instructor.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="InstructorContent" runat="server">

  <!-- Hoşgeldin Bandı -->
  <div style="background:var(--color-primary);border-radius:var(--radius-lg);padding:28px 32px;margin-bottom:28px;display:flex;align-items:center;gap:20px;">
    <div style="width:60px;height:60px;border-radius:50%;background:rgba(255,255,255,.12);display:flex;align-items:center;justify-content:center;font-size:26px;color:var(--color-accent);flex-shrink:0;">
      <i class="bi bi-person-video3"></i>
    </div>
    <div>
      <div style="font-size:20px;font-weight:700;color:#fff;">Hoş geldin, <%: FullName %>!</div>
      <div style="font-size:14px;color:rgba(255,255,255,.6);margin-top:4px;">İşte kurs performansına genel bir bakış.</div>
    </div>
    <a href="AddCourse.aspx" class="btn ms-auto" style="background:var(--color-accent);color:var(--color-accent-dark);font-weight:700;padding:10px 22px;border-radius:var(--radius-md);text-decoration:none;">
      <i class="bi bi-plus-lg"></i> Yeni Kurs
    </a>
  </div>

  <!-- Stat Kartları -->
  <div class="row g-3 mb-4">
    <div class="col-sm-6 col-xl-3">
      <div class="stat-card-ins">
        <div class="d-flex align-items-center gap-3 mb-1">
          <div class="stat-icon-ins" style="background:var(--color-primary-light);color:var(--color-primary);"><i class="bi bi-collection-play-fill"></i></div>
          <span class="stat-label">Toplam Kurs</span>
        </div>
        <div class="stat-value"><%= Stats.TotalCourses %></div>
      </div>
    </div>
    <div class="col-sm-6 col-xl-3">
      <div class="stat-card-ins">
        <div class="d-flex align-items-center gap-3 mb-1">
          <div class="stat-icon-ins" style="background:#E8F0FE;color:#3b5bdb;"><i class="bi bi-people-fill"></i></div>
          <span class="stat-label">Toplam Öğrenci</span>
        </div>
        <div class="stat-value"><%= Stats.TotalStudents %></div>
      </div>
    </div>
    <div class="col-sm-6 col-xl-3">
      <div class="stat-card-ins">
        <div class="d-flex align-items-center gap-3 mb-1">
          <div class="stat-icon-ins" style="background:var(--color-success-bg);color:var(--color-success);"><i class="bi bi-cash-stack"></i></div>
          <span class="stat-label">Toplam Gelir</span>
        </div>
        <div class="stat-value">₺<%= Stats.TotalRevenue.ToString("N0") %></div>
      </div>
    </div>
    <div class="col-sm-6 col-xl-3">
      <div class="stat-card-ins">
        <div class="d-flex align-items-center gap-3 mb-1">
          <div class="stat-icon-ins" style="background:var(--color-warning-bg);color:var(--color-warning);"><i class="bi bi-star-fill"></i></div>
          <span class="stat-label">Ortalama Puan</span>
        </div>
        <div class="stat-value"><%= Stats.AvgRating.ToString("F1") %></div>
        <div style="font-size:12px;color:var(--color-text-muted);margin-top:2px;">(<%= Stats.TotalReviews %> değerlendirme)</div>
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
