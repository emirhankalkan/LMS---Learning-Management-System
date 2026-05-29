<%@ Page Title="Siparişlerim" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OrderHistory.aspx.cs" Inherits="EduFlow.OrderHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <section class="page-header" style="padding:28px 0;">
        <div class="container">
            <h1 style="font-size:1.6rem;margin-bottom:4px;"><i class="bi bi-receipt" style="color:var(--color-accent)"></i> Sipariş Geçmişim</h1>
            <p>Tüm satın alma işlemlerini ve ödeme durumlarını görüntüle</p>
        </div>
    </section>

    <section class="section" style="padding-top:28px;">
        <div class="container">

            <% if (!string.IsNullOrEmpty(Message)) { %>
            <div class="alert alert-info mb-4"><i class="bi bi-info-circle"></i> <%: Message %></div>
            <% } %>

            <% if (Orders.Count == 0) { %>
            <div class="plain-card p-5 text-center">
                <i class="bi bi-receipt" style="font-size:3rem;color:var(--color-text-muted)"></i>
                <h3 class="mt-3" style="color:var(--color-text-secondary)">Henüz hiç siparişiniz yok</h3>
                <p class="text-muted">Kurs satın aldığınızda siparişleriniz burada görünür.</p>
                <a href="Courses.aspx" class="btn btn-primary-custom mt-2">Kursları Keşfet</a>
            </div>
            <% } else { %>

            <!-- İstatistik kartları -->
            <div class="row g-3 mb-4">
                <div class="col-6 col-md-3">
                    <div class="plain-card text-center" style="padding:20px;">
                        <div style="font-size:1.8rem;font-weight:500;color:var(--color-primary)"><%: Orders.Count %></div>
                        <div style="font-size:13px;color:var(--color-text-muted)">Toplam Sipariş</div>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="plain-card text-center" style="padding:20px;">
                        <div style="font-size:1.8rem;font-weight:500;color:var(--color-success)"><%: CompletedCount %></div>
                        <div style="font-size:13px;color:var(--color-text-muted)">Tamamlanan</div>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="plain-card text-center" style="padding:20px;">
                        <div style="font-size:1.8rem;font-weight:500;color:var(--color-primary)">₺<%: TotalSpent.ToString("N0") %></div>
                        <div style="font-size:13px;color:var(--color-text-muted)">Toplam Harcama</div>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="plain-card text-center" style="padding:20px;">
                        <div style="font-size:1.8rem;font-weight:500;color:var(--color-warning)"><%: PendingCount %></div>
                        <div style="font-size:13px;color:var(--color-text-muted)">Bekleyen</div>
                    </div>
                </div>
            </div>

            <!-- Sipariş listesi -->
            <div class="plain-card" style="padding:0;overflow:hidden;">
                <div style="padding:16px 20px;border-bottom:1px solid var(--color-border);display:flex;align-items:center;justify-content:space-between;">
                    <h2 style="font-size:1rem;margin:0;"><i class="bi bi-list-ul" style="color:var(--color-primary)"></i> Siparişler</h2>
                    <span style="font-size:13px;color:var(--color-text-muted)"><%: Orders.Count %> sipariş</span>
                </div>
                <%: new System.Web.HtmlString(OrderRowsHtml) %>
            </div>

            <% } %>
        </div>
    </section>

</asp:Content>
