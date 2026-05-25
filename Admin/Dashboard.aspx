<%@ Page Title="Yönetim Paneli" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="EduFlow.Admin.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">

    <!-- Stat Cards -->
    <div class="row g-3 mb-4">
        <div class="col-6 col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background:#EEF2FF;color:#4F46E5"><i class="bi bi-people"></i></div>
                <div class="stat-info">
                    <div class="stat-label">Toplam Kullanıcı</div>
                    <div class="stat-value"><%= TotalUsers %></div>
                </div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background:#FFF7ED;color:#EA580C"><i class="bi bi-collection-play"></i></div>
                <div class="stat-info">
                    <div class="stat-label">Toplam Kurs</div>
                    <div class="stat-value"><%= TotalCourses %></div>
                </div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background:var(--color-success-bg);color:var(--color-success)"><i class="bi bi-receipt"></i></div>
                <div class="stat-info">
                    <div class="stat-label">Toplam Sipariş</div>
                    <div class="stat-value"><%= TotalOrders %></div>
                </div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background:var(--color-warning-bg);color:var(--color-accent-dark)"><i class="bi bi-currency-dollar"></i></div>
                <div class="stat-info">
                    <div class="stat-label">Toplam Gelir</div>
                    <div class="stat-value"><%= TotalRevenue %></div>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Info Row -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="plain-card">
                <h3 style="font-size:1rem;margin-bottom:14px;"><i class="bi bi-chat-square-text" style="color:var(--color-primary)"></i> Bekleyen Yorumlar</h3>
                <div style="display:flex;align-items:center;justify-content:space-between;">
                    <span style="font-size:2rem;font-weight:500;color:var(--color-warning);"><%= PendingReviews %></span>
                    <a href="Comments.aspx" class="btn btn-outline-custom btn-sm">Onayla</a>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="plain-card">
                <h3 style="font-size:1rem;margin-bottom:14px;"><i class="bi bi-people" style="color:var(--color-primary)"></i> Yeni Kayıtlar (Bu Hafta)</h3>
                <div style="display:flex;align-items:center;justify-content:space-between;">
                    <span style="font-size:2rem;font-weight:500;color:var(--color-success);">0</span>
                    <a href="Users.aspx" class="btn btn-outline-custom btn-sm">Görüntüle</a>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="plain-card">
                <h3 style="font-size:1rem;margin-bottom:14px;"><i class="bi bi-badge-ad" style="color:var(--color-primary)"></i> Aktif Reklamlar</h3>
                <div style="display:flex;align-items:center;justify-content:space-between;">
                    <span style="font-size:2rem;font-weight:500;color:var(--color-primary);">0</span>
                    <a href="Ads.aspx" class="btn btn-outline-custom btn-sm">Yönet</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Courses Table Preview -->
    <div class="plain-card">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 style="font-size:1rem;margin-bottom:0;"><i class="bi bi-collection-play" style="color:var(--color-primary)"></i> Son Eklenen Kurslar</h3>
            <a href="Courses.aspx" class="btn btn-primary-custom btn-sm">Tüm kurslar</a>
        </div>
        <div class="table-responsive">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Kurs Adı</th>
                        <th>Kategori</th>
                        <th>Eğitmen</th>
                        <th>Seviye</th>
                        <th>Fiyat</th>
                        <th>Öğrenci</th>
                        <th>Puan</th>
                    </tr>
                </thead>
                <tbody>
                    <%= CoursesTableHtml %>
                </tbody>
            </table>
        </div>
    </div>

</asp:Content>
