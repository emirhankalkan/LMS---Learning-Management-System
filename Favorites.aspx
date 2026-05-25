<%@ Page Title="Favorilerim" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Favorites.aspx.cs" Inherits="EduFlow.Favorites" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <section class="page-header" style="padding:28px 0;">
        <div class="container">
            <h1 style="font-size:1.6rem;margin-bottom:4px;"><i class="bi bi-heart-fill" style="color:var(--color-accent)"></i> Favorilerim</h1>
            <p>Beğendiğin ve daha sonra almayı düşündüğün kurslar</p>
        </div>
    </section>

    <section class="section" style="padding-top:28px;">
        <div class="container">

            <!-- Stats -->
            <div class="d-flex align-items-center gap-3 mb-4">
                <span class="badge-level" style="padding:6px 14px;font-size:14px;"><i class="bi bi-heart"></i> <%= FavoriteCountText %></span>
            </div>

            <div class="row g-4">
                <%= FavoritesHtml %>
            </div>

        </div>
    </section>

</asp:Content>
