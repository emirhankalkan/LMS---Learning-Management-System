<%@ Page Title="Kurs Yönetimi" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeBehind="Courses.aspx.cs" Inherits="EduFlow.Admin.Courses" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">

    <!-- Action bar -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <span class="text-muted" style="font-size:14px;">Toplam <strong style="color:var(--color-primary)"><%= TotalCoursesCount %></strong> kurs</span>
        </div>
        <div class="d-flex gap-2">
            <input class="form-control" type="search" name="q" value="<%: SearchTerm %>"
                   placeholder="Kurs / eğitmen / kategori ara..."
                   style="width:260px;"
                   onkeypress="if(event.keyCode==13){window.location='Courses.aspx?q='+encodeURIComponent(this.value); return false;}" />
            <button class="btn btn-primary-custom btn-sm" type="button"
                    onclick="alert('Yeni kurs ekleme paneli yakında aktif olacaktır!');">
                <i class="bi bi-plus-lg"></i> Yeni Kurs
            </button>
        </div>
    </div>

    <!-- Courses Table -->
    <div class="plain-card" style="padding:0;overflow:hidden;">
        <div class="table-responsive">
            <table class="table table-hover" style="margin:0;">
                <thead>
                    <tr>
                        <th style="padding:14px 16px;">#</th>
                        <th>Kurs Adı</th>
                        <th>Kategori</th>
                        <th>Eğitmen</th>
                        <th>Seviye</th>
                        <th>Fiyat</th>
                        <th>Puan</th>
                        <th>Öğrenci</th>
                    </tr>
                </thead>
                <tbody>
                    <%= CoursesTableHtml %>
                </tbody>
            </table>
        </div>
    </div>

</asp:Content>
