<%@ Page Title="Panelim" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="EduFlow.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Page Header -->
    <section class="page-header" style="padding:28px 0;">
        <div class="container">
            <h1 style="font-size:1.6rem;margin-bottom:4px;">Hoş geldin, <strong style="color:var(--color-accent)"><%: UserName %></strong> 👋</h1>
            <p>Kayıtlı kursların ve öğrenme istatistiklerin</p>
        </div>
    </section>

    <section class="section" style="padding-top:28px;">
        <div class="container">

            <!-- Stats Row -->
            <div class="row g-3 mb-4">
                <div class="col-6 col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon"><i class="bi bi-collection-play"></i></div>
                        <div class="stat-info">
                            <div class="stat-label">Kayıtlı Kurs</div>
                            <div class="stat-value"><%= EnrolledCount %></div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon"><i class="bi bi-check2-circle"></i></div>
                        <div class="stat-info">
                            <div class="stat-label">Tamamlanan Ders</div>
                            <div class="stat-value"><%= CompletedCount %></div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon"><i class="bi bi-clock-history"></i></div>
                        <div class="stat-info">
                            <div class="stat-label">Toplam Süre</div>
                            <div class="stat-value"><%= DurationText %></div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon"><i class="bi bi-award"></i></div>
                        <div class="stat-info">
                            <div class="stat-label">Sertifika</div>
                            <div class="stat-value"><%= CertificateCount %></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Enrolled Courses -->
            <h2 style="font-size:1.3rem;margin-bottom:20px;">Kurslarım</h2>
            <div class="row g-4">
                <%= EnrolledCoursesHtml %>
            </div>

            <!-- Suggested -->
            <div class="d-flex justify-content-between align-items-center mt-5 mb-3">
                <h2 style="font-size:1.3rem;margin-bottom:0;">Sana Önerilen</h2>
                <a href="Courses.aspx" class="btn btn-outline-custom btn-sm">Tüm kurslar</a>
            </div>
            <div class="row g-4"><%= SuggestedHtml %></div>

        </div>
    </section>

</asp:Content>
