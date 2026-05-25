<%@ Page Title="Yorum Yönetimi" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeBehind="Comments.aspx.cs" Inherits="EduFlow.Admin.Comments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">

    <!-- Özet Rozetler -->
    <div class="d-flex gap-2 mb-4">
        <span class="badge-level" style="padding:6px 14px;font-size:14px;">
            Bekleyen: <strong><%= PendingCount %></strong>
        </span>
        <span class="badge-free" style="padding:6px 14px;font-size:14px;">
            Onaylı: <strong><%= ApprovedCount %></strong>
        </span>
    </div>

    <!-- Bekleyen Yorumlar -->
    <h3 style="font-size:1rem;margin-bottom:14px;color:var(--color-warning)">
        <i class="bi bi-clock"></i> Onay Bekleyen Yorumlar
    </h3>

    <%= PendingHtml %>

    <!-- Onaylı Yorumlar -->
    <h3 style="font-size:1rem;margin:24px 0 14px;color:var(--color-success)">
        <i class="bi bi-check-circle"></i> Onaylı Yorumlar
    </h3>
    <div class="plain-card" style="padding:0;overflow:hidden;">
        <div class="table-responsive">
            <table class="table table-hover" style="margin:0;">
                <thead>
                    <tr>
                        <th style="padding:12px 16px;">Öğrenci</th>
                        <th>Kurs</th>
                        <th>Puan</th>
                        <th>Yorum</th>
                        <th>Tarih</th>
                        <th>İşlem</th>
                    </tr>
                </thead>
                <tbody>
                    <%= ApprovedHtml %>
                </tbody>
            </table>
        </div>
    </div>

</asp:Content>
