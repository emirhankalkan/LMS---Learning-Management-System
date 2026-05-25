<%@ Page Title="Sepetim" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="EduFlow.Cart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <section class="page-header" style="padding:28px 0;">
        <div class="container">
            <h1 style="font-size:1.6rem;margin-bottom:4px;"><i class="bi bi-cart3" style="color:var(--color-accent)"></i> Sepetim</h1>
            <p>Satın almak istediğin kurslar</p>
        </div>
    </section>

    <section class="section" style="padding-top:28px;">
        <div class="container">
            <div class="row g-4">
                <div class="col-lg-8">
                    <div class="plain-card" style="padding: 24px;">
                        <%= CartHtml %>
                    </div>
                </div>

                <!-- Summary -->
                <div class="col-lg-4">
                    <div class="cart-summary">
                        <h2 style="font-size:1.1rem;margin-bottom:16px;">Sipariş Özeti</h2>
                        <div class="d-flex justify-content-between mb-2" style="font-size:14px;">
                            <span class="text-secondary"><%= CountText %></span>
                            <span><%= SubTotalHtml %></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2" style="font-size:14px;">
                            <span class="text-secondary">İndirim</span>
                            <span style="color:var(--color-success)"><%= DiscountHtml %></span>
                        </div>
                        <hr style="border-color:var(--color-border);margin:12px 0;">
                        <div class="d-flex justify-content-between mb-3">
                            <strong>Toplam</strong>
                            <div class="cart-summary-total"><%= TotalHtml %></div>
                        </div>
                        
                        <asp:LinkButton ID="lnkCheckout" runat="server" OnClick="lnkCheckout_Click" CssClass="btn btn-accent w-100 mb-2" style="padding:12px;font-size:16px;text-align:center;display:block;">
                            <i class="bi bi-credit-card"></i> Ödemeye Geç
                        </asp:LinkButton>

                        <div class="d-flex align-items-center justify-content-center gap-6 mt-3" style="gap:12px;">
                            <i class="bi bi-shield-check" style="color:var(--color-success)"></i>
                            <span style="font-size:13px;color:var(--color-text-muted)">Güvenli ödeme &bull; 30 gün iade</span>
                        </div>
                        <div class="mt-3">
                            <label class="form-label" style="font-weight:600;font-size:13px;">İndirim Kodu</label>
                            <div class="d-flex gap-2">
                                <asp:TextBox ID="txtCouponCode" runat="server" CssClass="form-control" placeholder="Kodu girin" ClientIDMode="Static" style="text-transform:uppercase;" />
                                <asp:Button ID="btnApplyCoupon" runat="server" OnClick="btnApplyCoupon_Click" Text="Uygula" CssClass="btn btn-outline-custom btn-sm" style="white-space:nowrap;" />
                            </div>
                            <asp:Label ID="lblCouponMessage" runat="server" CssClass="d-block mt-2" style="font-size:12.5px;font-weight:500;" Visible="false" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

</asp:Content>
