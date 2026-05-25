<%@ Page Title="Kurslar" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Courses.aspx.cs" Inherits="EduFlow.Courses" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Page Header -->
    <section class="page-header">
        <div class="container">
            <h1><i class="bi bi-collection-play" style="color:var(--color-accent)"></i> Kurs Kataloğu</h1>
            <p>Uzman eğitmenler tarafından hazırlanmış <%= TotalCount %> kurs arasından sana uygun olanı bul.</p>
        </div>
    </section>

    <!-- Filter + Results -->
    <section class="section">
        <div class="container">
            <!-- Filter Bar -->
            <div class="plain-card mb-4">
                <div class="row g-3 align-items-end">
                    <div class="col-md-5">
                        <label class="form-label"><i class="bi bi-search"></i> Kurs Ara</label>
                        <input class="form-control" type="search" name="q" value="<%: SearchTerm %>" placeholder="Kurs adı, konu veya eğitmen..." />
                    </div>
                    <div class="col-md-3">
                        <label class="form-label"><i class="bi bi-tag"></i> Kategori</label>
                        <select class="form-select" name="category"><%= CategoryOptionsHtml %></select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label"><i class="bi bi-bar-chart-steps"></i> Seviye</label>
                        <select class="form-select" name="level">
                            <option value="">Tüm seviyeler</option>
                            <option value="Başlangıç" <%= SelectedLevel == "Başlangıç" ? "selected" : "" %>>Başlangıç</option>
                            <option value="Orta Seviye" <%= SelectedLevel == "Orta Seviye" ? "selected" : "" %>>Orta Seviye</option>
                            <option value="İleri Seviye" <%= SelectedLevel == "İleri Seviye" ? "selected" : "" %>>İleri Seviye</option>
                        </select>
                    </div>
                    <div class="col-md-2 d-grid">
                        <label class="form-label">&nbsp;</label>
                        <button class="btn btn-primary-custom" type="submit"><i class="bi bi-filter"></i> Filtrele</button>
                    </div>
                </div>
            </div>

            <!-- Active Filters / Result Count -->
            <div class="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2">
                <p class="mb-0 text-secondary" style="font-size:15px;">
                    <strong style="color:var(--color-primary)"><%= TotalCount %></strong> kurs bulundu
                    <% if (!string.IsNullOrEmpty(SearchTerm)) { %>
                        &mdash; "<strong><%: SearchTerm %></strong>" için sonuçlar
                    <% } %>
                </p>
                <div class="d-flex gap-2 flex-wrap">
                    <% if (!string.IsNullOrEmpty(SearchTerm)) { %>
                        <a href="Courses.aspx" class="badge-level" style="cursor:pointer;text-decoration:none;">
                            <%: SearchTerm %> <i class="bi bi-x"></i>
                        </a>
                    <% } %>
                </div>
            </div>

            <!-- Course Grid -->
            <div class="row g-4"><%= CoursesHtml %></div>
        </div>
    </section>

</asp:Content>
