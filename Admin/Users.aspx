<%@ Page Title="Kullanıcı Yönetimi" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="EduFlow.Admin.Users" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <span class="text-muted" style="font-size:14px;">Toplam <strong style="color:var(--color-primary)"><%= TotalUsersCount %></strong> kullanıcı</span>
        <input class="form-control" type="search" name="q" value="<%: SearchTerm %>" placeholder="Ad veya e-posta ile ara..." style="width:240px;" onkeypress="if(event.keyCode==13){window.location='Users.aspx?q='+this.value; return false;}" />
    </div>

    <div class="plain-card" style="padding:0;overflow:hidden;">
        <div class="table-responsive">
            <table class="table table-hover" style="margin:0;">
                <thead>
                    <tr>
                        <th style="padding:14px 16px;">#</th>
                        <th>Ad Soyad</th>
                        <th>E-posta</th>
                        <th>Rol</th>
                        <th>Kayıt Tarihi</th>
                        <th>Durum</th>
                        <th>İşlemler</th>
                    </tr>
                </thead>
                <tbody>
                    <%= UsersTableHtml %>
                </tbody>
            </table>
        </div>
    </div>

</asp:Content>
